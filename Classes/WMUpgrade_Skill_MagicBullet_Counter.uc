Class WMUpgrade_Skill_MagicBullet_Counter extends Info
	transient;

var KFPawn_Human Player;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none || Player.Health <= 0)
		Destroy();
}

reliable client function ClientKilledZed(int Ammo)
{
	local KFWeapon MyKFWeapon;

	if (Player != none && Player.Health > 0)
	{
		MyKFWeapon = KFWeapon(Player.Weapon);
		if (MyKFWeapon != none)
		{
			// cap ammo
			Ammo = Min(Ammo, MyKFWeapon.MagazineCapacity[0] - MyKFWeapon.AmmoCount[0]);
			
			if (MyKFWeapon.MagazineCapacity[0] > 1 && Ammo > 0 && MyKFWeapon.AmmoCount[0] != 0 && MyKFWeapon.SpareAmmoCount[0] >= Ammo)
			{
				MyKFWeapon.AmmoCount[0] += Ammo;
				MyKFWeapon.SpareAmmoCount[0] -= Ammo;
				
				// Update server
				if (Player.WorldInfo.NetMode == NM_DedicatedServer)
					ServerUpdateSpareAmmo(Ammo);
			}
		}
	}
	else
		Destroy();
}

reliable server function ServerUpdateSpareAmmo(int Ammo)
{
	local KFWeapon MyKFWeapon;
	
	if (Player != none && Player.Health > 0)
	{
		MyKFWeapon = KFWeapon(Player.Weapon);
		if (MyKFWeapon != none)
			MyKFWeapon.SpareAmmoCount[0] = Max(0, MyKFWeapon.SpareAmmoCount[0]-Ammo);
	}
	else
		Destroy();
}


defaultproperties
{
   Name="Default__WMUpgrade_Skill_MagicBullet_Counter"
}
