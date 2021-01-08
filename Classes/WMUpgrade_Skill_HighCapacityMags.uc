class WMUpgrade_Skill_HighCapacityMags extends WMUpgrade_Skill;

var array<float> MagCapacity;

static simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< class<KFPerk> > WeaponPerkClass, optional bool bSecondary=False, optional name WeaponClassname)
{
	InMagazineCapacity += Round(float(DefaultMagazineCapacity) * default.MagCapacity[upgLevel - 1]);
}

defaultproperties
{
	MagCapacity(0)=0.3f
	MagCapacity(1)=0.75f

	upgradeName="High Capacity Mags"
	upgradeDescription(0)="Increase magazine capacity of <font color=\"#eaeff7\">all weapons</font> by 30%"
	upgradeDescription(1)="Increase magazine capacity of <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">75%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighCapacityMags'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighCapacityMags_Deluxe'

	Name="Default__WMUpgrade_Skill_HighCapacityMags"
}
