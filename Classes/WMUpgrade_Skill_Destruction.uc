class WMUpgrade_Skill_Destruction extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Destruction_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Destruction_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Destruction_Helper', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Destruction_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Destruction_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	upgradeName="Destruction"
	upgradeDescription(0)="ZEDs within 5 meters of you fall down whenever ZED Time starts"
	upgradeDescription(1)="ZEDs within <font color=\"#b346ea\">10</font> meters of you fall down whenever ZED Time starts"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Cripple'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Cripple_Deluxe'

	Name="Default__WMUpgrade_Skill_Destruction"
}
