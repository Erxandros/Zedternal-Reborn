class WMUpgrade_Skill_SonicResistantRounds extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Sonic'))
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static simulated function bool ProjSirenResist(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Damage(0)=0.4f
	Damage(1)=1.0f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_SonicResistantRounds"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_SonicResistantRounds"
}
