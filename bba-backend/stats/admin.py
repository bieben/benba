from django.contrib import admin
from .models import Player, GameStats, Schedule, Standings

class PlayerAdmin(admin.ModelAdmin):
    list_display = ('name', 'number', 'position')


admin.site.register(Player, PlayerAdmin)
admin.site.register(GameStats)
admin.site.register(Schedule)
admin.site.register(Standings)