class WMUpgrade_Skill_AirborneAgent extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_AirborneAgent_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_AirborneAgent_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_AirborneAgent_Helper', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_AirborneAgent_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_AirborneAgent_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	UpgradeName="Airborne Agent"
	UpgradeDescription(0)="Release healing gas when you or nearby teammates are in danger"
	UpgradeDescription(1)="Release <font color=\"#b346ea\">potent</font> healing gas when you or nearby teammates are in danger"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AirborneAgent'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AirborneAgent_Deluxe'

	Name="Default__WMUpgrade_Skill_AirborneAgent"
}
