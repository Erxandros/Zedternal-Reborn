class WMUpgrade_Skill_MedicalInjection extends WMUpgrade_Skill;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_MedicalInjection_Regen UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MedicalInjection_Regen', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_MedicalInjection_Regen', OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Medical Injection"
	upgradeDescription(0)="Regenerate up to 3 points of health every second when your health is low"
	upgradeDescription(1)="Regenerate up to <font color=\"#b346ea\">8</font> points of health every second when your health is low"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MedicalInjection'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MedicalInjection_Deluxe'

	Name="Default__WMUpgrade_Skill_MedicalInjection"
}
