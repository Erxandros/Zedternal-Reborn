class WMUpgrade_Skill_BringTheHeat_Flame_Low extends WMUpgrade_Skill_BringTheHeat_Flame_Base
	hidedropdown;

defaultproperties
{
	NumResidualFlames=2
	Begin Object Name=ExploTemplate0
		Damage=10.0f
		DamageRadius=125.0f
		MyDamageType=Class'ZedternalReborn.WMDT_BringTheHeat'

		ExplosionEffects=KFImpactEffectInfo'WEP_Flamethrower_ARCH.GroundFire_Impacts'
		ExplosionSound=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Explode'

		CamShakeInnerRadius=5.0f
		CamShakeOuterRadius=8.0f
	End Object

	Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Low"
}
