Class WMUpgrade_Skill_DestroyerOfWorlds extends WMUpgrade_Skill;

var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageType != none && (class<KFDT_Explosive>(DamageType) != none || static.IsGrenadeDT(DamageType)))
		InDamage += DefaultDamage * default.Damage[upgLevel-1];
}

defaultproperties
{
	upgradeName="Destroyer Of Worlds"
	upgradeDescription(0)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> 20%"
	upgradeDescription(1)="Increase damage with <font color=\"#eaeff7\">all explosives</font> and <font color=\"#eaeff7\">all grenades</font> <font color=\"#b346ea\">50%</font>"
	Damage(0)=0.200000
	Damage(1)=0.500000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_DestroyerOfWorlds_Deluxe'
}