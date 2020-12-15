Class WMUpgrade_Skill_Stability extends WMUpgrade_Skill;

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

	upgradeName="Stability"
	upgradeDescription(0)="Reduce aim recoil by 25% and hip recoil by 50% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Reduce aim recoil by <font color=\"#b346ea\">50%</font> and hip recoil by <font color=\"#b346ea\">75%</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Stability_Deluxe'

	Name="Default__WMUpgrade_Skill_Stability"
}
