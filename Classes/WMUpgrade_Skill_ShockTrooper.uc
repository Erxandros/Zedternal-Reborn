class WMUpgrade_Skill_ShockTrooper extends WMUpgrade_Skill;

var array<float> ReloadSpeed;

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (KFW != None && KFW.AmmoCount[0] == 0)
		InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.ReloadSpeed[upgLevel - 1]);
}

defaultproperties
{
	ReloadSpeed(0)=0.4f
	ReloadSpeed(1)=1.0f

	upgradeName="Shock Trooper"
	upgradeDescription(0)="Increase reload speed of empty magazines by 40% for <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase reload speed of empty magazines by <font color=\"#b346ea\">100%</font> for <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShockTrooper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShockTrooper_Deluxe'

	Name="Default__WMUpgrade_Skill_ShockTrooper"
}
