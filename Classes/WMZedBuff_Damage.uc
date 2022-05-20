class WMZedBuff_Damage extends WMZedBuff;

var float Damage;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	PerZedDamageMod += default.Damage;
}

defaultproperties
{
	Damage=0.15f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Damage"
	BuffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Melee'

	Name="Default__WMZedBuff_Damage"
}
