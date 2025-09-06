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

COMMIT;

-- 显示创建结果
SELECT 'Database bba_db initialized successfully (tables only)!' as Status;
