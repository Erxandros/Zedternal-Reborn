class WMUpgrade_Equipment_HealthUp extends WMUpgrade_Equipment;

var int Health;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += default.Health * upgLevel;
}

defaultproperties
{
	Health=10

	upgradeName="Health Up"
	upgradeDescription(0)="Increase health by %x% points"
	EquipmentBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	//upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.'

	Name="Default__WMUpgrade_Equipment_HealthUp"
}
