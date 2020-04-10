Class WMUpgrade_Skill_Cripple extends WMUpgrade_Skill;
	
var float Snare;
var array<float> Damage;

static function ModifySnarePowerPassive( out float snarePowerFactor, int upgLevel)
{
	snarePowerFactor += default.Snare;
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Cripple"
	upgradeDescription(0)="Multiple hits with <font color=\"#eaeff7\">all weapon</font> will slow ZEDs down up to 30%. Increase damage you dealt with <font color=\"#eaeff7\">all weapons</font> 10%"
	upgradeDescription(1)="Multiple hits with <font color=\"#eaeff7\">all weapon</font> will slow ZEDs down up to 30%. Increase damage you dealt with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">25%</font>"
	Snare=10.00000;
	Damage(0)=0.10000;
	Damage(1)=0.25000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Destruction'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Destruction_Deluxe'
}