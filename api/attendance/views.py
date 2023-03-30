from datetime import datetime, time

from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import (ListAPIView,  ListCreateAPIView, 
                                     UpdateAPIView, RetrieveDestroyAPIView)
from rest_framework.response import Response

from students.models import Course
from . models import AttendanceSlot, Attendance, Performance
from . serializers import (AttendanceSlotCreateSerializer, 
                           AttendanceSlotViewSerializer, AttendanceSlotUpdateSerializer,
                           AttendanceSerializer, AttendanceListSerializer)
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
        return qs.filter(course_id__course_code__in = request.user.student.course_title, department_id__deptName = student_department).order_by('-id')[:1]

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
        return qs.filter(course_id__course_code__in = request.user.student.course_title, department_id__deptName = student_department, status = 'ongoing')

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


    def put(self, request, *args, **kwargs):
        try:
            queryset = AttendanceSlot.objects.filter(status='ongoing')
        except AttendanceSlot.DoesNotExist:
            return Response(status = status.HTTP_400_BAD_REQUEST)
        for instance in queryset:
            print(type(instance.end_time))
            time_diff = TimeDiff(instance.end_time)
            if time_diff:
                serializer = self.serializer_class(instance, data = request.data)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data)
                return Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
        return Response(status=status.HTTP_204_NO_CONTENT)

class AttendanceList(ListAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceListSerializer

class AttendanceCreate(ListCreateAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceSerializer

    def perform_create(self, serializer):
        serializer.save(student_id = self.request.user.student)
        courses = Course.objects.all()
        present = Attendance.objects.filter(student_id = self.request.user.student, slot_id__course_id__course_code__in = self.request.user.student.courses).count()
        course = Attendance.objects.filter(slot_id__course_id__course_code__in = self.request.user.student.courses)[0]
    
        print(f"course: {course.slot_id.course_id.course_code}")
        # for p in present:
        print(f"present slot: {present}")
        # print(f"present slot: {present.student_id}")
        slot = AttendanceSlot.objects.filter(course_id__course_code = course.slot_id.course_id.course_code).count()
        print(f"slot: {slot}")
        performance = present/slot * 100
        print(f"present: {present}\n slot: {slot}\n performance: {performance}")
        # Performance.objects.create(student = request.user.student, course=, performance_percent = performance)
        perf = {'performance_percent':performance,}
        Performance.objects.update_or_create(
                                            student = self.request.user.student, 
                                            course = course.slot_id.course_id.course_code, 
                                            # course__in = self.request.user.student.courses, 
                                            defaults=perf)

        return super().perform_create(serializer)

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
    

    



