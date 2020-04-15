Class WMUpgrade_Skill_Sniper extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageInstigator.Pawn != none && VSizeSq(DamageInstigator.Pawn.Velocity) <= 0)
		InDamage += Round( float(DefaultDamage) * default.Damage[upgLevel-1] );
}

defaultproperties
{
	upgradeName="Sniper"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all weapons</font> 20% while stationary"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">50%</font> while stationary"
	Damage(0)=0.200000;
	Damage(1)=0.500000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Sniper'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Sniper_Deluxe'
}