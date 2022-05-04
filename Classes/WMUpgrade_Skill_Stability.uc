class WMUpgrade_Skill_Stability extends WMUpgrade_Skill;

var array<float> AimRecoil, HipRecoil;

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != None)
	{
		if (KFW.bUsingSights)
			InRecoilModifier -= DefaultRecoilModifier * default.AimRecoil[upgLevel - 1];
		else
			InRecoilModifier -= DefaultRecoilModifier * default.HipRecoil[upgLevel - 1];
	}
}

defaultproperties
{
	AimRecoil(0)=0.25f
	AimRecoil(1)=0.5f
	HipRecoil(0)=0.5f
	HipRecoil(1)=0.75f

	UpgradeName="Stability"
	UpgradeDescription(0)="Decrease recoil by 25% when using iron sights and by 50% when hip firing with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeDescription(1)="Decrease recoil by <font color=\"#b346ea\">50%</font> when using iron sights and by <font color=\"#b346ea\">75%</font> when hip firing with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability_Deluxe'

	Name="Default__WMUpgrade_Skill_Stability"
}
