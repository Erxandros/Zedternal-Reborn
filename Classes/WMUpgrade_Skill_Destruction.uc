class WMUpgrade_Skill_Destruction extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Destruction_Counter UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Destruction_Counter', UPG)
		{
			if (UPG != None)
			{
				bFound = True;
				break;
			}
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Destruction_Counter', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Destruction"
	upgradeDescription(0)="All nearby ZEDs fall down whenever Zed time starts (radius of 5m)"
	upgradeDescription(1)="All nearby ZEDs fall down whenever Zed time starts (radius of <font color=\"#b346ea\">10m</font>)"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Cripple'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Cripple_Deluxe'

	Name="Default__WMUpgrade_Skill_Destruction"
}
