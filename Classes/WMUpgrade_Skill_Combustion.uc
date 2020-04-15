Class WMUpgrade_Skill_Combustion extends WMUpgrade_Skill;
	
var array<float> damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Toxic') || ClassIsChildOf(DamageType, class'KFDT_Freeze'))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1] * upgLevel);
}

defaultproperties
{
	upgradeName="Combustion"
	upgradeDescription(0)="Increase burn, freeze and poison damages by 25%"
	upgradeDescription(1)="Increase burn, freeze and poison damages by <font color=\"#b346ea\">60%</font>"
	damage(0)=0.250000;
	damage(1)=0.600000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Combustion'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Combustion_Deluxe'
}