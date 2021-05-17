class WMUpgrade_Skill_HotPepper extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_HotPepper_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_HotPepper_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_HotPepper_Helper', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_HotPepper_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_HotPepper_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	upgradeName="Hot Pepper"
	upgradeDescription(0)="ZEDs within 1.5 meters of you catch on fire in seconds"
	upgradeDescription(1)="ZEDs within 1.5 meters of you catch on <font color=\"#b346ea\">lethal</font> fire in seconds"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HotPepper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HotPepper_Deluxe'

	Name="Default__WMUpgrade_Skill_HotPepper"
}
