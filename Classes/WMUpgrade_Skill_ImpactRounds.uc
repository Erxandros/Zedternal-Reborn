Class WMUpgrade_Skill_ImpactRounds extends WMUpgrade_Skill;
	
var array<float> Damage, Stumble;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (class<KFDT_Ballistic>(DamageType) != none)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

static function ModifyStumblePowerPassive( out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.Stumble[upgLevel-1];
}

defaultproperties
{
	upgradeName="Impact Rounds"
	upgradeDescription(0)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> 100%. Increase <font color=\"#eaeff7\">ballistic</font> damage 10%"
	upgradeDescription(1)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">250%</font>. Increase <font color=\"#eaeff7\">ballistic</font> damage <font color=\"#b346ea\">25%</font>"
	Stumble(0)=1.000000
	Stumble(1)=2.500000
	Damage(0)=0.100000
	Damage(1)=0.250000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ImpactRounds'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ImpactRounds_Deluxe'
}