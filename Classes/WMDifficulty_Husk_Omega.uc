class WMDifficulty_Husk_Omega extends KFDifficulty_Husk
	dependsOn(WMPawn_ZedHusk_Omega)
	abstract;

defaultproperties
{
	Normal=(HealthMod=0.85f,HeadHealthMod=0.85f)
	Hard=(DamagedSprintChance=0.35f)
	Suicidal=(DamagedSprintChance=0.5f,RallySettings=(DealtDamageModifier=1.2f, TakenDamageModifier=0.9f))
	HellOnEarth=(HealthMod=1.1f,HeadHealthMod=1.1f,SprintChance=0.65f,DamagedSprintChance=1.0f,DamageMod=1.5f,RallySettings=(bCauseSprint=True, DealtDamageModifier=1.2f, TakenDamageModifier=0.9f))

	FireballSettings(`DIFFICULTY_Normal)=(bSpawnGroundFire=True, ExplosionMomentum=50000.0f)
	FireballSettings(`DIFFICULTY_Hard)=(bSpawnGroundFire=True, ExplosionMomentum=55000.0f)
	FireballSettings(`DIFFICULTY_Suicidal)=(bSpawnGroundFire=True, ExplosionMomentum=60000.0f)
	FireballSettings(`DIFFICULTY_HellOnEarth)=(bSpawnGroundFire=True, ExplosionMomentum=65000.0f)
	FireballSettings_Versus=(bSpawnGroundFire=True, ExplosionMomentum=50000.0f)

	Name="Default__WMDifficulty_Husk_Omega"
}
