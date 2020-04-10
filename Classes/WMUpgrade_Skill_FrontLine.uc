Class WMUpgrade_Skill_FrontLine extends WMUpgrade_Skill;
	
var array<float> Damage, Resistance;
	
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf( DamageType, class'KFDT_Explosive' ) && KFPlayerController(InstigatedBy) != none)
		InDamage -= DefaultDamage * (default.Damage[upgLevel-1] + default.Resistance[upgLevel-1]);
	else
		InDamage -= DefaultDamage * default.Resistance[upgLevel-1];
}

defaultproperties
{
	upgradeName="Front Line"
	upgradeDescription(0)="Increase resistance to your own exlosives 35%. Increase other damage resistances 5%"
	upgradeDescription(1)="Increase resistance to your own exlosives <font color=\"#b346ea\">75%</font>. Increase other damage resistances <font color=\"#b346ea\">10%</font>"
	Damage(0)=0.350000;
	Damage(1)=0.750000;
	Resistance(0)=0.050000;
	Resistance(1)=0.100000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrontLine'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrontLine_Deluxe'
}