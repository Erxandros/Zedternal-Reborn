class WMUpgrade_Skill_AssaultArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function WaveEnd(int upgLevel, KFPlayerController KFPC)
{
	local WMUpgrade_Skill_AssaultArmor_Counter UPG;

	if (KFPC.Pawn != None)
	{
		UPG = GetCounter(KFPC.Pawn);
		if (UPG != None)
			UPG.GiveArmor(default.Armor[upgLevel - 1]);
	}
}

static simulated function WMUpgrade_Skill_AssaultArmor_Counter GetCounter(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_AssaultArmor_Counter UPG;

	if (WMPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_AssaultArmor_Counter', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_AssaultArmor_Counter', OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	Armor(0)=0.5f
	Armor(1)=1.0f

	upgradeName="Assault Armor"
	upgradeDescription(0)="Repair 50% of your armor for every wave completed"
	upgradeDescription(1)="Repair <font color=\"#b346ea\">100%</font> of your armor for every wave completed"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AssaultArmor'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AssaultArmor_Deluxe'

	Name="Default__WMUpgrade_Skill_AssaultArmor"
}
