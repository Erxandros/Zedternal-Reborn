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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Stability"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability_Deluxe'

	Name="Default__WMUpgrade_Skill_Stability"
}
