class WMUpgrade_Skill_Cripple extends WMUpgrade_Skill;

var float Snare;
var array<float> Damage;

static function ModifySnarePowerPassive(out float snarePowerFactor, int upgLevel)
{
	snarePowerFactor += default.Snare;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Snare=10.0f
	Damage(0)=0.1f
	Damage(1)=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Cripple"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Destruction'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Destruction_Deluxe'

	Name="Default__WMUpgrade_Skill_Cripple"
}
