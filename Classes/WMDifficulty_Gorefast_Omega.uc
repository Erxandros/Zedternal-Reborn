class WMDifficulty_Gorefast_Omega extends KFDifficulty_Gorefast
	abstract;

defaultproperties
{
	Normal=(HealthMod=0.85f, HeadHealthMod=0.85f, BlockSettings=(Chance=0.75f))
	Hard=(BlockSettings=(Chance=0.80f), RallySettings=(bCanRally=True))
	Suicidal=(BlockSettings=(Chance=0.85f))
	HellOnEarth=(BlockSettings=(Chance=0.9f))

	Name="Default__WMDifficulty_Gorefast_Omega"
}
