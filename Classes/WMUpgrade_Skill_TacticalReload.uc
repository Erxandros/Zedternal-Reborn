Class WMUpgrade_Skill_TacticalReload extends WMUpgrade_Skill;

var float reloadRateDeluxe;

static simulated function GetReloadRateScalePassive( out float reloadRateFactor, int upgLevel)
{
	if (upgLevel > 1)
		reloadRateFactor = 1.f / (1.f/reloadRateFactor + default.reloadRateDeluxe);
}

static simulated function bool GetUsingTactialReload(int upgLevel, KFWeapon KFW)
{
	return (static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_Commando') || static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_Demolitionist')
			|| static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_Gunslinger') || static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_Sharpshooter')
			|| static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_Support') || static.IsWeaponOnSpecificPerk( KFW, class'KFGame.KFPerk_SWAT'));
}

defaultproperties
{
	upgradeName="Tactical Reload"
	upgradeDescription(0)="Increase reload speed with <font color=\"#caab05\">Commando, Demolitionist, Gunslinger, Sharpshooter, Support and SWAT weapons</font>"
	upgradeDescription(1)="<font color=\"#b346ea\">Grealty</font> increase reload speed with <font color=\"#eaeff7\">any weapon</font>"
	reloadRateDeluxe=0.300000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalReload'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalReload_Deluxe'
}