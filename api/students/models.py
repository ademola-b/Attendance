from django.contrib.auth import get_user_model
from django.contrib.postgres.fields import ArrayField
from django.db import models
from django.utils.translation import gettext_lazy as _

def profile_picture_dir(instance, filename):
    return '{0}/{1}'.format(instance.user_id.username, filename)

# Create your models here.
level_choices = [
    ('100', '100'),
    ('200', '200'),
    ('300', '300'),
    ('400', '400')
]

class Level(models.Model):
    levelInit = models.CharField(max_length=5, choices=level_choices, default='100', unique=True)

    def __str__(self):
        return self.levelInit

class Department(models.Model):
    deptName = models.CharField(max_length=50, unique=True)
    
    def __str__(self):
        return self.deptName

class Course(models.Model):
    # student_id = models.OneToOneField("students.Student", verbose_name=_(""), on_delete=models.CASCADE)
    course_code = models.CharField(_("Course Code"), max_length=50)
    course_title = models.CharField(_("Course Title"), max_length=100)

    def __str__(self):
        return '{0}'.format(self.course_code) 
    
class Student(models.Model):
    user_id = models.OneToOneField(get_user_model(), null=True, on_delete=models.CASCADE)
    profile_pic = models.ImageField(_("profile picture"), upload_to=profile_picture_dir)
    department_id = models.ForeignKey(Department, on_delete=models.CASCADE)
    level = models.CharField(max_length=5, choices=level_choices, default='100')
    # level_id = models.ForeignKey(Level, on_delete=models.CASCADE)
    course_title = ArrayField(base_field=models.CharField(max_length=20), null = True)

    def __str__(self):
        return self.user_id.username

class StudentCourse(models.Model):
    student_id = models.ForeignKey("students.Student", on_delete=models.CASCADE)
    course_id = models.ForeignKey(Course, null=True, on_delete=models.SET_NULL)

    def __str__(self):
        return '{0} - {1}'.format(self.student_id.user_id.username, self.course_id.course_title) 

class StudentFace(models.Model):
    student_id = models.OneToOneField(Student, on_delete=models.CASCADE)
    student_face = ArrayField(base_field=models.FloatField())

    def __str__(self):
        return self.student_id.user_id.username