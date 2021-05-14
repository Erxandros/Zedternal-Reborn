class WMUpgrade_Skill_Spartan extends WMUpgrade_Skill;

var array<float> FireRate, SpecialRate;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None)
		OwnerPawn.bMovesFastInZedTime = True;
}

static simulated function bool IsUnAffectedByZedTime(int upgLevel, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None)
		OwnerPawn.bMovesFastInZedTime = True;

	return True;
}

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;

	if (KFW != None)
	{
		StateName = KFW.GetStateName();
		if (class'ZedternalReborn.WMWeaponStates'.static.IsWeaponAttackState(StateName))
		{
			if (KFWeap_MeleeBase(KFW) != None || KFW.default.MagazineCapacity[0] > 4)
				InModifier += default.FireRate[upgLevel - 1];
			else
				InModifier += default.SpecialRate[upgLevel - 1];
		}
	}
}

static simulated function RevertUpgradeChanges(Pawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None)
			KFPawn_Human(OwnerPawn).bMovesFastInZedTime = False;
}

defaultproperties
{
	FireRate(0)=0.6f
	FireRate(1)=1.2f
	SpecialRate(0)=0.2f
	SpecialRate(1)=0.4f

	upgradeName="Spartan"
	upgradeDescription(0)="You move and attack faster during Zed time"
	upgradeDescription(1)="You move and attack <font color=\"#b346ea\">insanely</font> fast during Zed time"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Spartan_Deluxe'

	Name="Default__WMUpgrade_Skill_Spartan"
}
