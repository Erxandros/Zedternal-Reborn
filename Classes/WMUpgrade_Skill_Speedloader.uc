class WMUpgrade_Skill_Speedloader extends WMUpgrade_Skill;

var array<float> MinReloadSpeed, MaxReloadSpeed;

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local float Load;

	if (KFW != None)
	{
		Load = FMax(float(KFW.AmmoCount[0]) / float(KFW.MagazineCapacity[0]), 0.0f);
		InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + Load * default.MaxReloadSpeed[upgLevel - 1] + default.MinReloadSpeed[upgLevel - 1]);
	}
}

defaultproperties
{
	MinReloadSpeed(0)=0.1f
	MinReloadSpeed(1)=0.25f
	MaxReloadSpeed(0)=0.4f
	MaxReloadSpeed(1)=0.75f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Speedloader"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Speedloader'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Speedloader_Deluxe'

	Name="Default__WMUpgrade_Skill_Speedloader"
}
