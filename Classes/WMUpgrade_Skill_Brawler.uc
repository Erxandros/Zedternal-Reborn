Class WMUpgrade_Skill_Brawler extends WMUpgrade_Skill;
	
var array<float> Damage;

static function bool CanNotBeGrabbed(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (class<KFDT_Bludgeon>(DamageType) != none || class<KFDT_Piercing>(DamageType) != none || class<KFDT_Slashing>(DamageType) != none)
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Brawler"
	upgradeDescription(0)="Clots can't grab you. Also increase melee damage resistance by 5%"
	upgradeDescription(1)="Clots can't grab you. Also increase melee damage resistance by <font color=\"#b346ea\">10%</font>"
	Damage(0)=0.050000;
	Damage(1)=0.100000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Brawler'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Brawler_Deluxe'
}