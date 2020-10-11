class WMPawn_ZedHusk_Tiny_Pink extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return "Pink Tiny Husk";
}

defaultproperties
{
	glowColor=(R=5.0f, G=0.6f, B=1.8f)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightPink
		LightColor=(R=255, G=31, B=92, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Pink'
		ExploLight=ExplosionPointLightPink
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Pink"
}
