Class WMUpgrade_Skill_AmmoVest extends WMUpgrade_Skill;

var array<int> Weight;
var array<float> Ammo;

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
	Ammo(0) = 0.3f
	Ammo(1) = 0.75f
	Weight(0) = 2
	Weight(1) = 5

	upgradeName="Ammo Vest"
	upgradeDescription(0)="Increase weight capacity by 2. You can carry up to 30% more ammo for <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase weight capacity by <font color=\"#b346ea\">5</font>. You can carry up to <font color=\"#b346ea\">75%</font> more ammo for <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoVest'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoVest_Deluxe'

	Name="Default__WMUpgrade_Skill_AmmoVest"
}
