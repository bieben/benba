-- BBA Basketball Database 初始化脚本
-- 创建日期: 2025-02-01
-- 数据库类型: MySQL

-- 创建数据库
DROP DATABASE IF EXISTS bba_db;
CREATE DATABASE bba_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bba_db;

-- 创建 Django 认证和会话相关表
CREATE TABLE auth_group (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE auth_group_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES auth_group(id)
);

CREATE TABLE auth_permission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_type_id INT NOT NULL,
    codename VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE auth_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login DATETIME(6),
    is_superuser TINYINT(1) NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL,
    is_staff TINYINT(1) NOT NULL,
    is_active TINYINT(1) NOT NULL,
    date_joined DATETIME(6) NOT NULL
);

CREATE TABLE auth_user_groups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user(id),
    FOREIGN KEY (group_id) REFERENCES auth_group(id)
);

CREATE TABLE auth_user_user_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES auth_user(id),
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id)
);

CREATE TABLE django_content_type (
    id INT AUTO_INCREMENT PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL
);

CREATE TABLE django_migrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    app VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied DATETIME(6) NOT NULL
);

CREATE TABLE django_session (
    session_key VARCHAR(40) PRIMARY KEY,
    session_data LONGTEXT NOT NULL,
    expire_date DATETIME(6) NOT NULL
);

-- 创建 Django Admin 日志表
CREATE TABLE django_admin_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_time DATETIME(6) NOT NULL,
    object_id LONGTEXT,
    object_repr VARCHAR(200) NOT NULL,
    change_message LONGTEXT NOT NULL,
    content_type_id INT,
    user_id INT NOT NULL,
    action_flag SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id),
    FOREIGN KEY (user_id) REFERENCES auth_user(id)
);

-- 创建主要业务表
-- 球员表
CREATE TABLE stats_player (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    avatar_path VARCHAR(255) NULL,
    height VARCHAR(5) NOT NULL,
    weight INT NOT NULL,
    hometown VARCHAR(100) NOT NULL,
    university VARCHAR(100) NULL,
    contract VARCHAR(255) NULL,
    salary INT NULL,
    position VARCHAR(5) NOT NULL,
    number INT NOT NULL,
    dob DATE NOT NULL
);

-- 比赛统计表
CREATE TABLE stats_gamestats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player_id BIGINT NOT NULL,
    ppg DECIMAL(4,1) NOT NULL,
    rpg DECIMAL(4,1) NOT NULL,
    apg DECIMAL(4,1) NOT NULL,
    spg DECIMAL(4,1) NOT NULL,
    bpg DECIMAL(4,1) NOT NULL,
    mpg DECIMAL(4,1) NOT NULL,
    fg_pct DECIMAL(4,1) NOT NULL,
    three_pct DECIMAL(4,1) NOT NULL,
    ft_pct DECIMAL(4,1) NOT NULL,
    ts_pct DECIMAL(4,1) NOT NULL,
    FOREIGN KEY (player_id) REFERENCES stats_player(id) ON DELETE CASCADE
);

-- 赛程表
CREATE TABLE stats_schedule (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(50) NOT NULL UNIQUE,
    date DATE NOT NULL,
    home_team VARCHAR(100) NOT NULL,
    away_team VARCHAR(100) NOT NULL,
    home_score INT NULL,
    away_score INT NULL,
    status VARCHAR(50) NOT NULL
);

-- 排名表
CREATE TABLE stats_standings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    team VARCHAR(100) NOT NULL UNIQUE,
    conference VARCHAR(10) NOT NULL,
    wins INT NOT NULL,
    losses INT NOT NULL,
    win_percentage DECIMAL(4,3) NOT NULL,
    CHECK (conference IN ('East', 'West'))
);

-- 创建索引
CREATE INDEX idx_stats_player_player_id ON stats_player(player_id);
CREATE INDEX idx_stats_player_position ON stats_player(position);
CREATE INDEX idx_stats_gamestats_player ON stats_gamestats(player_id);
CREATE INDEX idx_stats_schedule_date ON stats_schedule(date);
CREATE INDEX idx_stats_schedule_game_id ON stats_schedule(game_id);
CREATE INDEX idx_stats_standings_conference ON stats_standings(conference);
CREATE INDEX idx_stats_standings_win_pct ON stats_standings(win_percentage);

