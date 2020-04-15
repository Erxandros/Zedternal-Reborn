//=============================================================================
// KFDifficulty_Bloat
//=============================================================================
// Per Zed, per difficulty balance settings
//=============================================================================
// Killing Floor 2
// Copyright (C) 2016 Tripwire Interactive LLC
//=============================================================================
class WMDifficulty_Gorefast_Omega extends KFMonsterDifficultyInfo
	abstract;

defaultproperties
{
   Normal=(HealthMod=0.850000,HeadHealthMod=0.850000,SprintChance=1.000000,DamagedSprintChance=1.000000,SoloDamageMod=0.650000,BlockSettings=(Chance=0.750000,Duration=1.000000,MaxBlocks=4.000000,Cooldown=1.000000,DamagedHealthPctToTrigger=0.010000,MeleeDamageModifier=0.800000,DamageModifier=0.800000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.200000),RallySettings=(bCanRally=False))
   Hard=(SprintChance=1.000000,DamagedSprintChance=1.000000,DamageMod=0.750000,SoloDamageMod=0.800000,BlockSettings=(Chance=0.900000,Duration=1.000000,MaxBlocks=4.000000,Cooldown=1.000000,DamagedHealthPctToTrigger=0.010000,MeleeDamageModifier=0.800000,DamageModifier=0.800000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.300000),RallySettings=(bCanRally=True))
   Suicidal=(SprintChance=1.000000,DamagedSprintChance=1.000000,SoloDamageMod=0.650000,BlockSettings=(Chance=0.900000,Duration=1.000000,MaxBlocks=4.000000,Cooldown=1.000000,DamagedHealthPctToTrigger=0.010000,MeleeDamageModifier=0.800000,DamageModifier=0.800000,AfflictionModifier=0.200000,SoloChanceMultiplier=1.000000),RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(SprintChance=1.000000,DamagedSprintChance=1.000000,SoloDamageMod=0.650000,BlockSettings=(Chance=0.900000,Duration=1.000000,MaxBlocks=5.000000,Cooldown=1.000000,DamagedHealthPctToTrigger=0.010000,MeleeDamageModifier=0.800000,DamageModifier=0.800000,AfflictionModifier=0.200000,SoloChanceMultiplier=1.000000),RallySettings=(bCauseSprint=True,TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   BlockSettings_Player_Versus=(MeleeDamageModifier=0.250000,DamageModifier=0.010000)
   RallySettings_Versus=(bCauseSprint=True)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
   Name="Default__WMDifficulty_Gorefast_Omega"
}
