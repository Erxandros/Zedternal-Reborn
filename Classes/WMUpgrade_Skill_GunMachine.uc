class WMUpgrade_Skill_GunMachine extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_GunMachine_Helper UPG;

	if (DamageInstigator.Pawn != None && MyKFPM != None)
	{
		UPG = GetHelper(DamageInstigator.Pawn);
		if (UPG != None)
		{
			if (UPG.bActive)
				InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);

			if ((MyKFPM.Health - InDamage) <= 0)
				UPG.SetActive();
		}
	}
}

static function WMUpgrade_Skill_GunMachine_Helper GetHelper(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_GunMachine_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_GunMachine_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_GunMachine_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_GunMachine_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_GunMachine_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Damage(0)=0.25f
	Damage(1)=0.6f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_GunMachine"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_GunMachine'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_GunMachine_Deluxe'

	Name="Default__WMUpgrade_Skill_GunMachine"
}
