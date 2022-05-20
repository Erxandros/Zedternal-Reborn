class WMUpgrade_Skill_Overload extends WMUpgrade_Skill;

var array<float> MagCapacity, MaxAmmo;

static simulated function ModifyMagSizeAndNumberPassive(out float magazineCapacityFactor, int upgLevel)
{
	magazineCapacityFactor += default.MagCapacity[upgLevel - 1];
}

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.MaxAmmo[upgLevel - 1];
}

defaultproperties
{
	MagCapacity(0)=0.2f
	MagCapacity(1)=0.5f
	MaxAmmo(0)=0.2f
	MaxAmmo(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Overload"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Overload'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Overload_Deluxe'

	Name="Default__WMUpgrade_Skill_Overload"
}
