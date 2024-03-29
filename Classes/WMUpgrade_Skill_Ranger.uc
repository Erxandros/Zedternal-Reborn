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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Ranger"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Ranger_Deluxe'

	Name="Default__WMUpgrade_Skill_Ranger"
}
