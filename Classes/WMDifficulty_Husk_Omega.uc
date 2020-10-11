class WMDifficulty_Husk_Omega extends KFDifficulty_Husk
	dependsOn(WMPawn_ZedHusk_Omega)
	abstract;

defaultproperties
{
	Normal=(HealthMod=0.85f,HeadHealthMod=0.85f)
	Hard=(DamagedSprintChance=0.35f)
	Suicidal=(DamagedSprintChance=0.5f)
	HellOnEarth=(HealthMod=1.1f,SprintChance=0.65f)

	FireballSettings(`DIFFICULTY_Normal)=(bSpawnGroundFire=True)
	FireballSettings(`DIFFICULTY_Hard)=(bSpawnGroundFire=True)
	FireballSettings_Versus=(bSpawnGroundFire=True)

	Name="Default__WMDifficulty_Husk_Omega"
}
