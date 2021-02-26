class WMUpgrade_Skill_Parry extends WMUpgrade_Skill;

var array<float> Damage, Resistance;

static simulated function SuccessfullParry(int upgLevel, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Helper UPG;

	if (OwnerPawn != None && OwnerPawn.Role == Role_Authority)
	{
		UPG = GetHelper(OwnerPawn);
		if (UPG != None)
			UPG.ActiveEffect();
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Parry_Helper UPG;

	if (MyKFW != None && MyKFW.Owner != None)
	{
		UPG = GetHelper(KFPawn(MyKFW.Owner));
		if (UPG != None && UPG.bOn)
			InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Parry_Helper UPG;

	if (OwnerPawn != None)
	{
		UPG = GetHelper(OwnerPawn);
		if (UPG != None && UPG.bOn)
			InDamage -= Round(float(DefaultDamage) * default.Resistance[upgLevel - 1]);
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Helper UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None && OwnerPawn.Role == Role_Authority)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Parry_Helper', UPG)
		{
			bFound = True;
			break;
		}

		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Parry_Helper', OwnerPawn);
	}
}

static function WMUpgrade_Skill_Parry_Helper GetHelper(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Parry_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Parry_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Parry_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Damage(0)=0.3f
	Damage(1)=0.75f
	Resistance(0)=0.3f
	Resistance(1)=0.4f

	upgradeName="Parry"
	upgradeDescription(0)="Parrying an attack with a melee weapon reduces incoming damage by 30% and increases damage by 30% with <font color=\"#eaeff7\">any weapon</font> for 10 seconds"
	upgradeDescription(1)="Parrying an attack with a melee weapon reduces incoming damage by <font color=\"#b346ea\">40%</font> and increases damage by <font color=\"#b346ea\">75%</font> with <font color=\"#eaeff7\">any weapon</font> for 10 seconds"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Parry'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Parry_Deluxe'

	Name="Default__WMUpgrade_Skill_Parry"
}
