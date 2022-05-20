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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Supplier"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier_Deluxe'

	Name="Default__WMUpgrade_Skill_Supplier"
}
