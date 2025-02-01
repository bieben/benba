from django.db import models

class Player(models.Model):
    player_id = models.IntegerField(unique=True)
    name = models.CharField(max_length=100)
    avatar_path = models.CharField(max_length=255, null=True, blank=True)
    height = models.CharField(max_length=5)
    weight = models.IntegerField()
    hometown = models.CharField(max_length=100)
    university = models.CharField(max_length=100, null=True, blank=True)
    contract = models.CharField(max_length=255, null=True, blank=True)
    salary = models.IntegerField(blank=True)
    position = models.CharField(max_length=5)
    number = models.IntegerField()
    dob = models.DateField()

    class Meta:
        ordering = ['id']

class GameStats(models.Model):
    player = models.ForeignKey(Player, on_delete=models.CASCADE)
    ppg = models.DecimalField(max_digits=4, decimal_places=1)
    rpg = models.DecimalField(max_digits=4, decimal_places=1)
    apg = models.DecimalField(max_digits=4, decimal_places=1)
    spg = models.DecimalField(max_digits=4, decimal_places=1)
    bpg = models.DecimalField(max_digits=4, decimal_places=1)
    mpg = models.DecimalField(max_digits=4, decimal_places=1)
    fg_pct = models.DecimalField(max_digits=4, decimal_places=1)
    three_pct = models.DecimalField(max_digits=4, decimal_places=1)
    ft_pct = models.DecimalField(max_digits=4, decimal_places=1)
    ts_pct = models.DecimalField(max_digits=4, decimal_places=1)


class Schedule(models.Model):
    game_id = models.CharField(max_length=50, unique=True)
    date = models.DateField()
    home_team = models.CharField(max_length=100)
    away_team = models.CharField(max_length=100)
    home_score = models.IntegerField(null=True, blank=True)
    away_score = models.IntegerField(null=True, blank=True)
    status = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.date} - {self.home_team} vs {self.away_team}"

class Standings(models.Model):
    team = models.CharField(max_length=100, unique=True)
    conference = models.CharField(max_length=10, choices=[('East', 'East'), ('West', 'West')])
    wins = models.IntegerField()
    losses = models.IntegerField()
    win_percentage = models.DecimalField(max_digits=4, decimal_places=3)

    def __str__(self):
        return f"{self.team} - {self.conference}: {self.wins}-{self.losses}"
