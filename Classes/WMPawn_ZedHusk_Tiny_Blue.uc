class WMPawn_ZedHusk_Tiny_Blue extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return class'ZedternalReborn.WMPawn_ZedConstants'.default.BlueString @ super.GetLocalizedName();
}

defaultproperties
{
	glowColor=(R=0.12f, G=0.5f, B=1.0f)

	Begin Object Class=PointLightComponent Name=ExplosionPointLightBlue
		LightColor=(R=30, G=127, B=255, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Blue'
		ExploLight=ExplosionPointLightBlue
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Blue"
}
