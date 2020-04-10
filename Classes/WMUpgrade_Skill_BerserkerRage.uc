Class WMUpgrade_Skill_BerserkerRage extends WMUpgrade_Skill;
	
var array<float> damage, meleeDamage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (KFPawn_Human(DamageInstigator.Pawn) != none && KFPawn_Human(DamageInstigator.Pawn).Armor <= 0)
	{
		if (DamageType != none && static.IsMeleeDamageType(DamageType))
			InDamage += Round(float(DefaultDamage) * default.meleeDamage[upgLevel-1]);
		else
			InDamage += Round(float(DefaultDamage) * default.damage[upgLevel-1]);
	}
}


defaultproperties
{
	upgradeName="Berserker Rage"
	upgradeDescription(0)="While you dont have armor, increase <font color=\"#caab05\">melee damage</font> by 30% and <font color=\"#eaeff7\">any other damage</font> by 10%"
	upgradeDescription(1)="While you dont have armor, increase <font color=\"#caab05\">melee damage</font> by <font color=\"#b346ea\">75%</font> and <font color=\"#eaeff7\">any other damage</font> by <font color=\"#b346ea\">25%</font>"
	meleeDamage(0)=0.300000;
	meleeDamage(1)=0.750000;
	damage(0)=0.100000;
	damage(1)=0.250000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BerserkerRage'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BerserkerRage_Deluxe'
}