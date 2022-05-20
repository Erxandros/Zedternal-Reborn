class WMZedBuff_SpawnRate extends WMZedBuff;

var float SpawnRate;

static function ModifySpawnRateMod(out float SpawnRateMod)
{
	SpawnRateMod += default.SpawnRate;
}

defaultproperties
{
	SpawnRate=0.1f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_SpawnRate"
	BuffIcon=Texture2D'ZED_Patriarch_UI.ZED-VS_Icons_Generic-Cloak'

	Name="Default__WMZedBuff_SpawnRate"
}