-- 插入示例数据
-- 插入快船队球员数据
INSERT INTO stats_player (player_id, name, avatar_path, height, weight, hometown, university, contract, salary, position, number, dob) VALUES
(1, 'Kawhi Leonard', 'kawhi_leonard.jpg', '6-7', 225, 'Los Angeles, CA', 'San Diego State', '4 years/$176.3M', 48787676, 'SF', 2, '1991-06-29'),
(2, 'James Harden', 'james_harden.jpg', '6-5', 220, 'Los Angeles, CA', 'Arizona State', '2 years/$70M', 35640000, 'PG', 1, '1989-08-26'),
(3, 'Ivica Zubac', 'ivica_zubac.jpg', '7-0', 240, 'Mostar, Bosnia', NULL, '3 years/$33M', 11700000, 'C', 40, '1997-03-18'),
(4, 'Norman Powell', 'norman_powell.jpg', '6-3', 215, 'San Diego, CA', 'UCLA', '4 years/$64M', 16000000, 'SG', 24, '1993-05-25'),
(5, 'Derrick Jones Jr.', 'derrick_jones_jr.jpg', '6-6', 210, 'Chester, PA', 'UNLV', '3 years/$30M', 10000000, 'SF', 55, '1997-02-15'),
(6, 'Kris Dunn', 'kris_dunn.jpg', '6-3', 205, 'New London, CT', 'Providence', '3 years/$17M', 5666667, 'PG', 16, '1994-03-18'),
(7, 'Kevin Porter Jr.', 'kevin_porter_jr.jpg', '6-4', 203, 'Seattle, WA', 'USC', '2 years/$8.2M', 4100000, 'SG', 3, '2000-05-04'),
(8, 'Nicolas Batum', 'nicolas_batum.jpg', '6-8', 200, 'Lisieux, France', NULL, '2 years/$9.6M', 4800000, 'PF', 33, '1988-12-14');

-- 插入球员统计数据
INSERT INTO stats_gamestats (player_id, ppg, rpg, apg, spg, bpg, mpg, fg_pct, three_pct, ft_pct, ts_pct) VALUES
(1, 23.4, 6.2, 3.7, 1.8, 0.9, 34.6, 52.5, 44.3, 88.5, 64.7),
(2, 21.2, 8.1, 8.5, 1.1, 0.8, 35.9, 42.8, 38.1, 87.0, 60.8),
(3, 15.7, 12.2, 1.8, 0.4, 1.2, 28.4, 65.9, 0.0, 73.1, 67.8),
(4, 23.3, 3.1, 2.4, 1.0, 0.4, 32.8, 49.0, 44.1, 82.7, 62.4),
(5, 10.9, 3.2, 1.7, 0.7, 0.6, 24.7, 49.2, 35.1, 76.9, 56.8),
(6, 9.6, 4.8, 6.2, 1.3, 0.3, 23.6, 44.9, 35.8, 76.2, 52.7),
(7, 8.8, 2.7, 3.1, 0.8, 0.2, 18.4, 41.2, 31.4, 75.8, 50.3),
(8, 5.2, 4.1, 2.0, 0.6, 0.3, 20.8, 48.6, 39.7, 81.3, 58.9);

-- 插入赛程数据
INSERT INTO stats_schedule (game_id, date, home_team, away_team, home_score, away_score, status) VALUES
('0022500001', '2025-02-15', 'LA Clippers', 'Boston Celtics', 115, 108, 'Final'),
('0022500002', '2025-02-17', 'LA Clippers', 'Miami Heat', 122, 110, 'Final'),
('0022500003', '2025-02-20', 'Denver Nuggets', 'LA Clippers', 105, 118, 'Final'),
('0022500004', '2025-02-22', 'LA Clippers', 'Phoenix Suns', NULL, NULL, 'Scheduled'),
('0022500005', '2025-02-25', 'Golden State Warriors', 'LA Clippers', NULL, NULL, 'Scheduled'),
('0022500006', '2025-02-27', 'LA Clippers', 'Sacramento Kings', NULL, NULL, 'Scheduled');

-- 插入排名数据
INSERT INTO stats_standings (team, conference, wins, losses, win_percentage) VALUES
('Boston Celtics', 'East', 35, 15, 0.700),
('Milwaukee Bucks', 'East', 32, 18, 0.640),
('Philadelphia 76ers', 'East', 30, 20, 0.600),
('Miami Heat', 'East', 28, 22, 0.560),
('New York Knicks', 'East', 27, 23, 0.540),
('Brooklyn Nets', 'East', 25, 25, 0.500),
('Atlanta Hawks', 'East', 23, 27, 0.460),
('Chicago Bulls', 'East', 22, 28, 0.440),
('Toronto Raptors', 'East', 20, 30, 0.400),
('Orlando Magic', 'East', 18, 32, 0.360),
('Washington Wizards', 'East', 15, 35, 0.300),
('Charlotte Hornets', 'East', 12, 38, 0.240),
('Indiana Pacers', 'East', 10, 40, 0.200),
('Detroit Pistons', 'East', 8, 42, 0.160),
('Cleveland Cavaliers', 'East', 6, 44, 0.120),
('Denver Nuggets', 'West', 38, 12, 0.760),
('Phoenix Suns', 'West', 35, 15, 0.700),
('Memphis Grizzlies', 'West', 33, 17, 0.660),
('Sacramento Kings', 'West', 31, 19, 0.620),
('Golden State Warriors', 'West', 30, 20, 0.600),
('LA Clippers', 'West', 29, 21, 0.580),
('Minnesota Timberwolves', 'West', 27, 23, 0.540),
('New Orleans Pelicans', 'West', 25, 25, 0.500),
('Dallas Mavericks', 'West', 24, 26, 0.480),
('Utah Jazz', 'West', 22, 28, 0.440),
('Los Angeles Lakers', 'West', 21, 29, 0.420),
('Portland Trail Blazers', 'West', 19, 31, 0.380),
('Oklahoma City Thunder', 'West', 17, 33, 0.340),
('San Antonio Spurs', 'West', 15, 35, 0.300),
('Houston Rockets', 'West', 12, 38, 0.240);

