class WMUpgrade_Skill_Pressure extends WMUpgrade_Skill;

var int minHealth;
var array<float> maxReloadSpeed;

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (OwnerPawn.Health < default.minHealth)
		InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.maxReloadSpeed[upgLevel - 1] * (1.0f - OwnerPawn.Health / default.minHealth));
}

defaultproperties
{
	minHealth=60
	maxReloadSpeed(0)=0.6f
	maxReloadSpeed(1)=1.5f

	UpgradeName="Pressure"
	UpgradeDescription(0)="Increase reload speed with <font color=\"#eaeff7\">all weapons</font> by up to 60% when your health is low with lower health equaling faster reloading"
	UpgradeDescription(1)="Increase reload speed with <font color=\"#eaeff7\">all weapons</font> by up to <font color=\"#b346ea\">150%</font> when your health is low with lower health equalling faster reloading"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pressure'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pressure_Deluxe'

	Name="Default__WMUpgrade_Skill_Pressure"
}
