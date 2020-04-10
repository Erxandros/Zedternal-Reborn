Class WMUpgrade_Skill_Resistance extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if( class<KFDT_Toxic>(Damagetype) != none || class<KFDT_Sonic>(Damagetype) != none || class<KFDT_Fire>(Damagetype) != none )
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Resistance"
	upgradeDescription(0)="Increase resistance to fire, sonic and poison damages 25%"
	upgradeDescription(1)="Increase resistance to fire, sonic and poison damages <font color=\"#b346ea\">60%</font>"
	Damage(0)=0.250000
	Damage(1)=0.600000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Resistance'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Resistance_Deluxe'
}