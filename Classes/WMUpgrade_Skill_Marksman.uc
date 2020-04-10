Class WMUpgrade_Skill_Marksman extends WMUpgrade_Skill;
	
var array<float> rateOfFire, Speed;
	
static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.rateOfFire[upgLevel-1]);
}

static simulated function ModifyMeleeAttackSpeedPassive( out float durationFactor, int upgLevel)
{
	durationFactor = 1.f / (1.f/durationFactor + default.rateOfFire[upgLevel-1]);
}

static simulated function ModifySpeedPassive( out float speedFactor, int upgLevel)
{
	speedFactor += default.Speed[upgLevel-1];
}

defaultproperties
{
	upgradeName="Marksman"
	upgradeDescription(0)="Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font>. You also move 5% faster"
	upgradeDescription(1)="Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>. You also move <font color=\"#b346ea\">10%</font> faster"
	rateOfFire(0)=0.150000
	rateOfFire(1)=0.400000
	Speed(0)=0.050000
	Speed(1)=0.100000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Marksman'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Marksman_Deluxe'
}