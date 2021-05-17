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

	upgradeName="Dead Eye"
	upgradeDescription(0)="When using iron sights headshot damage increases by 10% and recoil decreases by 10% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="When using iron sights headshot damage increases by <font color=\"#b346ea\">25%</font> and recoil decreases by <font color=\"#b346ea\">25%</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye_Deluxe'

	Name="Default__WMUpgrade_Skill_DeadEye"
}
