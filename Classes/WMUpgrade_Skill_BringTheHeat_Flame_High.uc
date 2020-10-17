class WMUpgrade_Skill_BringTheHeat_Flame_High extends WMUpgrade_Skill_BringTheHeat_Flame_Medium
	hidedropdown;

defaultproperties
{
	NumResidualFlames=7
	Begin Object Name=ExploTemplate0
		Damage=115.0f
		DamageRadius=350.0f

		ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'

		CamShakeInnerRadius=15.0f
		CamShakeOuterRadius=24.0f
	End Object

	Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_High"
}
