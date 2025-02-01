from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PlayerViewSet, GameStatsViewSet, ScheduleViewSet, StandingsViewSet

router = DefaultRouter()
router.register(r'players', PlayerViewSet)
router.register(r'game-stats', GameStatsViewSet)
router.register(r'schedule', ScheduleViewSet)
router.register(r'standings', StandingsViewSet)


urlpatterns = [
    path('api/', include(router.urls)),
]
