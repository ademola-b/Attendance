from django.urls import path

from . import views

urlpatterns = [
    path('', views.AttendanceList.as_view(), name='attendance_list'),
    path('<int:slot_id>/', views.Attendance.as_view(), name='attendance'),
    path('att/<int:slot_id>/', views.Attendance.as_view(), name='attendance'),
    path('slot/create/', views.AttendanceSlotCreate.as_view(), name='attendance_slot'), 
    path('slots/', views.AttendanceSlotsView.as_view(), name='attendance_slots'), 
    path('slot/<int:pk>/', views.GetAttendanceSlot.as_view(), name='get_attendance_slot'),    
    path('slot/<int:pk>/update/', views.UpdateAttendanceSlot.as_view(), name='update_attendance_slot'),    

]