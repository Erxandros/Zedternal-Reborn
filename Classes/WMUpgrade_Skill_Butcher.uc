Class WMUpgrade_Skill_Butcher extends WMUpgrade_Skill;
	
var array<float> meleeSpeed, rateOfFire;

static simulated function ModifyMeleeAttackSpeedPassive( out float durationFactor, int upgLevel)
{
	durationFactor = 1.f / (1.f/durationFactor + default.meleeSpeed[upgLevel-1]);
}

static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.rateOfFire[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Butcher"
	upgradeDescription(0)="Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	meleeSpeed(0)=0.150000;
	meleeSpeed(1)=0.400000;
	rateOfFire(0)=0.150000;
	rateOfFire(1)=0.400000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Butcher'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Butcher_Deluxe'
}