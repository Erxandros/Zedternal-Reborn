class WMUpgrade_Skill_Dreadnaught extends WMUpgrade_Skill;

var array<float> Health;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.Health[upgLevel - 1]);
}

defaultproperties
{
	Health(0)=0.25f
	Health(1)=0.6f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Dreadnaught"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Dreadnaught'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Dreadnaught_Deluxe'

	Name="Default__WMUpgrade_Skill_Dreadnaught"
}
