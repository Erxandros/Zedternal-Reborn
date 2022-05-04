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

	UpgradeName="Vampire"
	UpgradeDescription(0)="Whenever you kill a ZED heal 2 points of health for any <font color=\"#caab05\">projectile weapon</font> or heal 3 points of health for any <font color=\"#caab05\">melee weapon</font>"
	UpgradeDescription(1)="Whenever you kill a ZED heal <font color=\"#b346ea\">5</font> points of health for any <font color=\"#caab05\">projectile weapon</font> or heal <font color=\"#b346ea\">8</font> points of health for any <font color=\"#caab05\">melee weapon</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Vampire'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Vampire_Deluxe'

	Name="Default__WMUpgrade_Skill_Vampire"
}
