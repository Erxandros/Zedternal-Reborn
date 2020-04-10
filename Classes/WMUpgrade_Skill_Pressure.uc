Class WMUpgrade_Skill_Pressure extends WMUpgrade_Skill;
	
var int minHealth;
var array<float> maxReloadSpeed;
	
static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (OwnerPawn.Health < default.minHealth)
		InReloadRateScale = 1 / (1/InReloadRateScale + default.maxReloadSpeed[upgLevel-1] * (1 - OwnerPawn.Health / default.minHealth));
}

defaultproperties
{
	upgradeName="Pressure"
	upgradeDescription(0)="Increase reload speed with <font color=\"#eaeff7\">all weapons</font> up to 60% when your health is low"
	upgradeDescription(1)="Increase reload speed with <font color=\"#eaeff7\">all weapons</font> up to <font color=\"#b346ea\">150%</font> when your health is low"
	minHealth=60
	maxReloadSpeed(0)=0.600000;
	maxReloadSpeed(1)=1.500000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pressure'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Pressure_Deluxe'
}