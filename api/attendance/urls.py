from django.urls import path

from . import views

urlpatterns = [
    path('', views.AttendanceList.as_view(), name='attendance_list'),
    path('<int:slot_id>/', views.Attendance.as_view(), name='attendance'),
    path('attendance-slot/create/', views.AttendanceSlotCreate.as_view(), name='attendance_slot'), 
    path('attendance-slots/', views.AttendanceSlotsView.as_view(), name='attendance_slots'), 
    path('attendance-slot/<int:pk>/', views.GetAttendanceSlot.as_view(), name='get_attendance_slot'),    

]