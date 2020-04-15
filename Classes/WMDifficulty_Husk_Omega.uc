//=============================================================================
// KFDifficulty_Husk
//=============================================================================
// Per Zed, per difficulty balance settings
//=============================================================================
// Killing Floor 2
// Copyright (C) 2016 Tripwire Interactive LLC
//=============================================================================
class WMDifficulty_Husk_Omega extends KFDifficulty_Husk
	dependsOn(KFPawn_ZedHusk)
	abstract;


defaultproperties
{
   FireballSettings(0)=(bSpawnGroundFire=True,ExplosionMomentum=50000.000000)
   FireballSettings(1)=(bSpawnGroundFire=True,ExplosionMomentum=55000.000000)
   FireballSettings(2)=(bSpawnGroundFire=True,ExplosionMomentum=60000.000000)
   FireballSettings(3)=(bSpawnGroundFire=True,ExplosionMomentum=65000.000000)
   FireballSettings_Versus=(ExplosionMomentum=50000.000000)
   Normal=(HealthMod=0.850000,HeadHealthMod=0.850000,RallySettings=(bCanRally=False))
   Hard=(DamagedSprintChance=0.350000)
   Suicidal=(DamagedSprintChance=0.500000,RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(HealthMod=1.100000,HeadHealthMod=1.100000,SprintChance=0.650000,DamagedSprintChance=1.000000,DamageMod=1.500000,RallySettings=(bCauseSprint=True,TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   RallySettings_Versus=(bCauseSprint=True)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
   Name="Default__WMDifficulty_Husk_Omega"
}
