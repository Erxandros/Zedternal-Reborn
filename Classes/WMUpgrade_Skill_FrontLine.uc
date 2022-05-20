class WMUpgrade_Skill_FrontLine extends WMUpgrade_Skill;

var array<float> SelfExplosiveResistance, OtherResistance;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Explosive') && KFPlayerController(InstigatedBy) != None)
		InDamage -= DefaultDamage * default.SelfExplosiveResistance[upgLevel - 1];
	else
		InDamage -= DefaultDamage * default.OtherResistance[upgLevel - 1];
}

defaultproperties
{
	SelfExplosiveResistance(0)=0.35f
	SelfExplosiveResistance(1)=0.75f
	OtherResistance(0)=0.05f
	OtherResistance(1)=0.1f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_FrontLine"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrontLine'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FrontLine_Deluxe'

	Name="Default__WMUpgrade_Skill_FrontLine"
}
