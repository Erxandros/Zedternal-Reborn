Class WMUpgrade_Skill_AmmoPickup extends WMUpgrade_Skill;

var array< float > Ammo;

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local byte i;

	if (KFW != none)
	{
		for (i = 0; i <= 1; ++i)
		{
			KFW.AmmoPickupScale[i] = KFW.default.AmmoPickupScale[i] * default.Ammo[upgLevel - 1];
		}
	}

	if (KFWeap_Thrown_C4(KFW) != none)
		KFW.AmmoPickupScale[0] = FCeil(KFW.AmmoPickupScale[0]);
}

defaultproperties
{
	upgradeName="Extra Ammo Pickup"
	upgradeDescription(0)="Increase ammo from ammo boxes by 50%"
	upgradeDescription(1)="Increase ammo from ammo boxes by <font color=\"#b346ea\">125%</font>"
	Ammo(0)=1.500000
	Ammo(1)=2.250000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoPickup'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_AmmoPickup_Deluxe'
}
