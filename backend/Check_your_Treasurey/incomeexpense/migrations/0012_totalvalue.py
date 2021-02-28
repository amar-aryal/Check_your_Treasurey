# Generated by Django 3.1.4 on 2021-02-27 10:19

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('incomeexpense', '0011_delete_reminder'),
    ]

    operations = [
        migrations.CreateModel(
            name='TotalValue',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('total_income', models.FloatField()),
                ('total_expense', models.FloatField()),
                ('userID', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]