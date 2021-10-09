class WMZedBuff_Gorefast_Damage extends WMZedBuff;

var float Damage;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != None)
		PerZedDamageMod += default.Damage;
}

defaultproperties
{
	Damage=0.35f

	BuffDescription="GOREFASTS DEAL MORE DAMAGE"
	BuffIcon=Texture2D'ZED_Gorefast_UI.ZED-VS_Icons_Gorefast-HeavyMelee'

	Name="Default__WMZedBuff_Gorefast_Damage"
}
