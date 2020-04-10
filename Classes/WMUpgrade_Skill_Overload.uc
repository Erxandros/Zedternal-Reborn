Class WMUpgrade_Skill_Overload extends WMUpgrade_Skill;
	
var array<float> magCapacity, maxAmmo;
	
static simulated function ModifyMagSizeAndNumberPassive( out float magazineCapacityFactor, int upgLevel)
{
	magazineCapacityFactor += default.magCapacity[upgLevel-1];
}

static simulated function ModifySpareAmmoAmountPassive( out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.maxAmmo[upgLevel-1];
}

defaultproperties
{
	upgradeName="Overload"
	upgradeDescription(0)="Increase magazine capacity and max ammo of <font color=\"#eaeff7\">all weapons</font> 20%"
	upgradeDescription(1)="Increase magazine capacity and max ammo of <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">50%</font>"
	magCapacity(0)=0.200000;
	magCapacity(1)=0.500000;
	maxAmmo(0)=0.200000;
	maxAmmo(1)=0.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Overload'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Overload_Deluxe'
}