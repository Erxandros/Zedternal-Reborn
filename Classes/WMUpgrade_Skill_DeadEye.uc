class WMUpgrade_Skill_DeadEye extends WMUpgrade_Skill;

var array<float> Bonus;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD && MyKFW != None && MyKFW.bUsingSights)
		InDamage += Round(float(DefaultDamage) * default.Bonus[upgLevel - 1]);
}

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != None && KFW.bUsingSights)
		InRecoilModifier -= DefaultRecoilModifier * default.Bonus[upgLevel - 1];
}

defaultproperties
{
	Bonus(0)=0.1f
	Bonus(1)=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_DeadEye"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye_Deluxe'

	Name="Default__WMUpgrade_Skill_DeadEye"
}
