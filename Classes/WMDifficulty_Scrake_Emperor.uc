//=============================================================================
// KFDifficulty_Scrake
//=============================================================================
// Per Zed, per difficulty balance settings
//=============================================================================
// Killing Floor 2
// Copyright (C) 2016 Tripwire Interactive LLC
//=============================================================================
class WMDifficulty_Scrake_Emperor extends KFDifficulty_Scrake
	abstract;

defaultproperties
{
   Normal=(HealthMod=0.850000,HeadHealthMod=0.850000,SprintChance=1.000000,DamagedSprintChance=1.000000,DamageMod=0.425000,SoloDamageMod=0.500000,BlockSettings=(Chance=0.050000,Duration=3.000000,MaxBlocks=3.000000,Cooldown=5.000000,DamagedHealthPctToTrigger=0.050000,MeleeDamageModifier=0.900000,DamageModifier=0.900000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.100000),RallySettings=(bCanRally=False))
   Hard=(SprintChance=1.000000,DamagedSprintChance=1.000000,DamageMod=0.700000,SoloDamageMod=0.500000,BlockSettings=(Chance=0.100000,Duration=3.000000,MaxBlocks=4.000000,Cooldown=5.000000,DamagedHealthPctToTrigger=0.050000,MeleeDamageModifier=0.900000,DamageModifier=0.900000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.100000),RallySettings=(bCanRally=False))
   Suicidal=(HealthMod=1.100000,HeadHealthMod=1.050000,SprintChance=1.000000,DamagedSprintChance=1.000000,SoloDamageMod=0.500000,BlockSettings=(Chance=0.400000,Duration=3.000000,MaxBlocks=5.000000,Cooldown=5.000000,DamagedHealthPctToTrigger=0.050000,MeleeDamageModifier=0.900000,DamageModifier=0.900000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.200000),RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(HealthMod=1.100000,HeadHealthMod=1.100000,SprintChance=1.000000,DamagedSprintChance=1.000000,DamageMod=1.250000,SoloDamageMod=0.650000,BlockSettings=(Chance=0.500000,Duration=3.000000,MaxBlocks=6.000000,Cooldown=5.000000,DamagedHealthPctToTrigger=0.050000,MeleeDamageModifier=0.900000,DamageModifier=0.900000,AfflictionModifier=0.200000,SoloChanceMultiplier=0.300000),RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   NumPlayersScale_BodyHealth=0.140000
   NumPlayersScale_HeadHealth=0.110000
   BlockSettings_Player_Versus=(MeleeDamageModifier=0.250000,DamageModifier=0.250000)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
   Name="Default__KFDifficulty_Scrake"
}
