Class WMUpgrade_Skill_FireStorm extends WMUpgrade_Skill;
	
var array<float> fireRate, meleeSpeed;

static simulated function bool IsRangeActive(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}

static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.fireRate[upgLevel-1]);
}

static simulated function ModifyMeleeAttackSpeedPassive( out float durationFactor, int upgLevel)
{
	durationFactor = 1.f / (1.f/durationFactor + default.meleeSpeed[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Firestorm"
	upgradeDescription(0)="Increase range of <font color=\"#caab05\">Firebug's weapons</font>. Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase range of <font color=\"#caab05\">Firebug's weapons</font>. Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	fireRate(0)=0.150000;
	fireRate(1)=0.400000;
	meleeSpeed(0)=0.150000;
	meleeSpeed(1)=0.400000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FireStorm'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FireStorm_Deluxe'
}