# Generated by Django 3.1.4 on 2021-03-02 15:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('incomeexpense', '0015_income_total_income'),
    ]

    operations = [
        migrations.AlterField(
            model_name='income',
            name='total_income',
            field=models.FloatField(),
        ),
    ]
