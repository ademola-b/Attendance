import base64
from django.contrib.auth import get_user_model
from rest_framework import serializers
from . models import Student, StudentFace, Department

class UserMiniSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id', 'username', 'first_name', 'last_name', 'email']

class StudentMiniSerializer(serializers.ModelSerializer):
    user_id = UserMiniSerializer(read_only=True, required = False)
    class Meta:
        model = Student
        fields = [
            'user_id'
        ]

class StudentsListSerializer(serializers.ModelSerializer):
    user_id = UserMiniSerializer(read_only=True, required = False)
    department_id = serializers.StringRelatedField()
    courses = serializers.ListField(child=serializers.CharField(max_length=10))
    profile_pic_memory = serializers.SerializerMethodField("get_image_memory")
    class Meta:
        model = Student
        fields = [
            'user_id',
            'profile_pic',
            'department_id',
            'level',
            'courses',
            'profile_pic_memory'
        ]

    #store image in memory - convert image path to bin
    def get_image_memory(request, student:Student):
        with open(student.profile_pic.name, 'rb') as loadedfile:
            return base64.b64encode(loadedfile.read()) #encode the image as base64


class StudentFaceSerializer(serializers.ModelSerializer):
    # student_id = serializers.SlugField(read_only=True)
    class Meta:
        model = StudentFace
        fields = ['student_face']

class StudentCourses(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['courses']

class DepartmentsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = '__all__'