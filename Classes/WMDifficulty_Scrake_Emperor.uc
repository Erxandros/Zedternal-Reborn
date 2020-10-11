class WMDifficulty_Scrake_Emperor extends KFDifficulty_Scrake
	abstract;

defaultproperties
{
	Normal=(BlockSettings=(Duration=3.0f))
	Hard=(BlockSettings=(Duration=3.0f))
	Suicidal=(BlockSettings=(Duration=3.0f))
	HellOnEarth=(BlockSettings=(Duration=3.0f))

	NumPlayersScale_BodyHealth=0.195f
	NumPlayersScale_HeadHealth=0.14f

	NumPlayersScale_BodyHealth_Versus=0.195f
	NumPlayersScale_HeadHealth_Versus=0.14f

	Name="Default__WMDifficulty_Scrake_Emperor"
}
