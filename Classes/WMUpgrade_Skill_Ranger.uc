class WMUpgrade_Skill_Ranger extends WMUpgrade_Skill;

var array<float> Damage, Stun;

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	if (HitZoneIdx == HZI_HEAD)
		InStunPower += DefaultStunPower * default.Stun[upgLevel - 1];
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.15f
	Damage(1)=0.4f
	Stun(0)=0.5f
	Stun(1)=1.25f

	upgradeName="Ranger"
	upgradeDescription(0)="Increase headshot damage with <font color=\"#eaeff7\">all weapons</font> by 15% and increase headshot stun power with <font color=\"#eaeff7\">all weapons</font> by 50%"
	upgradeDescription(1)="Increase headshot damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font> and increase headshot stun power with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">125%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger_Deluxe'

	Name="Default__WMUpgrade_Skill_Ranger"
}
