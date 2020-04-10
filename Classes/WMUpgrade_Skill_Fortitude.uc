Class WMUpgrade_Skill_Fortitude extends WMUpgrade_Skill;
	
var array<float> Health;
	
static function ModifyHealth( out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.Health[upgLevel-1]);
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Fortitude_Regen UPG;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Fortitude_Regen',UPG)
			UPG.Destroy();
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Fortitude_Regen',OwnerPawn);
		UPG.bDeluxe = (upgLevel > 1);
	}
}

defaultproperties
{
	upgradeName="Fortitude"
	upgradeDescription(0)="Increase total Health by 10% and heal 1 health point every 2 seconds"
	upgradeDescription(1)="Increase total Health by <font color=\"#b346ea\">25%</font> and heal 1 health point <font color=\"#b346ea\">every second</font>"
	Health(0)=0.100000;
	Health(1)=0.250000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fortitude'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fortitude_Deluxe'
}