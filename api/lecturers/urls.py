from django.urls import path
from . views import LecturersView

urlpatterns = [
    path('', LecturersView.as_view(), name='lecturers'),
]
