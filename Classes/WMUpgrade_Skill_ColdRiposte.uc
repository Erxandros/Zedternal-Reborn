class WMUpgrade_Skill_ColdRiposte extends WMUpgrade_Skill;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_ColdRiposte_Helper UPG;

	if (InDamage > 0)
	{
		UPG = GetHelper(OwnerPawn, upgLevel);
		if (UPG != None && UPG.bReady)
			UPG.Explosion();
	}
}

static function WMUpgrade_Skill_ColdRiposte_Helper GetHelper(KFPawn OwnerPawn, int upgLevel)
{
	local WMUpgrade_Skill_ColdRiposte_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ColdRiposte_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ColdRiposte_Helper', OwnerPawn);
		UPG.bDeluxe = (upgLevel > 1);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_ColdRiposte_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ColdRiposte_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	upgradeName="Cold Riposte"
	upgradeDescription(0)="Release Ice explosion when you take damage"
	upgradeDescription(1)="Release <font color=\"#b346ea\">Huge</font> Ice explosion when you take damage"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ColdRiposte'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ColdRiposte_Deluxe'

	Name="Default__WMUpgrade_Skill_ColdRiposte"
}
