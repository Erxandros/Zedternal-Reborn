Class WMUpgrade_Skill_MadBomber extends WMUpgrade_Skill;
	
var array<float> resistance;

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if ( class<KFDT_Explosive>(DamageType) != none && OwnerPawn.Controller == InstigatedBy )
		InDamage -= Round(float(DefaultDamage) * default.resistance[upgLevel-1]);
}

static simulated function bool ShouldNeverDud(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return true;
}

defaultproperties
{
	upgradeName="Mad Bomber"
	upgradeDescription(0)="<font color=\"#caab05\">Explosive rounds</font> can explode at any range. Increase resistance to your own exlosives 30%"
	upgradeDescription(1)="<font color=\"#caab05\">Explosive rounds</font> can explode at any range. Increase resistance to your own exlosives <font color=\"#b346ea\">75%</font>"
	resistance(0)=0.300000;
	resistance(1)=0.700000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_MadBomber'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_MadBomber_Deluxe'
}