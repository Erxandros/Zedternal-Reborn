Class WMZedBuff_SpawnRate extends WMZedBuff;

var float SpawnRate;

static function ModifySpawnRateMod( out float SpawnRateMod)
{
	SpawnRateMod += default.SpawnRate;
}


defaultproperties
{
	buffDescription="ZEDS SPAWN FASTER"
	buffIcon=Texture2D'ZED_Patriarch_UI.ZED-VS_Icons_Generic-Cloak'
	SpawnRate = 0.100000;
}