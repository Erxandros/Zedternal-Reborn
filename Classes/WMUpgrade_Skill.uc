class WMUpgrade_Skill extends WMUpgrade
	abstract;

// IMPORTANT : upgLevel for default skill is 1. upgLevel will be equal to 2 if skill is "Deluxe"

static function string GetUpgradeDescription(bool bDeluxe)
{
	if (bDeluxe)
		return GetUpgradeLocalization("DeluxeSkillUpgradeDescription");
	else
		return GetUpgradeLocalization("StandardSkillUpgradeDescription");
}

defaultproperties
{
	UpgradeName="Default Skill Upgrade Name"
	UpgradeDescription(0)="Default Skill Description"
	UpgradeDescription(1)="Default Deluxe Skill Description"

	Name="Default__WMUpgrade_Skill"
}
