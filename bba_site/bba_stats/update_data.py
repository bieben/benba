import mysql.connector
from nba_api.stats.static import players, teams
from nba_api.stats.endpoints import playercareerstats, leaguegamefinder, leaguestandings
from datetime import datetime

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="zyt123456",
    database="bba_db"
)
cursor = conn.cursor()

def update_player_stats(player_name):
    nba_players = players.get_players()
    player = next((p for p in nba_players if p["full_name"] == player_name), None)

    if not player:
        print(f"Cannot find: {player_name}")
        return

    player_id = player["id"]
    career = playercareerstats.PlayerCareerStats(player_id=player_id)
    stats = career.get_data_frames()[0].iloc[-1]

    sql = """
    INSERT INTO nba_stats_player (player_id, name, team, position)
    VALUES (%s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE team=%s, position=%s;
    """
    values = (player_id, player_name, "Lakers", "SG", "Lakers", "SG")

    cursor.execute(sql, values)
    conn.commit()
    print(f"{player_name} Update Successfully!")

# update_player_stats("James Harden")

def update_schedule():
    nba_teams = teams.get_teams()
    clippers = [team for team in nba_teams if team['abbreviation'] == 'LAC'][0]
    clippers_id = clippers['id']

    gamefinder = leaguegamefinder.LeagueGameFinder(team_id_nullable=clippers_id)
    games = gamefinder.get_data_frames()[0]
    games_2425 = games[games.SEASON_ID.str[-4:] == '2024']

    for index, game in games_2425.iterrows():
        game_id = game['GAME_ID']
        date = datetime.strptime(game['GAME_DATE'], '%Y-%m-%d').date()
        matchup = game['MATCHUP']
        home = False
        if '@' in matchup:
            home_team = matchup.split(' @ ')[-1]
            away_team = 'LAC'
        else:
            home = True
            home_team = 'LAC'
            away_team = matchup.split(' vs. ')[-1]

        if home:
            home_score = game['PTS']
            away_score = game['PTS'] + int(game['PLUS_MINUS'])
        else:
            home_score = game['PTS'] + int(game['PLUS_MINUS'])
            away_score = game['PTS']
            
        status = "Completed" if home_score else "Upcoming"

        sql = """
        INSERT INTO bba_stats_schedule (game_id, date, home_team, away_team, home_score, away_score, status)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE home_score=%s, away_score=%s, status=%s;
        """
        values = (game_id, date, home_team, away_team, home_score, away_score, status, home_score, away_score, status)

        cursor.execute(sql, values)
        conn.commit()
    print("Update Schedules Successfully!")

def update_standings():
    standings = leaguestandings.LeagueStandings().get_data_frames()[0]

    for index, team in standings.iterrows():
        team_name = team['TeamName']
        conference = team['Conference']
        wins = team['WINS']
        losses = team['LOSSES']
        win_pct = team['WinPCT']

        sql = """
        INSERT INTO bba_stats_standings (team, conference, wins, losses, win_percentage)
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE wins=%s, losses=%s, win_percentage=%s;
        """
        values = (team_name, conference, wins, losses, win_pct, wins, losses, win_pct)

        cursor.execute(sql, values)
        conn.commit()
    print("Update Standings Successfully!")

update_schedule()
update_standings()

cursor.close()
conn.close()
