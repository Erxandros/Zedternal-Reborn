class WMUpgrade_Equipment_HealthUp extends WMUpgrade_Equipment;

var int Health;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += default.Health * upgLevel;
}

defaultproperties
{
	Health=10

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_HealthUp"
	LocalizeDescriptionLineCount=1
	EquipmentBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_HealthUp'

	Name="Default__WMUpgrade_Equipment_HealthUp"
}
