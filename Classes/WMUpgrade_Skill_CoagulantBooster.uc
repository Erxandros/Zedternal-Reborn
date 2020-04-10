Class WMUpgrade_Skill_CoagulantBooster extends WMUpgrade_Skill;
	
var array<float> Resistance, maxResistance;
	
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (OwnerPawn != none)
		InDamage -= Round( float(DefaultDamage) * FMax( FMin( default.Resistance[upgLevel-1] * float(OwnerPawn.HealthMax - OwnerPawn.Health), default.maxResistance[upgLevel-1] ), 0.f) );
}

defaultproperties
{
	upgradeName="Coagulant Booster"
	upgradeDescription(0)="Increase damage resistance 0.10% per Health point lost, up to 10%"
	upgradeDescription(1)="Increase damage resistance <font color=\"#b346ea\">0.25%</font> per Health point lost, up to <font color=\"#b346ea\">25%</font>"
	Resistance(0)=0.001000;
	Resistance(1)=0.002500;
	maxResistance(0)=0.100000;
	maxResistance(1)=0.250000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CoagulantBooster'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CoagulantBooster_Deluxe'
}