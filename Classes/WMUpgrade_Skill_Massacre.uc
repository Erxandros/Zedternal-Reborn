class WMUpgrade_Skill_Massacre extends WMUpgrade_Skill;

var array<float> MeleeDamage, Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && static.IsMeleeDamageType(DamageType))
		InDamage += int(float(DefaultDamage) * default.MeleeDamage[upgLevel - 1]);
	else
		InDamage += int(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.05f
	Damage(1)=0.15f
	MeleeDamage(0)=0.2f
	MeleeDamage(1)=0.5f

	upgradeName="Massacre"
	upgradeDescription(0)="Increase damage with <font color=\"#caab05\">melee weapons</font> by 20% . Increase damage with <font color=\"#eaeff7\">other weapons</font> by 5%"
	upgradeDescription(1)="Increase damage with <font color=\"#caab05\">melee weapons</font> by <font color=\"#b346ea\">50%</font>. Increase damage with <font color=\"#eaeff7\">other weapons</font> by <font color=\"#b346ea\">15%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Massacre'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Massacre_Deluxe'

	Name="Default__WMUpgrade_Skill_Massacre"
}
