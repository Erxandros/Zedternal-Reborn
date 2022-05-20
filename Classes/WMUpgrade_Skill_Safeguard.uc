class WMUpgrade_Skill_Safeguard extends WMUpgrade_Skill;

var array<float> Bonus;

static function ModifyHealAmountPassive(out float healAmountFactor, int upgLevel)
{
	healAmountFactor += default.Bonus[upgLevel - 1];
}

static simulated function ModifyHealerRechargeTime(out float InRechargeTime, float DefaultRechargeTime, int upgLevel)
{
	InRechargeTime = DefaultRechargeTime / (DefaultRechargeTime / InRechargeTime + default.Bonus[upgLevel - 1]);
}

defaultproperties
{
	Bonus(0)=0.2f
	Bonus(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Safeguard"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Safeguard'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Safeguard_Deluxe'

	Name="Default__WMUpgrade_Skill_Safeguard"
}
