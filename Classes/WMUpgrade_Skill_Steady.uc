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

	UpgradeName="Steady"
	UpgradeDescription(0)="Decrease recoil by 30% and drastically reduce weapon bob with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeDescription(1)="Decrease recoil by <font color=\"#b346ea\">75%</font> and drastically reduce weapon bob with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady_Deluxe'

	Name="Default__WMUpgrade_Skill_Steady"
}
