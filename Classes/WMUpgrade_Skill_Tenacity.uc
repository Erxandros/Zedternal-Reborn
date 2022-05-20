class WMUpgrade_Skill_Tenacity extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Helper UPG;

	if (DamageInstigator != None && KFPawn(DamageInstigator.Pawn) != None && MyKFPM != None && (MyKFPM.Health - InDamage) <= 0)
	{
		UPG = GetHelper(KFPawn(DamageInstigator.Pawn));
		if (UPG != None)
			UPG.SetActive();
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Helper UPG;

	if (OwnerPawn != None)
	{
		UPG = GetHelper(OwnerPawn);
		if (UPG != None && UPG.bActive)
			InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
	}
}

static function WMUpgrade_Skill_Tenacity_Helper GetHelper(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tenacity_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tenacity_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tenacity_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Tenacity_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tenacity_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Damage(0)=0.15f
	Damage(1)=0.4f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Tenacity"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity_Deluxe'

	Name="Default__WMUpgrade_Skill_Tenacity"
}
