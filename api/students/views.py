from django.shortcuts import render

from accounts.models import CustomUser

from . models import Student, StudentFace, Department

from . serializers import StudentCourses, StudentsListSerializer, StudentFaceSerializer, DepartmentsSerializer
from rest_framework.generics import ListAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView

# Create your views here.
class UsersList(ListCreateAPIView):
    queryset = CustomUser.objects.all()

class StudentsList(ListCreateAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentsListSerializer

    def get_queryset(self, *args, **kwargs):
        qs = super().get_queryset(*args, **kwargs)
        request = self.request
        user = request.user
        try:
            if user.is_staff and user.is_authenticated:
                return Student.objects.all()
            else:
                return Student.objects.none()
        except:
            user = None
        # return qs
    

class GetStudent(RetrieveUpdateDestroyAPIView):
    queryset = Student.objects.all()
    lookup_field = 'user_id__username'
    serializer_class = StudentsListSerializer
    
    # def get_queryset(self):
    #     username = self.kwargs['username']
    #     return Student.objects.filter(user_id__username=username)

    # def get_queryset(self):
    #     qs = super().get_queryset()
    #     request = self.request
    #     user = request.user
    #     if not user.is_authenticated:
    #         return Student.objects.none()
        
    #     return qs.filter(user = request.user.student)


class GetStudentCourse(RetrieveUpdateDestroyAPIView):
    queryset = Student.objects.all()
    lookup_field = 'user_id__username'
    serializer_class = StudentCourses

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
        
        if not user.is_authenticated:
            return Student.objects.none()
        if user.is_staff:
            return Student.objects.all()
        return qs.filter(courses = request.user.student.courses) 
    
    
class StudentFaceView(ListCreateAPIView):
    queryset = StudentFace.objects.all()
    serializer_class = StudentFaceSerializer

    def perform_create(self, serializer):
        serializer.save(student_id = self.request.user.student)
        return super().perform_create(serializer)
    
    def get_queryset(self, *args, **kwargs):
        queryset = super().get_queryset(*args, **kwargs)
        request = self.request
        user = request.user

        if not user.is_authenticated:
            return StudentFace.objects.none()
        elif user.is_staff:
            return StudentFace.objects.all() 
        return queryset.filter(student_id = request.user.student)

class DeptsView(ListCreateAPIView):
    serializer_class = DepartmentsSerializer
    queryset = Department.objects.all()



    