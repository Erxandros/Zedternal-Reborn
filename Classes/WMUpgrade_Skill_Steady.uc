class WMUpgrade_Skill_Steady extends WMUpgrade_Skill;

var array<float> Recoil;
var float Bob;

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != None)
		InRecoilModifier -= DefaultRecoilModifier * default.Recoil[upgLevel - 1];
}

static simulated function ModifyWeaponBopDampingPassive(out float bobDampFactor, int upgLevel)
{
	bobDampFactor += default.Bob;
}

defaultproperties
{
	Recoil(0)=0.3f
	Recoil(1)=0.75f
	Bob=0.11f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Steady"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady_Deluxe'

	Name="Default__WMUpgrade_Skill_Steady"
}
