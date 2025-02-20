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
        plus_minus = int(game['PLUS_MINUS'])
        lac_score = game['PTS']  # LAC的得分

        # 确定 LAC 是主场还是客场
        if '@' in matchup:
            home_team = matchup.split(' @ ')[-1]
            away_team = 'LAC'
            home_score = lac_score - plus_minus  # LAC 是客队，对手的得分
            away_score = lac_score  # LAC 本身的得分
        else:
            home_team = 'LAC'
            away_team = matchup.split(' vs. ')[-1]
            home_score = lac_score  # LAC 是主队
            away_score = lac_score - plus_minus  # 客队得分

        # 确定比赛状态
        status = "Completed" if home_score is not None and away_score is not None else "Upcoming"

        sql = """
        INSERT INTO stats_schedule (game_id, date, home_team, away_team, home_score, away_score, status)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE 
            home_score = VALUES(home_score), 
            away_score = VALUES(away_score), 
            status = VALUES(status);
        """
        values = (game_id, date, home_team, away_team, home_score, away_score, status)

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
        INSERT INTO stats_standings (team, conference, wins, losses, win_percentage)
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE wins=%s, losses=%s, win_percentage=%s;
        """
        values = (team_name, conference, wins, losses, win_pct, wins, losses, win_pct)

        cursor.execute(sql, values)
        conn.commit()
    print("Update Standings Successfully!")

# 获取数据库中的球员数据
def get_players_from_db():
    cursor.execute("SELECT id, name FROM stats_player")  # 只获取本地 player_id
    return {name: id for id, name in cursor.fetchall()}  # 以 name 为 key，id 为 value 的字典

# 更新球员比赛数据
def update_gamestats():
    players_db = get_players_from_db()  # 获取数据库球员信息 {name: player_id}
    
    nba_players = players.get_players()  # 获取 NBA API 球员数据
    nba_players_dict = {p["full_name"]: p["id"] for p in nba_players}  # {full_name: nba_player_id}

    for player_name, db_player_id in players_db.items():
        if player_name not in nba_players_dict:
            print(f"Cannot find: {player_name}")
            continue

        nba_player_id = nba_players_dict[player_name]  # NBA API player_id

        try:
            career = playercareerstats.PlayerCareerStats(player_id=nba_player_id)
            stats = career.get_data_frames()[0].iloc[-1]  # 最新赛季数据

            games_played = stats["GP"]
            points = stats["PTS"] / games_played if games_played > 0 else 0
            assists = stats["AST"] / games_played if games_played > 0 else 0
            rebounds = stats["REB"] / games_played if games_played > 0 else 0
            steals = stats["STL"] / games_played if games_played > 0 else 0
            blocks = stats["BLK"] / games_played if games_played > 0 else 0
            fg_pct = stats["FG_PCT"] * 100 if stats["FG_PCT"] else 0
            three_pct = stats["FG3_PCT"] * 100 if stats["FG3_PCT"] else 0
            ft_pct = stats["FT_PCT"] * 100 if stats["FT_PCT"] else 0
            mpg = stats["MIN"] / games_played if games_played > 0 else 0
            ts_pct = (stats["PTS"] / (2 * (stats["FGA"] + 0.44 * stats["FTA"]))) * 100 if (stats["FGA"] + 0.44 * stats["FTA"]) > 0 else 0

            sql = """
            INSERT INTO stats_gamestats 
            (player_id, ppg, rpg, apg, spg, bpg, fg_pct, three_pct, ft_pct, ts_pct, mpg)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE 
                ppg = VALUES(ppg),
                rpg = VALUES(rpg),
                apg = VALUES(apg),
                spg = VALUES(spg),
                bpg = VALUES(bpg),
                fg_pct = VALUES(fg_pct),
                three_pct = VALUES(three_pct),
                ft_pct = VALUES(ft_pct),
                ts_pct = VALUES(ts_pct),
                mpg = VALUES(mpg);
            """
            
            values = (db_player_id, points, rebounds, assists, steals, blocks, fg_pct, three_pct, ft_pct, ts_pct, mpg)
            cursor.execute(sql, values)
            conn.commit()

            print(f"Updated season stats for {player_name} (player_id: {db_player_id})")

        except Exception as e:
            print(f"Error updating stats for {player_name}: {e}")
update_schedule()
update_standings()
update_gamestats()

cursor.close()
conn.close()
