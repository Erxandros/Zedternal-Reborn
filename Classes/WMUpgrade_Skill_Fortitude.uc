class WMUpgrade_Skill_Fortitude extends WMUpgrade_Skill;

var array<float> Health;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * default.Health[upgLevel - 1]);
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Fortitude_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Fortitude_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Fortitude_Helper', OwnerPawn);
			UPG.StartTimer(upgLevel > 1);
		}
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Fortitude_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Fortitude_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Health(0)=0.1f
	Health(1)=0.25f

	upgradeName="Fortitude"
	upgradeDescription(0)="Increase total health by 10% and regenerate 1 health point every 2 seconds"
	upgradeDescription(1)="Increase total health by <font color=\"#b346ea\">25%</font> and regenerate 1 health point <font color=\"#b346ea\">every second</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fortitude'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Fortitude_Deluxe'

	Name="Default__WMUpgrade_Skill_Fortitude"
}
