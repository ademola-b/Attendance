from django.contrib import admin

from . models import Level, Department, Course, Student, StudentFace, StudentCourse
# Register your models here.

admin_models = [Level, Department, Course, Student, StudentCourse, StudentFace]

for i in admin_models:
    admin.site.register(i)
