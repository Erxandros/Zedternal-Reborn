Class WMUpgrade_Skill_Supplier extends WMUpgrade_Skill;

var array<float> MaxAmmo;

static simulated function bool IsSupplierActive(int upgLevel)
{
	return True;
}

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.MaxAmmo[upgLevel - 1];
}

defaultproperties
{
	MaxAmmo(0)=0.3f
	MaxAmmo(1)=0.75f

	upgradeName="Supplier"
	upgradeDescription(0)="Your teammates can get 30% ammo by interacting with you once per wave. You can carry up to 30% more ammo for <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Your teammates can get 30% ammo by interacting with you once per wave. You can carry up to <font color=\"#b346ea\">75%</font> more ammo for <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Supplier_Deluxe'

	Name="Default__WMUpgrade_Skill_Supplier"
}
