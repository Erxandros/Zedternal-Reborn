class WMUpgrade_Skill_Emergency extends WMUpgrade_Skill;

var int MinHealth;
var float MinHealthInv;
var array<float> MaxSpeed;

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	if (OwnerPawn != None && OwnerPawn.Health < default.MinHealth)
		InSpeed += DefaultSpeed * default.MaxSpeed[upgLevel - 1] * float(default.MinHealth - OwnerPawn.Health) * default.MinHealthInv;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Emergency_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Emergency_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Emergency_Helper', OwnerPawn);
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Emergency_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Emergency_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	MinHealth=50
	MinHealthInv=0.02f
	MaxSpeed(0)=0.3f
	MaxSpeed(1)=0.75f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Emergency"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Emergency'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Emergency_Deluxe'

	Name="Default__WMUpgrade_Skill_Emergency"
}
