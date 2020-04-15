Class WMUpgrade_Skill_Steady extends WMUpgrade_Skill;

var array<float> Recoil;
var float Bob;

static simulated function ModifyRecoil( out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != none)
	{
		InRecoilModifier -= DefaultRecoilModifier * default.Recoil[upgLevel-1];
	}
}

static simulated function ModifyWeaponBopDampingPassive(out float bobDampFactor, int upgLevel)
{
	bobDampFactor += default.Bob;
}

defaultproperties
{
	upgradeName="Steady"
	upgradeDescription(0)="Reduce recoil 30% and drastically reduce weapon bob with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Reduce recoil <font color=\"#b346ea\">75%</font> and drastically reduce weapon bob with <font color=\"#eaeff7\">any weapon</font>"
	Recoil(0)=0.300000
	Recoil(1)=0.750000
	Bob=0.110000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Steady'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Steady_Deluxe'
}