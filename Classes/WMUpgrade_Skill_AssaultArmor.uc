Class WMUpgrade_Skill_AssaultArmor extends WMUpgrade_Skill;

var array<float> Armor;

static function WaveEnd( int upgLevel, KFPlayerController KFPC)
{
	local WMUpgrade_Skill_AssaultArmor_Counter UPG;
	
	if (KFPawn(KFPC.Pawn) != none)
	{
		UPG = GetCounter(KFPawn(KFPC.Pawn));
		UPG.GiveArmor(default.Armor[upgLevel-1]);
	}
}

static simulated function WMUpgrade_Skill_AssaultArmor_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_AssaultArmor_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_AssaultArmor_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_AssaultArmor_Counter',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	return UPG;
}

defaultproperties
{
	upgradeName="Assault Armor"
	upgradeDescription(0)="Repair 50% of your armor every wave completed"
	upgradeDescription(1)="Repair <font color=\"#b346ea\">100%</font> of your armor every wave completed"
	Armor(0)=0.500000
	Armor(1)=1.000000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AssaultArmor'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AssaultArmor_Deluxe'
}