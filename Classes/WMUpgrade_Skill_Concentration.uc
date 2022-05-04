class WMUpgrade_Skill_Concentration extends WMUpgrade_Skill;

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

	UpgradeName="Concentration"
	UpgradeDescription(0)="During ZED Time you do 30% more damage with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeDescription(1)="During ZED Time you do <font color=\"#b346ea\">75%</font> more damage with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Concentration_Deluxe'

	Name="Default__WMUpgrade_Skill_Concentration"
}
