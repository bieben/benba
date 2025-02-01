# Generated by Django 5.1.5 on 2025-02-01 03:13

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Player",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("player_id", models.IntegerField(unique=True)),
                ("name", models.CharField(max_length=100)),
                (
                    "avatar_path",
                    models.CharField(blank=True, max_length=255, null=True),
                ),
                ("height", models.IntegerField()),
                ("weight", models.IntegerField()),
                ("hometown", models.CharField(max_length=100)),
                ("university", models.CharField(blank=True, max_length=100, null=True)),
                ("contract", models.CharField(blank=True, max_length=255, null=True)),
                ("salary", models.IntegerField()),
                ("position", models.CharField(max_length=5)),
                ("number", models.IntegerField()),
                ("dob", models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name="GameStats",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("ppg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("rpg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("apg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("spg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("bpg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("mpg", models.DecimalField(decimal_places=1, max_digits=4)),
                ("fg_pct", models.DecimalField(decimal_places=1, max_digits=4)),
                ("three_pct", models.DecimalField(decimal_places=1, max_digits=4)),
                ("ft_pct", models.DecimalField(decimal_places=1, max_digits=4)),
                ("ts_pct", models.DecimalField(decimal_places=1, max_digits=4)),
                (
                    "player",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="bba_stats.player",
                    ),
                ),
            ],
        ),
    ]
