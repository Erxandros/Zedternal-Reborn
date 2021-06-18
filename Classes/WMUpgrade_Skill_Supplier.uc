class WMUpgrade_Skill_Supplier extends WMUpgrade_Skill;

var array<float> MaxAmmo;
var float SupplierAmmo;

static simulated function bool IsSupplierActive(int upgLevel)
{
	return True;
}

static simulated function SupplierModifiers(int upgLevel, out float PrimaryAmmoPercentage, out float SecondaryAmmoPercentage, out float ArmorPercentage, out int GrenadeAmount)
{
	PrimaryAmmoPercentage += default.SupplierAmmo;
	SecondaryAmmoPercentage += default.SupplierAmmo;
}

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.MaxAmmo[upgLevel - 1];
}

defaultproperties
{
	MaxAmmo(0)=0.3f
	MaxAmmo(1)=0.75f
	SupplierAmmo=0.3f;

	upgradeName="Supplier"
	upgradeDescription(0)="You can carry up to 30% more ammo for <font color=\"#eaeff7\">all weapons</font> and once per wave your teammates can restock 30% of their ammo by interacting with you"
	upgradeDescription(1)="You can carry up to <font color=\"#b346ea\">75%</font> more ammo for <font color=\"#eaeff7\">all weapons</font> and once per wave your teammates can restock 30% of their ammo by interacting with you"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier_Deluxe'

	Name="Default__WMUpgrade_Skill_Supplier"
}
