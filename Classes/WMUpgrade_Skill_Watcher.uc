Class WMUpgrade_Skill_Watcher extends WMUpgrade_Skill;

var float criticalHealth;
var array<float> Damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none && MyKFPM.Health <= int(float(MyKFPM.HealthMax) * default.criticalHealth))
		InDamage += Round( float(DefaultDamage) * default.Damage[upgLevel-1] );
}

static simulated function bool CanSeeEnemyHealth(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}

defaultproperties
{
	upgradeName="Watcher"
	upgradeDescription(0)="Allow you to see ZEDs health. Increase damage with <font color=\"#eaeff7\">all weapons</font> 25% to greatly injured ZEDs"
	upgradeDescription(1)="Allow you to see ZEDs health. Increase damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">60%</font> to greatly injured ZEDs"
	criticalHealth = 0.250000
	Damage(0)=0.250000
	Damage(1)=0.600000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Watcher'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Watcher_Deluxe'
}