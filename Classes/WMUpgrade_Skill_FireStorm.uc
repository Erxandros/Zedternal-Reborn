Class WMUpgrade_Skill_FireStorm extends WMUpgrade_Skill;

var array<float> FireRate, MeleeSpeed;

static simulated function bool IsRangeActive(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.FireRate[upgLevel - 1]);
}

static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel)
{
	durationFactor = 1.0f / (1.0f / durationFactor + default.MeleeSpeed[upgLevel - 1]);
}

defaultproperties
{
	FireRate(0)=0.15f
	FireRate(1)=0.4f
	MeleeSpeed(0)=0.15f
	MeleeSpeed(1)=0.4f

	upgradeName="Firestorm"
	upgradeDescription(0)="Increase range of <font color=\"#caab05\">Firebug's weapons</font>. Attack and shoot 15% faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase range of <font color=\"#caab05\">Firebug's weapons</font>. Attack and shoot <font color=\"#b346ea\">40%</font> faster with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FireStorm'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FireStorm_Deluxe'

	Name="Default__WMUpgrade_Skill_FireStorm"
}
