from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext_lazy as _
from students.models import (Course, Department, 
                             level_choices, profile_picture_dir)

# Create your models here.
class Lecturer(models.Model):
    user_id = models.OneToOneField(get_user_model(), null=True, on_delete=models.CASCADE)
    profile_pic = models.ImageField(_("profile picture"), upload_to=profile_picture_dir)
    department_id = models.ForeignKey(Department, on_delete=models.CASCADE)
    level = models.CharField(max_length=5, choices=level_choices, default='100')
    course_id = models.ForeignKey(Course, on_delete=models.CASCADE)

    def __str__(self):
        return self.user_id.username
    