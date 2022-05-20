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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_ShockTrooper"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShockTrooper'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ShockTrooper_Deluxe'

	Name="Default__WMUpgrade_Skill_ShockTrooper"
}
