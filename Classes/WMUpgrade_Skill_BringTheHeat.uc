class WMUpgrade_Skill_BringTheHeat extends WMUpgrade_Skill;

var float FireBonus;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_BringTheHeat_Counter UPG;

	if (DamageType != None && DamageInstigator.Pawn != None)
	{
		UPG = GetCounter(DamageInstigator.Pawn);
		if (UPG != None)
		{
			if (ClassIsChildOf(DamageType, class'KFDT_Fire'))
				UPG.CumulativeDamage += Round(InDamage * default.FireBonus * upgLevel);
			else
				UPG.CumulativeDamage += InDamage * upgLevel;
		}
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'WMDT_BringTheHeat'))
		InDamage = 0;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_BringTheHeat_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_BringTheHeat_Counter', UPG)
		{
			UPG.Destroy();
		}

		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_BringTheHeat_Counter', OwnerPawn);
		UPG.Player = KFPawn_Human(OwnerPawn);
	}
}

static function WMUpgrade_Skill_BringTheHeat_Counter GetCounter(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_BringTheHeat_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_BringTheHeat_Counter', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_BringTheHeat_Counter', OwnerPawn);
		UPG.Player = KFPawn_Human(OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	FireBonus=1.4f

	upgradeName="Bring the Heat"
	upgradeDescription(0)="Release fire waves while damaging zeds with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Release <font color=\"#b346ea\">many</font> fire waves while damaging zeds with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BringTheHeat'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BringTheHeat_Deluxe'

	Name="Default__WMUpgrade_Skill_BringTheHeat"
}
