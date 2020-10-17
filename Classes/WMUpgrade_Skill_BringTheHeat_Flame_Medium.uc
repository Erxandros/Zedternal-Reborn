class WMUpgrade_Skill_BringTheHeat_Flame_Medium extends WMUpgrade_Skill_BringTheHeat_Flame_Low
	hidedropdown;

defaultproperties
{
	NumResidualFlames=4
	Begin Object Name=ExploTemplate0
		Damage=40.0f
		DamageRadius=260.0f

		ExplosionSound=AkEvent'WW_WEP_SA_DragonsBreath.Play_Bullet_DragonsBreath_Impact_Snow'

		CamShakeInnerRadius=10.0f
		CamShakeOuterRadius=16.0f
	End Object

	Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Medium"
}
