Class WMUpgrade_Skill_Speedloader extends WMUpgrade_Skill;
	
var array<float> minReloadSpeed, maxReloadSpeed;
	
static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local float load;
	
	if (KFW != none)
	{
		load = fmax(float(KFW.AmmoCount[0]) / float(KFW.MagazineCapacity[0]), 0.f);
		InReloadRateScale = 1 / (1/InReloadRateScale + load * default.maxReloadSpeed[upgLevel-1] + default.minReloadSpeed[upgLevel-1]);
	}
}

defaultproperties
{
	upgradeName="Speedloader"
	upgradeDescription(0)="Increase reload speed 10% to 50% with <font color=\"#eaeff7\">all weapons</font>. You reload faster when your clip is almost full"
	upgradeDescription(1)="Increase reload speed <font color=\"#b346ea\">25%</font> to <font color=\"#b346ea\">100%</font> with <font color=\"#eaeff7\">any weapon</font>. You reload faster when your clip is almost full"
	minReloadSpeed(0)=0.100000;
	minReloadSpeed(1)=0.250000;
	maxReloadSpeed(0)=0.400000;
	maxReloadSpeed(1)=0.750000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Speedloader'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Speedloader_Deluxe'
}