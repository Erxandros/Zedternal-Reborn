class WMUpgrade_Skill_Vampire extends WMUpgrade_Skill;

var array<int> MeleeVampire, WeapVampire;

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	if (DT != None && static.IsMeleeDamageType(DT))
		InHealth += default.MeleeVampire[upgLevel - 1];
	else
		InHealth += default.WeapVampire[upgLevel - 1];
}

defaultproperties
{
	MeleeVampire(0)=3
	MeleeVampire(1)=8
	WeapVampire(0)=2
	WeapVampire(1)=5

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Vampire"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Vampire'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Vampire_Deluxe'

	Name="Default__WMUpgrade_Skill_Vampire"
}
