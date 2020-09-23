class WMPawn_ZedHusk_Tiny_Blue extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return "Blue Tiny Husk";
}

defaultproperties
{
	glowColor=(R=0.600000, G=2.500000, B=5.000000)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightBlue
		LightColor=(R=31, G=128, B=255, A=255)
		bCastPerObjectShadows=false
	End Object

	Begin Object Class=WMExplosion_TinyHusk Name=TinyExploTemplateBlue0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Resource.FX_Husk_Tiny_Explosion_Blue'
		ExploLight=ExplosionPointLightBlue
	End Object
	ExplosionTemplate=TinyExploTemplateBlue0

	Name="Default__WMPawn_ZedHusk_Tiny_Blue"
}
