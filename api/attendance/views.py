from datetime import datetime, time
from django.http import Http404, HttpResponse

from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import (ListAPIView,  ListCreateAPIView, 
                                     UpdateAPIView, RetrieveDestroyAPIView)
from rest_framework.response import Response

from lecturers.models import Lecturer
from students.models import Course, Student
from . models import AttendanceSlot, Attendance, Performance
from . serializers import (AttendanceSlotCreateSerializer, AttendanceSlotViewSerializer,
                            AttendanceSlotUpdateSerializer, AttendanceSerializer,
                            AttendanceListSerializer, PerformanceSerializer, AttendanceReportSerializer)
# Create your views here.

def TimeDiff(end_time):
    current_time = datetime.now().strftime("%H:%M:%S")
    # print(type(current_time))
    end_time = str(end_time)
    t1 = datetime.strptime(end_time, "%H:%M:%S")
    t2 = datetime.strptime(current_time, "%H:%M:%S")
    time_diff = t2 - t1
    if time_diff.total_seconds() >= 60:
        return True
    else:
        return False



#view to create attendance slot
class AttendanceSlotCreate(ListCreateAPIView):
    queryset = AttendanceSlot.objects.all()
    serializer_class = AttendanceSlotCreateSerializer

    def perform_create(self, serializer):
        serializer.save(lecturer_id=self.request.user.lecturer)
        return super().perform_create(serializer)

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
        
        if not user.is_authenticated:
            return AttendanceSlot.objects.none()
        if user.is_staff:
            return AttendanceSlot.objects.all()
        if user.user_type == 'lecturer':
            return AttendanceSlot.objects.filter(lecturer_id = request.user.lecturer)
        student_department = request.user.student.department_id.deptName      
        return qs.filter(course_id__course_code__in = request.user.student.courses, department_id__deptName = student_department).order_by('-id')[:1]

#to view attendance slots
class AttendanceSlotsView(ListAPIView):
    queryset = AttendanceSlot.objects.all()
    serializer_class = AttendanceSlotViewSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
       
        if not user.is_authenticated:
            return AttendanceSlot.objects.none()
        if user.is_staff:
            return AttendanceSlot.objects.all()
        if user.user_type == 'lecturer':
            return AttendanceSlot.objects.filter(lecturer_id = request.user.lecturer, status = 'ongoing')
        # if user.user_type == 'student':
        #     return AttendanceSlot.objects.filter(department_id__deptName = student_department)

        student_department = request.user.student.department_id.deptName      
        return qs.filter(course_id__course_code__in = request.user.student.courses, department_id__deptName = student_department, status = 'ongoing')

class GetAttendanceSlot(RetrieveDestroyAPIView):
    queryset = AttendanceSlot.objects.all()
    serializer_class = AttendanceSlotViewSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
        if not user.is_authenticated:
            return AttendanceSlot.objects.none()
        if user.is_staff:
            return AttendanceSlot.object.all()
        if user.user_type == 'lecturer':
            return AttendanceSlot.objects.filter(lecturer_id = request.user.lecturer)
        student_department = request.user.student.department_id.deptName
        return qs.filter(course_id__course_code__in = request.user.student.courses, department_id__deptName = student_department)

    
    # def update(self, request, *args, **kwargs):
    #     data = request.data
    #     # qs = AttendanceSlot.objects.filter(status = 'ongoing')
    #     print(f"data: {data}")
    #     data_stat = AttendanceSlot.objects.filter(status = 'ongoing')
    #     data_stat.status = 'elapsed'
    #     data_stat = AttendanceSlot.objects.update('elapsed', ['status'])
    #     # data_stat = AttendanceSlot.objects.update(status = 'elapsed')

    #     serializer = AttendanceSlotViewSerializer(data = data)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response(serializer.data, status = status.HTTP_204_NO_CONTENT)
    #     else:
    #         return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

class UpdateAttendanceSlot(UpdateAPIView):
    queryset = AttendanceSlot.objects.all()
    serializer_class = AttendanceSlotUpdateSerializer

    def update_slot(self):
        current_time = datetime.now().strftime("%H:%M:%S")
        # print("Attendance slot updating")

        try:
            queryset = AttendanceSlot.objects.filter(status='ongoing')
            for instance in queryset:
                end_time = str(instance.end_time)
                t1 = datetime.strptime(end_time, "%H:%M:%S")
                t2 = datetime.strptime(current_time, "%H:%M:%S")
                time_diff = t1 - t2
                print(f'course: {instance.course_id.course_code}')
                students_list = Student.objects.filter(courses__contains = [instance.course_id.course_code])
                print(f't1:{t1}')
                print(f't2:{t2}')
                print(f'student: {students_list}')
                if t1 == t2 or t2 > t1:
                    print(f'both times equal')
                    instance.status = 'elapsed'
                    print('Slot Updated')
                    present1 = Attendance.objects.filter(student_id = students_list[0], slot_id__course_id__course_code = instance.course_id.course_code).count()
                    print(f'present: {present1}')

                    for std_instance in students_list:
                        present = Attendance.objects.filter(student_id = std_instance, slot_id__course_id__course_code = instance.course_id.course_code).count()
                        slot = AttendanceSlot.objects.filter(course_id__course_code = instance.course_id.course_code).count()
                        performance = present/slot * 100
                        print(f'present: {present}')
                        print(f'slot: {slot}')

                        perf = {'performance_percent':performance,}
                        Performance.objects.update_or_create(
                                                student = std_instance, 
                                                course = instance.course_id,
                                                defaults=perf)

                    instance.save()
                else:
                    print('All slots updated')
        except AttendanceSlot.DoesNotExist:
            print('Attendance slot does npt exist')
            pass
        
    # not used        
    # def put(self, request, *args, **kwargs):
    #     print("from put method")
    #     try:
    #         queryset = AttendanceSlot.objects.filter(status='ongoing')
    #     except AttendanceSlot.DoesNotExist:
    #         return Response(status = status.HTTP_400_BAD_REQUEST)
    #     for instance in queryset:
    #         print(type(instance.end_time))
    #         time_diff = TimeDiff(instance.end_time)
    #         if time_diff:
    #             serializer = self.serializer_class(instance, data = request.data)
    #             if serializer.is_valid():
    #                 serializer.save()
    #                 return Response(serializer.data)
    #             return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
    #     return Response(status=status.HTTP_204_NO_CONTENT)

