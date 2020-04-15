Class WMUpgrade_Skill_Stability extends WMUpgrade_Skill;
	
var array<float> aimRecoil, hipRecoil;
	
static simulated function ModifyRecoil( out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != none)
	{
		if (KFW.bUsingSights)
			InRecoilModifier -= DefaultRecoilModifier * default.aimRecoil[upgLevel-1];
		else
			InRecoilModifier -= DefaultRecoilModifier * default.hipRecoil[upgLevel-1];
		
	}
}

defaultproperties
{
	upgradeName="Stability"
	upgradeDescription(0)="Reduce aim recoil 25% and hip recoil 50% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Reduce aim recoil <font color=\"#b346ea\">50%</font> and hip recoil <font color=\"#b346ea\">75%</font> with <font color=\"#eaeff7\">all weapons</font>"
	aimRecoil(0)=0.250000;
	aimRecoil(1)=0.500000;
	hipRecoil(0)=0.500000;
	hipRecoil(1)=0.750000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Stability'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Stability_Deluxe'
}