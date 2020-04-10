Class WMUpgrade_Skill_Barbecue extends WMUpgrade_Skill;
	
var array<float> DoT;
var array<float> damage;

static function ModifyDoTScaler( out float InDoTScaler, float DefaultDotScaler, int upgLevel, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	InDotScaler += DefaultDotScaler * default.DoT[upgLevel-1];
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Toxic') || ClassIsChildOf(DamageType, class'KFDT_Freeze'))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1] * upgLevel);
}


defaultproperties
{
	upgradeName="Barbecue"
	upgradeDescription(0)="Burn, poison and bleed effects lasts 200% longer, increasing damage over time"
	upgradeDescription(1)="Burn, poison and bleed effects lasts <font color=\"#b346ea\">500%</font> longer, increasing damage over time"
	DoT(0)=2.000000
	DoT(1)=5.000000
	damage(0)=0.100000;
	damage(1)=0.250000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barbecue'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barbecue_Deluxe'
}