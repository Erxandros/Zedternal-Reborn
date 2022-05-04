class WMUpgrade_Skill_Assassin extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.2f
	Damage(1)=0.5f

	UpgradeName="Assassin"
	UpgradeDescription(0)="Increase headshot damage with <font color=\"#eaeff7\">all weapons</font> by 20%"
	UpgradeDescription(1)="Increase headshot damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">50%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Assassin'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Assassin_Deluxe'

	Name="Default__WMUpgrade_Skill_Assassin"
}
