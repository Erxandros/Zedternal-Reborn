Class WMUpgrade_Skill_DoorTraps extends WMUpgrade_Skill;
	
var array<float> bonus;
	
static simulated function bool DoorShouldNuke(int upgLevel, KFPawn OwnerPawn)
{
	if (upgLevel > 1)
		return true;
}	

static simulated function bool CanExplosiveWeld(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}

static simulated function ModifyWeldingRate( out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate, int upgLevel)
{
	InFastenRate += DefaultFastenRate * default.bonus[upgLevel-1];
	InUnfastenRate += DefaultUnfastenRate * default.bonus[upgLevel-1];
}

defaultproperties
{
	upgradeName="Door Traps"
	upgradeDescription(0)="Increase welding speed by 75% and allow you to setup explosive door traps"
	upgradeDescription(1)="Increase welding speed by <font color=\"#b346ea\">200%</font> and allow you to setup <font color=\"#b346ea\">nuclear</font> explosive door traps"
	bonus(0)=0.750000;
	bonus(1)=2.000000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_DoorTraps'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_DoorTraps_Deluxe'
}