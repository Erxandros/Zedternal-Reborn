class WMUpgrade_Skill_CoagulantBooster extends WMUpgrade_Skill;

var array<float> Resistance, MaxResistance;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (OwnerPawn != None)
		InDamage -= Round(float(DefaultDamage) * FMax(FMin(default.Resistance[upgLevel - 1] * float(OwnerPawn.HealthMax - OwnerPawn.Health), default.MaxResistance[upgLevel - 1]), 0.0f));
}

defaultproperties
{
	Resistance(0)=0.001f
	Resistance(1)=0.0025f
	MaxResistance(0)=0.1f
	MaxResistance(1)=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_CoagulantBooster"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CoagulantBooster'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CoagulantBooster_Deluxe'

	Name="Default__WMUpgrade_Skill_CoagulantBooster"
}
