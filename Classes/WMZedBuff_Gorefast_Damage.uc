Class WMZedBuff_Gorefast_Damage extends WMZedBuff;

var float Damage;

static function ModifyZedDamageMod( out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != none)
		PerZedDamageMod += default.Damage;
}


defaultproperties
{
	buffDescription="GOREFASTS DEAL MORE DAMAGE"
	buffIcon=Texture2D'ZED_Gorefast_UI.ZED-VS_Icons_Gorefast-HeavyMelee'
	Damage = 0.350000;
}