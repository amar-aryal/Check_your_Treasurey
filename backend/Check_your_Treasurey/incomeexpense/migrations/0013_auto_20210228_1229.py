# Generated by Django 3.1.4 on 2021-02-28 06:44

from django.db import migrations, models
import incomeexpense.models


class Migration(migrations.Migration):

    dependencies = [
        ('incomeexpense', '0012_totalvalue'),
    ]

    operations = [
        migrations.AddField(
            model_name='income',
            name='total_income',
            field=models.FloatField(default=0),
        ),
        migrations.DeleteModel(
            name='TotalValue',
        ),
    ]