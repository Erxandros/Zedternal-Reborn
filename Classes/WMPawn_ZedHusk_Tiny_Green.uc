class WMPawn_ZedHusk_Tiny_Green extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return class'ZedternalReborn.WMPawn_ZedConstants'.default.GreenString @ super.GetLocalizedName();
}

defaultproperties
{
	glowColor=(R=0.12f, G=1.0f, B=0.12f)

	Begin Object Name=ChestLightComponent0
		LightColor=(R=30, G=255, B=30, A=255)
	End Object

	Begin Object Class=PointLightComponent Name=ExplosionPointLightGreen
		LightColor=(R=30, G=255, B=30, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Green'
		ExploLight=ExplosionPointLightGreen
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Green"
}
