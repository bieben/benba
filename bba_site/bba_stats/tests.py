from django.test import TestCase
import pandas as pd
from nba_api.stats.static import teams
from nba_api.stats.endpoints import leaguegamefinder

nba_teams = teams.get_teams()
clippers = [team for team in nba_teams if team['abbreviation'] == 'LAC'][0]
clippers_id = clippers['id']

gamefinder = leaguegamefinder.LeagueGameFinder(team_id_nullable=clippers_id)
games = gamefinder.get_data_frames()[0]
games_2425 = games[games.SEASON_ID.str[-4:] == '2024']
print(games_2425.columns.tolist())
print(games_2425.head())
