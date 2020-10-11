class WMPawn_ZedHusk_Tiny_Blue extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return "Blue Tiny Husk";
}

defaultproperties
{
	glowColor=(R=0.6f, G=2.5f, B=5.0f)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightBlue
		LightColor=(R=31, G=128, B=255, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Blue'
		ExploLight=ExplosionPointLightBlue
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Blue"
}
