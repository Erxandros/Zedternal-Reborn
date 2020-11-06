Class WMUpgrade_Skill_Concentration extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageInstigator != None && DamageInstigator.WorldInfo.TimeDilation < 1)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.3f
	Damage(1)=0.75f

	upgradeName="Concentration"
	upgradeDescription(0)="During Zed time, you do 30% more damage with <font color=\"#eaeff7\">all weapon</font>"
	upgradeDescription(1)="During Zed time, you do <font color=\"#b346ea\">75%</font> more damage with <font color=\"#eaeff7\">all weapon</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration_Deluxe'

	Name="Default__WMUpgrade_Skill_Concentration"
}
