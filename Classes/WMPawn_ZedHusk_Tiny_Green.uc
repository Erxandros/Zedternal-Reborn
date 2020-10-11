class WMPawn_ZedHusk_Tiny_Green extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return "Green Tiny Husk";
}

defaultproperties
{
	glowColor=(R=0.6f, G=5.0f, B=0.6f)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightGreen
		LightColor=(R=31, G=255, B=31, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Green'
		ExploLight=ExplosionPointLightGreen
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Green"
}
