Class WMUpgrade_Skill_RiotShield extends WMUpgrade_Skill;

var array<float> Damage, otherDamage;

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if( class<KFDT_Ballistic>(Damagetype) != none )
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
	else
		InDamage -= Round(float(DefaultDamage) * default.otherDamage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Riot Shield"
	upgradeDescription(0)="Increase resistance to projectile damage 50%. Increase resistance to other damages 5%"
	upgradeDescription(1)="Increase resistance to projectile damage <font color=\"#b346ea\">90%</font>. Increase resistance to other damages <font color=\"#b346ea\">10%</font>"
	Damage(0)=0.500000
	Damage(1)=0.900000
	otherDamage(0)=0.050000
	otherDamage(1)=0.100000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RiotShield'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RiotShield_Deluxe'
}