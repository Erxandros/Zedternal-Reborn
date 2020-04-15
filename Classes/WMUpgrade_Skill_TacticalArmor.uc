Class WMUpgrade_Skill_TacticalArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function bool CanNotBeGrabbed(int upgLevel, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != none && KFPawn_Human(OwnerPawn).Armor > 0)
		return true;
	else
		return false;
}

static function ModifyArmor( out byte MaxArmor, byte DefaultArmor, int upgLevel)
{
	MaxArmor = min(255, MaxArmor + Round(float(DefaultArmor) * default.Armor[upgLevel-1]));
}

defaultproperties
{
	upgradeName="Heavy Armor Training"
	upgradeDescription(0)="While you have body armor, Clots can't grab you. Increase max armor 20%"
	upgradeDescription(1)="While you have body armor, Clots can't grab you. Increase max armor <font color=\"#b346ea\">50%</font>"
	Armor(0)=0.2000000
	Armor(1)=0.5000000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalArmor'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalArmor_Deluxe'
}