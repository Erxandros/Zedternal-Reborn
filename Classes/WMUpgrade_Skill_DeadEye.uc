Class WMUpgrade_Skill_DeadEye extends WMUpgrade_Skill;

var array<float> Damage, Recoil;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD && MyKFW != None && MyKFW.bUsingSights)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	if (KFW != None && KFW.bUsingSights)
		InRecoilModifier -= DefaultRecoilModifier * default.Recoil[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=0.1f
	Damage(1)=0.25f
	Recoil(0)=0.1f
	Recoil(1)=0.25f

	upgradeName="Dead Eye"
	upgradeDescription(0)="Reduce recoil by 10% and increase head shot damage by 10% when using <font color=\"#eaeff7\">iron sights</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Reduce recoil by <font color=\"#b346ea\">25%</font> and increase head shot damage by <font color=\"#b346ea\">25%</font> when using <font color=\"#eaeff7\">iron sights</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DeadEye_Deluxe'

	Name="Default__WMUpgrade_Skill_DeadEye"
}
