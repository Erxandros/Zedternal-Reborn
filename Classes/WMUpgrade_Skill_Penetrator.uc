class WMUpgrade_Skill_Penetrator extends WMUpgrade_Skill;

var array<float> Penetration;

static simulated function ModifyPenetrationPassive(out float penetrationFactor, int upgLevel)
{
	penetrationFactor += default.Penetration[upgLevel - 1];
}

defaultproperties
{
	Penetration(0)=2.0f
	Penetration(1)=5.0f

	UpgradeName="Penetrator"
	UpgradeDescription(0)="Increase penetration power with <font color=\"#caab05\">shotguns, rifles, and revolvers</font> by 200%"
	UpgradeDescription(1)="Increase penetration power with <font color=\"#caab05\">shotguns, rifles, and revolvers</font> by <font color=\"#b346ea\">500%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator_Deluxe'

	Name="Default__WMUpgrade_Skill_Penetrator"
}
