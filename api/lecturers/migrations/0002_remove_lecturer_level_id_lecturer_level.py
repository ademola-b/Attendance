# Generated by Django 4.1.5 on 2023-01-26 19:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('lecturers', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='lecturer',
            name='level_id',
        ),
        migrations.AddField(
            model_name='lecturer',
            name='level',
            field=models.CharField(choices=[('100', '100'), ('200', '200'), ('300', '300'), ('400', '400')], default='100', max_length=5),
        ),
    ]
