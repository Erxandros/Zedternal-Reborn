Class WMUpgrade_Skill_HighCapacityMags extends WMUpgrade_Skill;
	
var array<float> magCapacity;
	
static simulated function ModifyMagSizeAndNumber( out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname )
{
	InMagazineCapacity += Round(float(DefaultMagazineCapacity) * default.magCapacity[upgLevel-1]);
}

defaultproperties
{
	upgradeName="High Capacity Mags"
	upgradeDescription(0)="Increase magazine capacity of <font color=\"#eaeff7\">all weapons</font> 30%"
	upgradeDescription(1)="Increase magazine capacity of <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">75%</font>"
	magCapacity(0)=0.300000;
	magCapacity(1)=0.750000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighCapacityMags'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighCapacityMags_Deluxe'
}