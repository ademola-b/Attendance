from django.db import models
from django.utils.translation import gettext_lazy as _

# Create your models here.

class AttendanceSlot(models.Model):
    department_id = models.ForeignKey("students.Department", verbose_name=_("department id"), on_delete=models.CASCADE)
    course_id = models.ForeignKey("students.Course", verbose_name=_("course id"), related_name= 'course', on_delete=models.CASCADE)
    lecturer_id = models.ForeignKey("lecturers.Lecturer", on_delete=models.CASCADE)
    date = models.DateField(_("attendance date"), auto_now=False, auto_now_add=True)
    start_time = models.TimeField(_("start time"), auto_now=False, auto_now_add=False)
    end_time = models.TimeField(auto_now=False, auto_now_add=False)
    longitude = models.CharField(_("longitude"), max_length=50)
    latitude = models.CharField(_("latitude"), max_length=50)
    radius = models.CharField(_("radius"), max_length=50)
    status = models.CharField(_("status"), max_length=50, choices= [("ongoing", "ongoing"), ("elapsed", "elapsed")], default="ongoing")

    def __str__(self):
        return '{0} - {1}'.format(self.lecturer_id.user_id.username, self.course_id.course_code)

class Attendance(models.Model):
    slot_id = models.ForeignKey("attendance.AttendanceSlot", verbose_name=_("attendance slot"), on_delete=models.CASCADE)
    student_id = models.ForeignKey("students.Student", on_delete=models.CASCADE)
   
    def __str__(self):
        return '{0} - {1}'.format("attendance for ", self.slot_id)

class Performance(models.Model):
    # attendance = models.ForeignKey("attendance.Attendance", verbose_name=_("Attendance"), on_delete=models.CASCADE)
    student = models.ForeignKey("students.Student", verbose_name=_("Student"), on_delete=models.CASCADE)
    # course = models.ForeignKey("students.Course", verbose_name=_("Course"), on_delete=models.CASCADE)
    course = models.CharField(verbose_name=_("Course"), max_length=10)
    performance_percent = models.FloatField(null=True, blank=True)
    