class AttendanceList(ListAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceListSerializer

class AttendanceCreate(ListCreateAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceSerializer

    def get_queryset(self, *args, **kwargs):
        queryset = super().get_queryset(*args, **kwargs)
        slot_id = self.kwargs.get('slot_id')
        if not self.request.user.is_authenticated:
            return Attendance.objects.none()
        if self.request.user.is_staff:
            return Attendance.objects.all()
        if  not Attendance.objects.filter(slot_id=slot_id, student_id=self.request.user.student).exists():
            return Attendance.objects.none()
        return queryset.filter(slot_id=slot_id)

    def perform_create(self, serializer):
        serializer.save(student_id = self.request.user.student)
        present = Attendance.objects.filter(student_id = self.request.user.student, slot_id__course_id__course_code__in = self.request.user.student.courses).count()
        course = Attendance.objects.filter(slot_id__course_id__course_code__in = self.request.user.student.courses)[0]
        slot = AttendanceSlot.objects.filter(course_id__course_code = course.slot_id.course_id.course_code).count()
    
        # print(f"course: {course.slot_id.course_id.course_code}")
        # print(f"present slot: {present}")
        # print(f"slot: {slot}")
        performance = present/slot * 100
        print(f"present: {present}\n slot: {slot}\n performance: {performance}")
        perf = {'performance_percent':performance,}
        Performance.objects.update_or_create(
                                            student = self.request.user.student, 
                                            course = course.slot_id.course_id.course_code,
                                            defaults=perf)

        return super().perform_create(serializer)

class PerformanceView(ListAPIView):
    queryset = Performance.objects.all()
    serializer_class = PerformanceSerializer

    def get_queryset(self, *args, **kwargs):
        # qs = super().get_queryset()
        qs = Performance.objects.all()
        request = self.request
        user = request.user
        # course = self.kwargs['course']
        course = self.request.query_params.get("course")
        # print(f"Course: {course}")

        if user.is_staff:
            return Performance.objects.all()
        if not user.is_authenticated:
            return Performance.objects.none()
        if user.user_type == 'lecturer':
            return Performance.objects.filter(course = request.user.lecturer.course_id.course_code)
        if course is not None:
            return qs.filter(course = course, student = request.user.student)
        
        return qs.filter(course__in = request.user.student.courses, student = request.user.student)

class GenerateAttendanceReport(ListAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceReportSerializer
    
    def get_queryset(self, *args, **kwargs):
        qs = super().get_queryset(*args, **kwargs)
        request = self.request
        user = request.user
        from_date = self.request.query_params.get("from")
        to_date = self.request.query_params.get("to")

        print(f'from: {from_date}')
        print(f'to: {to_date}')
        # print(f'course: {request.user.lecturer.course_id.course_code}')
        if not user.is_authenticated:
            return Attendance.objects.none()
        if user.user_type == 'lecturer':
            return Attendance.objects.filter(slot_id__date__range = (from_date, to_date), slot_id__course_id__course_code = request.user.lecturer.course_id.course_code)
        if user.user_type == 'student':
            return Attendance.objects.none()
        return None
        # return qs.filter(slot_id__radius = 100.0)
    

# class Attendance(ListCreateAPIView):
#     queryset = Attendance.objects.all()
#     lookup_field = 'slot_id'
#     serializer_class = AttendanceSerializer

#     def get_queryset(self, *args, **kwargs):
#         queryset = super().get_queryset(*args, **kwargs)
#         slot_id = self.kwargs.get('slot_id')
#         if not AttendanceSlot.objects.filter(id=slot_id).exists():
#             raise Http404()

#         return queryset.filter(slot_id=slot_id)

#     def post(self, request, *args, **kwargs):

#         attendance_data = {
#             'slot_id': kwargs.get('slot_id'),
#             'student_id': self.request.user.student.id,
#             'performance': request.data['performance']
#         }

#         serializer = AttendanceSerializer(data=attendance_data)
#         serializer.is_valid(raise_exception=True)
#         serializer.save()
#         return Response(serializer.data, status=status.HTTP_201_CREATED)
    

    



