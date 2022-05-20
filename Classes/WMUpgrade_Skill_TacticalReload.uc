class WMUpgrade_Skill_TacticalReload extends WMUpgrade_Skill;

var float ReloadRateDeluxe;

static simulated function GetReloadRateScalePassive(out float reloadRateFactor, int upgLevel)
{
	if (upgLevel > 1)
		reloadRateFactor = 1.0f / (1.0f / reloadRateFactor + default.ReloadRateDeluxe);
}

static simulated function bool GetUsingTactialReload(int upgLevel, KFWeapon KFW)
{
	return (static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_Commando') || static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_Demolitionist')
		|| static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_Gunslinger') || static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_Sharpshooter')
		|| static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_Support') || static.IsWeaponOnSpecificPerk(KFW, class'KFGame.KFPerk_SWAT'));
}

defaultproperties
{
	ReloadRateDeluxe=0.3f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_TacticalReload"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalReload'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalReload_Deluxe'

	Name="Default__WMUpgrade_Skill_TacticalReload"
}
