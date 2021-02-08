Class WMZedBuff_Siren_Heal extends WMZedBuff;

var float Damage;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	local WMZedBuff_Siren_Heal_Helper Helper;
	local bool bFound;

	if (KFPawn_ZedSiren(P) != none)
	{
		bFound = false;
		foreach Class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'WMZedBuff_Siren_Heal_Helper', Helper)
		{
			bFound = true;
		}

		if (!bFound)
			Class'WorldInfo'.static.GetWorldInfo().Spawn(class'WMZedBuff_Siren_Heal_Helper');
	}
}

defaultproperties
{
	buffDescription="SIRENS SCREAMS CAN HEAL OTHER ZEDS"
	buffIcon=Texture2D'ZED_Siren_UI.ZED-VS_Icons_Siren-Scream'
}
