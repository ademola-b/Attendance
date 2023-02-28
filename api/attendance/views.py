from django.shortcuts import render
from rest_framework import status
from rest_framework.generics import ListAPIView,  ListCreateAPIView, RetrieveDestroyAPIView
from . models import AttendanceSlot, Attendance
from . serializers import AttendanceSlotCreateSerializer, AttendanceSlotViewSerializer, AttendanceSerializer, AttendanceListSerializer
# Create your views here.

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
        return qs.filter(course_id__course_code__in = request.user.student.course_title, department_id__deptName = student_department)
    

class AttendanceList(ListAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceListSerializer

class Attendance(ListCreateAPIView):
    queryset = Attendance.objects.all()
    serializer_class = AttendanceSerializer

    def perform_create(self, serializer):
        serializer.save(student_id = self.request.user.student)
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
    

    



