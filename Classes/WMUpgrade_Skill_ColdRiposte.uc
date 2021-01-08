class WMUpgrade_Skill_ColdRiposte extends WMUpgrade_Skill;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_ColdRiposte_Counter UPG;

	if (InDamage > 0)
	{
		UPG = GetCounter(OwnerPawn, upgLevel);
		if (UPG != None && UPG.bReady)
			UPG.Explosion(OwnerPawn);
	}
}

static function WMUpgrade_Skill_ColdRiposte_Counter GetCounter(KFPawn OwnerPawn, int upgLevel)
{
	local WMUpgrade_Skill_ColdRiposte_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_ColdRiposte_Counter', UPG)
		{
			if (UPG != None)
				return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_ColdRiposte_Counter', OwnerPawn);
		UPG.bDeluxe = (upgLevel > 1);
	}

	return UPG;
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
