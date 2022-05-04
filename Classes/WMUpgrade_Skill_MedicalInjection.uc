class WMUpgrade_Skill_MedicalInjection extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_MedicalInjection_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MedicalInjection_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_MedicalInjection_Helper', OwnerPawn);
			UPG.StartTimer(upgLevel > 1);
		}
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_MedicalInjection_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MedicalInjection_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	UpgradeName="Medical Injection"
	UpgradeDescription(0)="Regenerate up to 3 points of health every second when your health is low with lower health equaling faster regeneration"
	UpgradeDescription(1)="Regenerate up to <font color=\"#b346ea\">8</font> points of health every second when your health is low with lower health equaling faster regeneration"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MedicalInjection'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MedicalInjection_Deluxe'

	Name="Default__WMUpgrade_Skill_MedicalInjection"
}
