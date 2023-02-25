import base64
from rest_framework import serializers
from students.models import Course
from students.serializers import UserMiniSerializer
from . models import Lecturer

class CourseMini(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'

class LecturersDetail(serializers.ModelSerializer):
    user_id = UserMiniSerializer()
    department_id = serializers.StringRelatedField()
    course_id = CourseMini()
    pic_mem = serializers.SerializerMethodField("get_image_memory")
    class Meta:
        model = Lecturer
        fields = [
        "id",
        "profile_pic",
        "pic_mem",
        "level",
        "user_id",
        "department_id",
        "course_id"
        ]

    def get_image_memory(request, lect:Lecturer):
        with open(lect.profile_pic.name, 'rb') as loadedfile:
            return base64.b64encode(loadedfile.read())