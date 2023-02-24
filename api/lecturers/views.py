from django.shortcuts import render
from rest_framework.generics import ListAPIView
from . models import Lecturer
from . serializers import LecturersDetail

# Create your views here.
class LecturersView(ListAPIView):
    queryset = Lecturer.objects.all()
    serializer_class = LecturersDetail

    def get_queryset(self):
        qs = super().get_queryset()
        request = self.request
        user = request.user
        if not user.is_authenticated:
            return Lecturer.objects.none()
        elif user.is_staff:
            return Lecturer.objects.all()

        return qs.filter(user_id = request.user) 
    

