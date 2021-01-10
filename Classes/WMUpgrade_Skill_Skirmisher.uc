class WMUpgrade_Skill_Skirmisher extends WMUpgrade_Skill;

var array<float> MoveSpeed;

static simulated function ModifySpeedPassive(out float speedFactor, int upgLevel)
{
	speedFactor += default.MoveSpeed[upgLevel - 1];
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Skirmisher_Regen UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Skirmisher_Regen', UPG)
		{
			UPG.Destroy();
		}

		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Skirmisher_Regen', OwnerPawn);
		UPG.bDeluxe = (upgLevel > 1);
	}
}

defaultproperties
{
	MoveSpeed(0)=0.05f
	MoveSpeed(1)=0.1f

	upgradeName="Skirmisher"
	upgradeDescription(0)="Move 5% faster and regenerate 1 point of health every second"
	upgradeDescription(1)="Move <font color=\"#b346ea\">10%</font> faster and regenerate <font color=\"#b346ea\">2</font> points of health every second"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Skirmisher'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Skirmisher_Deluxe'

	Name="Default__WMUpgrade_Skill_Skirmisher"
}
