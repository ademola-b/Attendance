from django.apps import AppConfig


class AttendanceConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'attendance'

    # when the application is ready
    def ready(self):
        print("Ready to run")
        from status_scheduler import status_updater 
        status_updater.start()

