class WMUpgrade_Skill_MagicBullet_Helper extends Info
	transient;

var KFPawn_Human Player;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function int UpdateAmmo(int AmmoIn, KFWeapon MyKFWeapon)
{
	local int Ammo;

	// cap ammo
	Ammo = Min(AmmoIn, MyKFWeapon.MagazineCapacity[0] - MyKFWeapon.AmmoCount[0]);

	if (MyKFWeapon.MagazineCapacity[0] > 1 && Ammo > 0 && MyKFWeapon.SpareAmmoCount[0] >= Ammo)
	{
		MyKFWeapon.AmmoCount[0] += Ammo;
		MyKFWeapon.SpareAmmoCount[0] -= Ammo;
		return Ammo;
	}

	return -1; //Did not update values
}

function StandaloneUpdateAmmo(int Ammo)
{
	local KFWeapon MyKFWeapon;

	if (Player != None && Player.Health > 0)
	{
		MyKFWeapon = KFWeapon(Player.Weapon);
		if (MyKFWeapon != None)
		{
			UpdateAmmo(Ammo, MyKFWeapon);
		}
	}
	else
		Destroy();
}

function ServerUpdateAmmo(int Ammo)
{
	local KFWeapon MyKFWeapon;
	local int ClientAmmo;

	if (Player != None && Player.Health > 0)
	{
		MyKFWeapon = KFWeapon(Player.Weapon);
		if (MyKFWeapon != None)
		{
			ClientAmmo = UpdateAmmo(Ammo, MyKFWeapon);
			ClientUpdateAmmo(ClientAmmo);
		}
	}
	else
		Destroy();
}

reliable client function ClientUpdateAmmo(int Ammo)
{
	local KFWeapon MyKFWeapon;
	local PlayerController PC;

	PC = GetALocalPlayerController();

	if (PC != None && PC.Pawn != None && PC.Pawn.Health > 0)
	{
		MyKFWeapon = KFWeapon(PC.Pawn.Weapon);
		if (MyKFWeapon != None)
		{
			if (Ammo > 0)
			{
				MyKFWeapon.AmmoCount[0] = Min(MyKFWeapon.MagazineCapacity[0], MyKFWeapon.AmmoCount[0] + Ammo); // We do not want to go over capacity
				MyKFWeapon.SpareAmmoCount[0] = Max(0, MyKFWeapon.SpareAmmoCount[0] - Ammo); // We do not want negative ammo
			}
		}
	}
}

defaultproperties
{
	Name="Default__WMUpgrade_Skill_MagicBullet_Helper"
}
