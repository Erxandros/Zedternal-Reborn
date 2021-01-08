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

	upgradeName="Destroyer Of Worlds"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> by 20%"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> by <font color=\"#b346ea\">50%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds_Deluxe'

	Name="Default__WMUpgrade_Skill_DestroyerOfWorlds"
}
