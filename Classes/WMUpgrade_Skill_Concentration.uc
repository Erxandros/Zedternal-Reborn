Class WMUpgrade_Skill_Concentration extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageInstigator != none && DamageInstigator.WorldInfo.TimeDilation < 1)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Concentration"
	upgradeDescription(0)="During Zed time, you do 30% more damage with <font color=\"#eaeff7\">all weapon</font>"
	upgradeDescription(1)="During Zed time, you do <font color=\"#b346ea\">75%</font> more damage with <font color=\"#eaeff7\">all weapon</font>"
	Damage(0)=0.300000
	Damage(1)=0.750000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration_Deluxe'
}