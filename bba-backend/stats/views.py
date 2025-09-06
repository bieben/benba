from rest_framework import viewsets
from .models import Player, GameStats, Schedule, Standings
from .serializers import PlayerSerializer, GameStatsSerializer, ScheduleSerializer, StandingsSerializer
from nba_api.live.nba.endpoints import scoreboard as nba_scoreboard
from django.http import JsonResponse
import datetime

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

def get_scoreboard(request):
    scoreboard = nba_scoreboard.ScoreBoard()
    games = scoreboard.games.get_dict()

    scoreboard_data = {
        "date": '',
        "home_team": '',
        "away_team": '',
        "home_score": 0,
        "away_score": 0,
    }
    for game in games:
        if game['homeTeam']['teamTricode'] == 'LAC':
            scoreboard_data["home_team"] = 'LAC'
            scoreboard_data["away_team"] = game['awayTeam']['teamTricode']
        elif game['awayTeam']['teamTricode'] == 'LAC':
            scoreboard_data["home_team"] = game['homeTeam']['teamTricode']
            scoreboard_data["away_team"] = 'LAC'
        else:
            continue
        
        scoreboard_data["home_score"] = game['homeTeam']['score']
        scoreboard_data["away_score"] = game['awayTeam']['score']
        scoreboard_data["date"] = datetime.datetime.strptime(game['gameEt'][:10], "%Y-%m-%d").date()
        return JsonResponse(scoreboard_data)
    
    return JsonResponse({"message": "No LAC game today"}, status=200)
    
    