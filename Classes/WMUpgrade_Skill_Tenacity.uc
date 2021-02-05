class WMUpgrade_Skill_Tenacity extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (DamageInstigator != None && KFPawn(DamageInstigator.Pawn) != None && MyKFPM != None && (MyKFPM.Health - InDamage) <= 0)
	{
		UPG = GetCounter(KFPawn(DamageInstigator.Pawn));
		if (UPG != None)
			UPG.SetActive();
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (OwnerPawn != None)
	{
		UPG = GetCounter(OwnerPawn);
		if (UPG != None && UPG.bActive)
			InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
	}
}

static function WMUpgrade_Skill_Tenacity_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tenacity_Counter', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tenacity_Counter', OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	Damage(0)=0.15f
	Damage(1)=0.4f

	upgradeName="Tenacity"
	upgradeDescription(0)="Reduces incoming damage by 15% during a short time after killing a ZED"
	upgradeDescription(1)="Reduces incoming damage by <font color=\"#b346ea\">40%</font> during a short time after killing a ZED"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity_Deluxe'

	Name="Default__WMUpgrade_Skill_Tenacity"
}
