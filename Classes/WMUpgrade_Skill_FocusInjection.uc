class WMUpgrade_Skill_FocusInjection extends WMUpgrade_Skill;

var array<byte> Bonus, MaxBonus;

static simulated function GetHealingDamageBoost(out byte InHealingDamageBoost, int upgLevel)
{
	InHealingDamageBoost = default.Bonus[upgLevel - 1];
}

static simulated function GetMaxHealingDamageBoost(out byte InMaxHealingDamageBoost, int upgLevel)
{
	InMaxHealingDamageBoost = default.MaxBonus[upgLevel - 1];
}

static simulated function GetHealingShield(out byte InHealingShield, int upgLevel)
{
	InHealingShield = default.Bonus[upgLevel - 1];
}

static simulated function GetMaxHealingShield(out byte InMaxHealingShield, int upgLevel)
{
	InMaxHealingShield = default.MaxBonus[upgLevel - 1];
}

defaultproperties
{
	Bonus(0)=5
	Bonus(1)=10
	MaxBonus(0)=20
	MaxBonus(1)=50

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_FocusInjection"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FocusInjection'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FocusInjection_Deluxe'

	Name="Default__WMUpgrade_Skill_FocusInjection"
}
