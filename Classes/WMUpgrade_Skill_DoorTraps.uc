class WMUpgrade_Skill_DoorTraps extends WMUpgrade_Skill;

var array<float> Bonus;
var array<int> ExtraGrenades;

static simulated function bool DoorShouldNuke(int upgLevel, KFPawn OwnerPawn)
{
	if (upgLevel > 1)
		return True;
}

static simulated function bool CanExplosiveWeld(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

static simulated function ModifyWeldingRate(out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate, int upgLevel)
{
	InFastenRate += DefaultFastenRate * default.Bonus[upgLevel - 1];
	InUnfastenRate += DefaultUnfastenRate * default.Bonus[upgLevel - 1];
}

static simulated function ModifySpareGrenadeAmount(out int SpareGrenade, int DefaultSpareGrenade, int upgLevel)
{
	SpareGrenade += default.ExtraGrenades[upgLevel - 1];
}

defaultproperties
{
	Bonus(0)=0.75f
	Bonus(1)=2.0f
	ExtraGrenades(0)=1
	ExtraGrenades(1)=2

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_DoorTraps"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DoorTraps'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DoorTraps_Deluxe'

	Name="Default__WMUpgrade_Skill_DoorTraps"
}
