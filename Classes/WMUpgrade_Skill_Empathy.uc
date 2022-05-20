class WMUpgrade_Skill_Empathy extends WMUpgrade_Skill;

var array<float> Healing, SelfHealing;

static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Healing[upgLevel - 1];
}

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.SelfHealing[upgLevel - 1];
}

defaultproperties
{
	Healing(0)=0.25f
	Healing(1)=0.5f
	SelfHealing(0)=0.1f
	SelfHealing(1)=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Empathy"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy_Deluxe'

	Name="Default__WMUpgrade_Skill_Empathy"
}
