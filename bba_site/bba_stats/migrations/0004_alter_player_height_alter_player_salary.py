# Generated by Django 5.1.5 on 2025-02-01 04:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("bba_stats", "0003_schedule_standings_alter_player_options"),
    ]

    operations = [
        migrations.AlterField(
            model_name="player",
            name="height",
            field=models.CharField(max_length=5),
        ),
        migrations.AlterField(
            model_name="player",
            name="salary",
            field=models.IntegerField(blank=True),
        ),
    ]
