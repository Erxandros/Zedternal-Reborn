class WMUpgrade_Skill_TacticalArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function bool CanNotBeGrabbed(int upgLevel, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None && KFPawn_Human(OwnerPawn).Armor > 0)
		return True;
	else
		return False;
}

static function ModifyArmor(out int MaxArmor, int DefaultArmor, int upgLevel)
{
	MaxArmor += Round(float(DefaultArmor) * default.Armor[upgLevel - 1]);
}

defaultproperties
{
	Armor(0)=0.2f
	Armor(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_TacticalArmor"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalArmor'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TacticalArmor_Deluxe'

	Name="Default__WMUpgrade_Skill_TacticalArmor"
}
