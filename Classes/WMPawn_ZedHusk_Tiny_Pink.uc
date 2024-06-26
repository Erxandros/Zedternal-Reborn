class WMPawn_ZedHusk_Tiny_Pink extends WMPawn_ZedHusk_Tiny;

static function string GetLocalizedName()
{
	return class'ZedternalReborn.WMPawn_ZedConstants'.default.PinkString @ super.GetLocalizedName();
}

defaultproperties
{
	glowColor=(R=1.0f, G=0.12f, B=0.36f)

	Begin Object Name=ChestLightComponent0
		LightColor=(R=255, G=30, B=91, A=255)
	End Object

	Begin Object Class=PointLightComponent Name=ExplosionPointLightPink
		LightColor=(R=255, G=30, B=91, A=255)
		bCastPerObjectShadows=False
	End Object

	Begin Object Name=TinyExploTemplate0
		ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Zeds.Husk.FX_Husk_Tiny_Explosion_Pink'
		ExploLight=ExplosionPointLightPink
	End Object

	Name="Default__WMPawn_ZedHusk_Tiny_Pink"
}
