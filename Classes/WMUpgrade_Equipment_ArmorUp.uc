class WMUpgrade_Equipment_ArmorUp extends WMUpgrade_Equipment;

var int Armor;

static function ModifyArmor(out int MaxArmor, int DefaultArmor, int upgLevel)
{
	MaxArmor += default.Armor * upgLevel;
}

defaultproperties
{
	Armor=10

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_ArmorUp"
	LocalizeDescriptionLineCount=1
	EquipmentBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_ArmorUp'

	Name="Default__WMUpgrade_Equipment_ArmorUp"
}
