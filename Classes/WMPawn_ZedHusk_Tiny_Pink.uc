class WMPawn_ZedHusk_Tiny_Pink extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return "Pink Tiny Husk";
}

defaultproperties
{
	glowColor=(R=5.000000, G=0.600000, B=1.800000)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightPink
		LightColor=(R=255, G=31, B=92, A=255)
		bCastPerObjectShadows=false
	End Object

	Begin Object Class=WMExplosion_TinyHusk Name=TinyExploTemplatePink0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Resource.FX_Husk_Tiny_Explosion_Pink'
		ExploLight=ExplosionPointLightPink
	End Object
	ExplosionTemplate=TinyExploTemplatePink0

	Name="Default__WMPawn_ZedHusk_Tiny_Pink"
}
