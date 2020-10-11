class WMDifficulty_Crawler_Big extends KFDifficulty_Crawler
	abstract;

defaultproperties
{
	Normal=(EvadeOnDamageSettings=(Chance=0.0f))
	Hard=(EvadeOnDamageSettings=(Chance=0.0f))
	Suicidal=(MovementSpeedMod=1.1f, EvadeOnDamageSettings=(Chance=0.0f))
	HellOnEarth=(MovementSpeedMod=1.15f, EvadeOnDamageSettings=(Chance=0.0f))

	Name="Default__WMDifficulty_Crawler_Big"
}
