class WMUpgrade_Skill_Barbecue extends WMUpgrade_Skill;

var array<float> DamageOverTime;
var array<float> Damage;

static function ModifyDoTScaler(out float InDoTScaler, float DefaultDotScaler, int upgLevel, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	InDoTScaler += DefaultDotScaler * default.DamageOverTime[upgLevel - 1];
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Toxic') || ClassIsChildOf(DamageType, class'KFDT_Freeze') || ClassIsChildOf(DamageType, class'KFDT_Bleeding')))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1] * upgLevel);
}

defaultproperties
{
	DamageOverTime(0)=2.0f
	DamageOverTime(1)=5.0f
	Damage(0)=0.1f
	Damage(1)=0.25f

	UpgradeName="Barbecue"
	UpgradeDescription(0)="Bleed, burn, freeze, and poison effects last 200% longer and do 10% more damage over time"
	UpgradeDescription(1)="Bleed, burn, freeze, and poison effects last <font color=\"#b346ea\">500%</font> longer and do <font color=\"#b346ea\">25%</font> more damage over time"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barbecue'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barbecue_Deluxe'

	Name="Default__WMUpgrade_Skill_Barbecue"
}
