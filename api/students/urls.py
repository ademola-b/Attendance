from django.urls import path

from . import views

urlpatterns = [
    path('', views.StudentsList.as_view(), name='students_list'),
    path('<str:user_id__username>/', views.GetStudent.as_view(), name='get_student'),
    path('courses/<str:user_id__username>/', views.GetStudentCourse.as_view(), name='get_student_course'),
    path('face/student-face/', views.StudentFaceView.as_view(), name='student_face'),
    path('departments/all/', views.DeptsView.as_view(), name='department_list'),

]
