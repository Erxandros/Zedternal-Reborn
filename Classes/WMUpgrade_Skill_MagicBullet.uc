class WMUpgrade_Skill_MagicBullet extends WMUpgrade_Skill;

var array<int> Ammo;

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	local WMUpgrade_Skill_MagicBullet_Helper UPG;

	UPG = GetHelper(KFPC.Pawn);
	if (UPG != None)
	{
		if (UPG.Player.WorldInfo.NetMode == NM_Standalone) // For single player
			UPG.StandaloneUpdateAmmo(default.Ammo[upgLevel - 1]);
		else // For servers
			UPG.ServerUpdateAmmo(default.Ammo[upgLevel - 1]);
	}
}

static function WMUpgrade_Skill_MagicBullet_Helper GetHelper(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_MagicBullet_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MagicBullet_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_MagicBullet_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_MagicBullet_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_MagicBullet_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Ammo(0)=1
	Ammo(1)=2

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_MagicBullet"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MagicBullet'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MagicBullet_Deluxe'

	Name="Default__WMUpgrade_Skill_MagicBullet"
}
