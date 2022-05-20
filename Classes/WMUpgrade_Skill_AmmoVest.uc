class WMUpgrade_Skill_AmmoVest extends WMUpgrade_Skill;

var array<float> Ammo;
var array<int> Weight;

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.Ammo[upgLevel - 1];
}

static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit, int upgLevel)
{
	InWeightLimit += default.Weight[upgLevel - 1];
}

defaultproperties
{
	Ammo(0)=0.3f
	Ammo(1)=0.75f
	Weight(0)=2
	Weight(1)=5

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_AmmoVest"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoVest'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoVest_Deluxe'

	Name="Default__WMUpgrade_Skill_AmmoVest"
}
