class WMZedBuff_Siren_Heal extends WMZedBuff;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	local WMZedBuff_Siren_Heal_Helper Helper;
	local bool bFound;

	if (KFPawn_ZedSiren(P) != None)
	{
		bFound = False;
		foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'WMZedBuff_Siren_Heal_Helper', Helper)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			class'WorldInfo'.static.GetWorldInfo().Spawn(class'WMZedBuff_Siren_Heal_Helper');
	}
}

defaultproperties
{
	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Siren_Heal"
	BuffIcon=Texture2D'ZED_Siren_UI.ZED-VS_Icons_Siren-Scream'

	Name="Default__WMZedBuff_Siren_Heal"
}
