# Generated by Django 4.1.4 on 2023-01-08 02:40

import django.contrib.postgres.fields
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('students', '0007_remove_student_level_id_student_level'),
    ]

    operations = [
        migrations.AlterField(
            model_name='studentface',
            name='student_face',
            field=django.contrib.postgres.fields.ArrayField(base_field=models.IntegerField(), size=None),
        ),
    ]