-- 插入 Django 迁移记录
INSERT INTO django_migrations (app, name, applied) VALUES
('contenttypes', '0001_initial', NOW()),
('auth', '0001_initial', NOW()),
('admin', '0001_initial', NOW()),
('admin', '0002_logentry_remove_auto_add', NOW()),
('admin', '0003_logentry_add_action_flag_choices', NOW()),
('contenttypes', '0002_remove_content_type_name', NOW()),
('auth', '0002_alter_permission_name_max_length', NOW()),
('auth', '0003_alter_user_email_max_length', NOW()),
('auth', '0004_alter_user_username_opts', NOW()),
('auth', '0005_alter_user_last_login_null', NOW()),
('auth', '0006_require_contenttypes_0002', NOW()),
('auth', '0007_alter_validators_add_error_messages', NOW()),
('auth', '0008_alter_user_username_max_length', NOW()),
('auth', '0009_alter_user_last_name_max_length', NOW()),
('auth', '0010_alter_group_name_max_length', NOW()),
('auth', '0011_update_proxy_permissions', NOW()),
('auth', '0012_alter_user_first_name_max_length', NOW()),
('sessions', '0001_initial', NOW()),
('stats', '0001_initial', NOW()),
('stats', '0002_alter_player_height', NOW()),
('stats', '0003_schedule_standings_alter_player_options', NOW()),
('stats', '0004_alter_player_height_alter_player_salary', NOW()),
('stats', '0005_alter_standings_options', NOW()),
('stats', '0006_alter_schedule_options_alter_player_salary', NOW());

-- 插入内容类型
INSERT INTO django_content_type (app_label, model) VALUES
('admin', 'logentry'),
('auth', 'permission'),
('auth', 'group'),
('auth', 'user'),
('contenttypes', 'contenttype'),
('sessions', 'session'),
('stats', 'player'),
('stats', 'gamestats'),
('stats', 'schedule'),
('stats', 'standings');

-- 插入基本权限
INSERT INTO auth_permission (content_type_id, codename, name) VALUES
(1, 'add_logentry', 'Can add log entry'),
(1, 'change_logentry', 'Can change log entry'),
(1, 'delete_logentry', 'Can delete log entry'),
(1, 'view_logentry', 'Can view log entry'),
(2, 'add_permission', 'Can add permission'),
(2, 'change_permission', 'Can change permission'),
(2, 'delete_permission', 'Can delete permission'),
(2, 'view_permission', 'Can view permission'),
(3, 'add_group', 'Can add group'),
(3, 'change_group', 'Can change group'),
(3, 'delete_group', 'Can delete group'),
(3, 'view_group', 'Can view group'),
(4, 'add_user', 'Can add user'),
(4, 'change_user', 'Can change user'),
(4, 'delete_user', 'Can delete user'),
(4, 'view_user', 'Can view user'),
(7, 'add_player', 'Can add player'),
(7, 'change_player', 'Can change player'),
(7, 'delete_player', 'Can delete player'),
(7, 'view_player', 'Can view player'),
(8, 'add_gamestats', 'Can add game stats'),
(8, 'change_gamestats', 'Can change game stats'),
(8, 'delete_gamestats', 'Can delete game stats'),
(8, 'view_gamestats', 'Can view game stats'),
(9, 'add_schedule', 'Can add schedule'),
(9, 'change_schedule', 'Can change schedule'),
(9, 'delete_schedule', 'Can delete schedule'),
(9, 'view_schedule', 'Can view schedule'),
(10, 'add_standings', 'Can add standings'),
(10, 'change_standings', 'Can change standings'),
(10, 'delete_standings', 'Can delete standings'),
(10, 'view_standings', 'Can view standings');

-- 创建超级管理员用户 (用户名: admin, 密码: admin123)
-- 注意：这里使用的是简单的密码哈希，生产环境中应该使用更安全的密码
INSERT INTO auth_user (password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) VALUES
('pbkdf2_sha256$600000$YourSaltHere$YourHashedPasswordHere', NULL, 1, 'admin', 'Admin', 'User', 'admin@example.com', 1, 1, NOW());

COMMIT;

-- 显示创建结果
SELECT 'Database bba_db initialized successfully!' as Status;
SELECT COUNT(*) as PlayerCount FROM stats_player;
SELECT COUNT(*) as GameStatsCount FROM stats_gamestats;
SELECT COUNT(*) as ScheduleCount FROM stats_schedule;
SELECT COUNT(*) as StandingsCount FROM stats_standings;
