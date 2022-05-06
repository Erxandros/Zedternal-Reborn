class WMUpgrade_Perk extends WMUpgrade
	abstract;

//Set LocalizeDescriptionLines to the number of upgrade description lines that need to be localized if bShouldLocalize is set to True.
var byte LocalizeDescriptionLineCount;

struct SPerkBonus
{
	var int baseValue;
	var int incValue;
	var int maxValue;
};
var array<SPerkBonus> PerkBonus;

static function string GetBonusValue(int Index, int Level)
{
	if (default.PerkBonus.length <= Index)
		return "";
	else
	{
		if (default.PerkBonus[Index].maxValue == -1)
			return string(default.PerkBonus[Index].baseValue + default.PerkBonus[Index].incValue * Level);
		else
			return string(Min(default.PerkBonus[Index].baseValue + default.PerkBonus[Index].incValue * Level, default.PerkBonus[Index].maxValue));
	}
}

static function string GetUpgradeDescription(byte Line)
{
	return GetUpgradeLocalization("PerkUpgradeDescription" $ (Line + 1));
}

defaultproperties
{
	UpgradeName="Default Perk Upgrade Name"
	UpgradeDescription(0)="Default Perk Description"

	Name="Default__WMUpgrade_Perk"
}
