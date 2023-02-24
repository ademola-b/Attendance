from django.contrib.auth import get_user_model

from rest_framework import serializers
from . models import AttendanceSlot, Attendance
from students.models import Student, Course, Department

class AttendanceSlotMiniSerializer(serializers.ModelSerializer):
    course_id = serializers.SlugField(read_only=True)
    class Meta:
        model = AttendanceSlot
        fields = [
            'id',
            'course_id',
            'date'
        ]

class CourseMini(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'

class Dept(serializers.ModelSerializer):
    class Meta:
        model = Department
        fields = '__all__'


class AttendanceSlotViewSerializer(serializers.ModelSerializer):
    department_id = Dept()
    lecturer_id = serializers.StringRelatedField()
    course_id = CourseMini()
    class Meta:
        model = AttendanceSlot
        fields = '__all__'

class AttendanceSlotCreateSerializer(serializers.ModelSerializer):
    # course_id = serializers.SlugRelatedField(slug_field='course_code', read_only=True)
    # department_id = Dept()
    # # lecturer_id = serializers.StringRelatedField()
    # course_id = CourseMini()

    class Meta:
        model = AttendanceSlot
        fields = [
        "date",
        "start_time",
        "end_time",
        "longitude",
        "latitude",
        "radius",
        "status",
        "department_id",
      "course_id"
        ]

    # def create(self, validated_data):
    #     # course =  validated_data.pop('course_id')
    #     course = Course.objects.get(pk = validated_data.pop('course_id'))
    #     instance = AttendanceSlot.objects.create(**validated_data)
    #     for c in course:
    #         Course.objects.create(**c)
    #     # instance.course_id = course
    #     # instance.save()
    #     return instance

    # def create(self, validated_data):
    #     # course =  validated_data.pop('course_id')
    #     dep = Department.objects.get(pk = validated_data.pop('department_id'))
    #     instance = AttendanceSlot.objects.create(**validated_data)
    #     # for c in dep:
    #     #     Department.objects.create(**c)
    #     instance.course_id = dep
    #     instance.save()
    #     return instance
    
    # def to_representation(self, instance):
    #     representation = super(AttendanceSlotSerializer, self).to_representation(instance)
    #     return representation

class AttendanceListSerializer(serializers.ModelSerializer):
    slot_id = AttendanceSlotMiniSerializer(required=False, read_only=True)
    class Meta:
        model = Attendance
        fields = ['id','slot_id', 'student_id', 'performance' ]



# class AttendanceSerializer(serializers.ModelSerializer):
#     # student_id = serializers.SlugField(read_only=True)
#     att_slot = AttendanceSlotMiniSerializer(required=False, read_only=True)
#     class Meta:
#         model = Attendance
#         fields = ['id','att_slot', 'slot_id', 'student_id', 'performance']

class AttendanceSerializer(serializers.ModelSerializer):
    # student_id = serializers.SlugField(read_only=True)
    slot_id = AttendanceSlotMiniSerializer(required=False, read_only=True)
    class Meta:
        model = Attendance
        fields = ['slot_id']

    def create(self, validated_data):
        slot_id = self.context['view'].kwargs['slot_id']
        
        slot = AttendanceSlot.objects.get(id=slot_id)
        return Attendance.objects.create(slot_id=slot, **validated_data)


