Class WMUpgrade_Skill_ShockTropper extends WMUpgrade_Skill;
	
var array<float> reloadSpeed;
	
static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (KFW != none && KFW.AmmoCount[0]==0)
		InReloadRateScale = 1 / (1/InReloadRateScale + default.reloadSpeed[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Shock Trooper"
	upgradeDescription(0)="Increase reload speed of empty magazine 40% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase reload speed of empty magazine <font color=\"#b346ea\">100%</font> with <font color=\"#eaeff7\">all weapons</font>"
	reloadSpeed(0)=0.400000;
	reloadSpeed(1)=1.000000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ShockTropper'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ShockTropper_Deluxe'
}