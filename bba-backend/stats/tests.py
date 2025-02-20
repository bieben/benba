from django.test import TestCase
import pandas as pd
from nba_api.stats.static import players, teams
from nba_api.stats.endpoints import playercareerstats, leaguegamefinder, leaguestandings
from nba_api.live.nba.endpoints import scoreboard as nba_scoreboard
from datetime import datetime

nba_teams = teams.get_teams()
clippers = [team for team in nba_teams if team['abbreviation'] == 'LAC'][0]
clippers_id = clippers['id']

def update_player_stats(player_name):
    nba_players = players.get_players()
    player = next((p for p in nba_players if p["full_name"] == player_name), None)

    if not player:
        print(f"Cannot find: {player_name}")
        return

    player_id = player["id"]
    career = playercareerstats.PlayerCareerStats(player_id=player_id)
    stats = career.get_data_frames()[0].iloc[-1]

update_player_stats("James Harden")
nba_players = players.get_players('James Harden')
# nba_players_dict = {p["full_name"]: p["id"] for p in nba_players}  
print(nba_players)

# gamefinder = leaguegamefinder.LeagueGameFinder(team_id_nullable=clippers_id)
# games = gamefinder.get_data_frames()[0]
# games_2425 = games[games.SEASON_ID.str[-4:] == '2024']
# print(games_2425.columns.tolist())
# print(games_2425.head())

# scoreboard = nba_scoreboard.ScoreBoard()
# games = scoreboard.games.get_dict()
# for game in games:
#     if game['homeTeam']['teamTricode'] == 'LAC':
#         print(game)