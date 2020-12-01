Class WMUpgrade_Skill_Ranger extends WMUpgrade_Skill;

var float Stun, Chance;
var array<float> Damage;

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	if (HitZoneIdx == HZI_HEAD && FRand() <= default.Chance)
	{
		InStunPower += DefaultStunPower * default.Stun;
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Stun=25.0f
	Chance=0.5f
	Damage(0)=0.15f
	Damage(1)=0.4f

	upgradeName="Ranger"
	upgradeDescription(0)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> by 15%. Also increase head shot stun power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font>. Also increase head shot stun power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger_Deluxe'

	Name="Default__WMUpgrade_Skill_Ranger"
}
