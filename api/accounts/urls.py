from django.contrib import admin
from django.urls import path, include

from dj_rest_auth import urls

from . import views

urlpatterns = [
    path('', include('dj_rest_auth.urls')),
    path('users-list/', views.UserList.as_view(), name='user_list'),

]