from rest_framework import viewsets
from .models import Player, GameStats, Schedule, Standings
from .serializers import PlayerSerializer, GameStatsSerializer, ScheduleSerializer, StandingsSerializer

class PlayerViewSet(viewsets.ModelViewSet):
    queryset = Player.objects.all()
    serializer_class = PlayerSerializer

class GameStatsViewSet(viewsets.ModelViewSet):
    queryset = GameStats.objects.all()
    serializer_class = GameStatsSerializer

class ScheduleViewSet(viewsets.ModelViewSet):
    queryset = Schedule.objects.all()
    serializer_class = ScheduleSerializer

class StandingsViewSet(viewsets.ModelViewSet):
    queryset = Standings.objects.all()
    serializer_class = StandingsSerializer