class WMUI_UPGMenu_Localization extends Object;

const MenuClassPath = "ZedternalReborn.WMUI_UPGMenu";

static function string GetMenuLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(MenuClassPath, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

static function string GetTitle()
{
	return GetMenuLocalization("Title");
}

static function string GetMenuHeader()
{
	return GetMenuLocalization("MenuHeader");
}

static function string GetMenuTab1()
{
	return GetMenuLocalization("MenuTab1");
}

static function string GetMenuTab2()
{
	return GetMenuLocalization("MenuTab2");
}

static function string GetMenuTab3()
{
	return GetMenuLocalization("MenuTab3");
}

static function string GetMenuTab4()
{
	return GetMenuLocalization("MenuTab4");
}

static function string GetMenuTab5()
{
	return GetMenuLocalization("MenuTab5");
}

static function string GetMenuTab6()
{
	return GetMenuLocalization("MenuTab6");
}

static function string GetMenuTab7()
{
	return GetMenuLocalization("MenuTab7");
}

static function string GetRerollButton()
{
	return GetMenuLocalization("RerollButton");
}

static function string GetEquipButton()
{
	return GetMenuLocalization("EquipButton");
}

static function string GetSkipButton()
{
	return GetMenuLocalization("SkipButton");
}

static function string GetCloseButton()
{
	return GetMenuLocalization("CloseButton");
}

static function string GetFilterName1()
{
	return GetMenuLocalization("FilterName1");
}

static function string GetFilterName2()
{
	return GetMenuLocalization("FilterName2");
}

static function string GetFilterName3()
{
	return GetMenuLocalization("FilterName3");
}

static function string GetFilter1Option1()
{
	return GetMenuLocalization("Filter1Option1");
}

static function string GetFilter1Option2()
{
	return GetMenuLocalization("Filter1Option2");
}

static function string GetFilter1Option3()
{
	return GetMenuLocalization("Filter1Option3");
}

static function string GetPerkSkillListHeader()
{
	return GetMenuLocalization("PerkSkillListHeader");
}

static function string GetSkillDeluxe()
{
	return GetMenuLocalization("SkillDeluxe");
}

static function string GetRerollSuccessTitle()
{
	return GetMenuLocalization("RerollSuccessTitle");
}

static function string GetRerollFeeDescription()
{
	return GetMenuLocalization("RerollFeeDescription");
}

static function string GetRerollSellDescription()
{
	return GetMenuLocalization("RerollSellDescription");
}

static function string GetRerollRequiredDosh()
{
	return GetMenuLocalization("RerollRequiredDosh");
}

static function string GetRerollDoshRefunded()
{
	return GetMenuLocalization("RerollDoshRefunded");
}

static function string GetRerollFailTitle()
{
	return GetMenuLocalization("RerollFailTitle");
}

static function string GetRerollFailDescription()
{
	return GetMenuLocalization("RerollFailDescription");
}
