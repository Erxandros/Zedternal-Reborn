Class WMUpgrade_Skill_Ranger extends WMUpgrade_Skill;
	
var float Stun, Chance;
var array<float> Damage;
	
static function ModifyStunPower( out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	if (HitZoneIdx == HZI_HEAD && FRand() <= default.Chance)
	{
		InStunPower += DefaultStunPower * default.Stun;
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Ranger"
	upgradeDescription(0)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> 15%. Also increase head shot stun power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Increase head shot damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">40%</font>. Also increase head shot stun power with <font color=\"#eaeff7\">all weapons</font>"
	Stun=25.000000;
	Chance=0.500000;
	Damage(0)=0.150000;
	Damage(1)=0.400000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger_Deluxe'
}