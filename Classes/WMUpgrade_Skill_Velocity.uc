Class WMUpgrade_Skill_Velocity extends WMUpgrade_Skill;
	
var array<float> Damage;
var float MaxRadius;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float factor;
	if (MyKFPM != none && DamageInstigator.Pawn != none)
	{
		factor = FMin(1.f, VSizeSQ(DamageInstigator.Pawn.Location - MyKFPM.Location) / default.MaxRadius);
		InDamage += Round( float(DefaultDamage) * default.Damage[upgLevel-1] * factor);
	}
}

defaultproperties
{
	upgradeName="High Velocity"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all weapons</font> up to 25% while shooting ZEDs at long range"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all weapons</font> up to <font color=\"#b346ea\">60%</font> while shooting ZEDs at long range"
	Damage(0)=0.250000
	Damage(1)=0.600000
	MaxRadius=50000000.000000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Velocity'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Velocity_Deluxe'
}