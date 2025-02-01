from rest_framework import serializers
from .models import Player, GameStats, Schedule, Standings

class PlayerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Player
        fields = '__all__'

class GameStatsSerializer(serializers.ModelSerializer):
    class Meta:
        model = GameStats
        fields = '__all__'

class ScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Schedule
        fields = '__all__'

class StandingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Standings
        fields = '__all__'