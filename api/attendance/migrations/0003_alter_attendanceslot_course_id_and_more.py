# Generated by Django 4.1.4 on 2023-01-05 14:44

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('students', '0007_remove_student_level_id_student_level'),
        ('lecturers', '0001_initial'),
        ('attendance', '0002_attendanceslot_department_id_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='attendanceslot',
            name='course_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='students.course', verbose_name='course id'),
        ),
        migrations.AlterField(
            model_name='attendanceslot',
            name='department_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='students.department', verbose_name='department id'),
        ),
        migrations.AlterField(
            model_name='attendanceslot',
            name='lecturer_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='lecturers.lecturer'),
        ),
    ]
