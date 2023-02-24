from django.contrib import admin

from . models import Attendance, AttendanceSlot
# Register your models here.

admin.site.register(Attendance)
admin.site.register(AttendanceSlot)