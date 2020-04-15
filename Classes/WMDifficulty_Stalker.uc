class WMDifficulty_Stalker extends KFMonsterDifficultyInfo
	abstract;

defaultproperties
{
   Normal=(DamagedSprintChance=0.100000,HealthMod=0.750000,HeadHealthMod=0.750000,SoloDamageMod=0.500000,EvadeOnDamageSettings=(Chance=0.500000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCanRally=False))
   Hard=(DamagedSprintChance=1.000000,DamageMod=0.750000,EvadeOnDamageSettings=(Chance=0.500000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCanRally=False))
   Suicidal=(SprintChance=0.600000,DamagedSprintChance=1.000000,MovementSpeedMod=1.300000,EvadeOnDamageSettings=(Chance=0.500000,DamagedHealthPctToTrigger=0.010000),RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(SprintChance=0.750000,DamagedSprintChance=1.000000,MovementSpeedMod=1.400000,EvadeOnDamageSettings=(Chance=0.500000,DamagedHealthPctToTrigger=0.010000),RallySettings=(bCauseSprint=True,TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   RallySettings_Versus=(bCauseSprint=True)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
   Name="Default__WMDifficulty_Stalker"
}
