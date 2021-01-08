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

	upgradeName="Steady"
	upgradeDescription(0)="Reduce recoil by 30% and drastically reduce weapon bob with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Reduce recoil by <font color=\"#b346ea\">75%</font> and drastically reduce weapon bob with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Steady_Deluxe'

	Name="Default__WMUpgrade_Skill_Steady"
}
