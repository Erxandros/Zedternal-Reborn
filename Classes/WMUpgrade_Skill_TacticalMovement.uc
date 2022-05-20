class WMUpgrade_Skill_TacticalMovement extends WMUpgrade_Skill;

var array<float> Speed;
var float MoveSpeed;

static simulated function GetIronSightSpeedModifier(out float InSpeed, float DefaultSpeed, int upgLevel)
{
	InSpeed += DefaultSpeed * default.Speed[upgLevel - 1];
}

static simulated function ModifySpeedPassive(out float speedFactor, int upgLevel)
{
	if (upgLevel > 1)
		speedFactor += default.MoveSpeed;
}

defaultproperties
{
	Speed(0)=1.0f
	Speed(1)=1.15f
	MoveSpeed=0.05f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_TacticalMovement"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalMovement'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalMovement_Deluxe'

	Name="Default__WMUpgrade_Skill_TacticalMovement"
}
