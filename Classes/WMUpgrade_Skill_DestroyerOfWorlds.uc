class WMUpgrade_Skill_DestroyerOfWorlds extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != None && (ClassIsChildOf(DamageType, class'KFDT_Explosive') || static.IsGrenadeDT(DamageType)))
		InDamage += DefaultDamage * default.Damage[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=0.2f
	Damage(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_DestroyerOfWorlds"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds_Deluxe'

	Name="Default__WMUpgrade_Skill_DestroyerOfWorlds"
}
