Class WMUpgrade_Skill_Assassin extends WMUpgrade_Skill;

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

	upgradeName="Assassin"
	upgradeDescription(0)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> by 20%"
	upgradeDescription(1)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">50%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Assassin'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Assassin_Deluxe'

	Name="Default__WMUpgrade_Skill_Assassin"
}
