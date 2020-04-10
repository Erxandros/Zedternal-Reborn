Class WMUpgrade_Skill_MagicBullet extends WMUpgrade_Skill;

var array<int> Ammo;

static simulated function WMUpgrade_Skill_MagicBullet_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_MagicBullet_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MagicBullet_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_MagicBullet_Counter',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	return UPG;
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	local WMUpgrade_Skill_MagicBullet_Counter WMUP;
	
	WMUP = GetCounter(KFPawn(KFPC.Pawn));
	WMUP.ClientKilledZed(default.Ammo[upgLevel-1]);
}

defaultproperties
{
	upgradeName="Magic Bullet"
	upgradeDescription(0)="Killing a ZED adds 1 round into your current clip"
	upgradeDescription(1)="Killing a ZED adds <font color=\"#b346ea\">2</font> rounds into your current clip"
	Ammo(0)=1
	Ammo(1)=2
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MagicBullet'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MagicBullet_Deluxe'
}