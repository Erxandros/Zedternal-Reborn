Class WMZedBuff_Damage_II extends WMZedBuff;

var float Damage;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	PerZedDamageMod += default.Damage;
}

defaultproperties
{
	buffDescription="ZEDS DEAL MORE DAMAGE"
	buffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Melee'
	Damage = 0.225000;
}
