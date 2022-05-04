class WMUpgrade_Skill_Tank extends WMUpgrade_Skill;

var array<float> Resistance, Critical;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tank_Helper UPG;

	if (OwnerPawn != None && OwnerPawn.Health >= int(float(OwnerPawn.HealthMax) * default.Critical[upgLevel - 1]))
	{
		InDamage -= Max(1, Round(float(DefaultDamage) * default.Resistance[upgLevel - 1]));

		UPG = GetHelper(OwnerPawn);
		if (UPG != None)
			UPG.ActiveEffect();
	}
}

static function WMUpgrade_Skill_Tank_Helper GetHelper(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tank_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tank_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tank_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tank_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tank_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tank_Helper', OwnerPawn);
	}
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Tank_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tank_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Resistance(0)=0.2f
	Resistance(1)=0.3f
	Critical(0)=0.9f
	Critical(1)=0.7f

	UpgradeName="Tank"
	UpgradeDescription(0)="Increase damage resistance by 20% while your health is higher than 90%"
	UpgradeDescription(1)="Increase damage resistance by <font color=\"#b346ea\">30%</font> while your health is higher than <font color=\"#b346ea\">70%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tank'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tank_Deluxe'

	Name="Default__WMUpgrade_Skill_Tank"
}
