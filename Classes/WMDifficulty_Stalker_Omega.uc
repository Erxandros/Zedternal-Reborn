class WMDifficulty_Stalker_Omega extends KFDifficulty_Stalker
	abstract;

defaultproperties
{
	Normal=(DamagedSprintChance=0.2f, EvadeOnDamageSettings=(Chance=0.5f))
	Hard=(DamagedSprintChance=0.4f, EvadeOnDamageSettings=(Chance=0.6f))
	Suicidal=(EvadeOnDamageSettings=(Chance=0.7f))
	HellOnEarth=(EvadeOnDamageSettings=(Chance=0.8f))

	Name="Default__WMDifficulty_Stalker_Omega"
}
