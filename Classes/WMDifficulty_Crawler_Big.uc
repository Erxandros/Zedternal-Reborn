class WMDifficulty_Crawler_Big extends KFDifficulty_Crawler
	abstract;

static function float GetSpecialCrawlerChance( KFGameReplicationInfo KFGRI )
{
	return 0.f;
}

defaultproperties
{
   Normal=(HealthMod=0.750000,HeadHealthMod=0.750000,EvadeOnDamageSettings=(Chance=0.000000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCanRally=False))
   Hard=(DamagedSprintChance=0.010000,DamageMod=0.750000,EvadeOnDamageSettings=(Chance=0.000000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCanRally=False))
   Suicidal=(SprintChance=0.850000,DamagedSprintChance=1.000000,MovementSpeedMod=1.100000,EvadeOnDamageSettings=(Chance=0.000000,DamagedHealthPctToTrigger=0.010000),RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(SprintChance=1.000000,DamagedSprintChance=1.000000,MovementSpeedMod=1.150000,EvadeOnDamageSettings=(Chance=0.000000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCauseSprint=True,TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   RallySettings_Versus=(bCauseSprint=True)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
   Name="Default__KFDifficulty_Crawler"
   ObjectArchetype=KFMonsterDifficultyInfo'KFGame.Default__KFMonsterDifficultyInfo'
}
