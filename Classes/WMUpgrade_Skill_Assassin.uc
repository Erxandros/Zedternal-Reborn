Class WMUpgrade_Skill_Assassin extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}
	
defaultproperties
{
	upgradeName="Assassin"
	upgradeDescription(0)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> 20%"
	upgradeDescription(1)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">50%</font>"
	Damage(0)=0.200000
	Damage(1)=0.500000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Assassin'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Assassin_Deluxe'
}