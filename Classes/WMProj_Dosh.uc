class WMProj_Dosh extends KFProj_Dosh
	hidedropdown;

var bool IsUberAmmo;

simulated event PostBeginPlay()
{
	local KFWeapon KFW;
	local KFPerk KFP;

	super.PostBeginPlay();

	if (WorldInfo.NetMode == NM_Client)
		return;

	IsUberAmmo = False;

	if (KFPawn_Human(Instigator) != None)
	{
		KFW = KFWeapon(Instigator.Weapon);
		KFP = KFPawn_Human(Instigator).GetPerk();
		if (KFP != None && KFW != None && KFP.GetIsUberAmmoActive(KFW))
			IsUberAmmo = True;
	}
}

function int GetCashAmount()
{
	return class'KFWeap_AssaultRifle_Doshinegun'.default.DoshCost;
}

function SpawnDosh(Actor BouncedOff)
{
	local KFDroppedPickup_Cash P;
	local int i;
	local Vector Pos;
	local rotator Rot;

	if (WorldInfo.NetMode == NM_Client)
		return;

	if (Pawn(BouncedOff) == None)
	{
		Pos = Location;
		Rot = Rotation;
		P = Spawn(class'KFDroppedPickup_Cash', , , Pos, Rot, , False);

		if (P == None)
		{
			for (i = 0; i < 20; ++i)
			{
				Pos = PreviousLocations[i];
				Rot = PreviousRotations[i];
				P = Spawn(class'KFDroppedPickup_Cash', , , Pos, Rot, , False);
				if (P != None)
					break;
			}
		}

		if (P != None && RelocateFromCeiling(Pos))
		{
			P.Destroy();
			if (Ceiling.Z > -10000)
			{
				P = Spawn(class'KFDroppedPickup_Cash', , , Ceiling, Rot, , False);
				Velocity = vect(0,0,0);
			}
		}
	}
	else
		P = Spawn(class'KFDroppedPickup_Cash', , , Location, Rotation, , True);

	if (P == None)
		Destroy();
	else
	{
		P.SetPhysics(PHYS_Falling);
		P.InventoryClass = class'KFInventory_Money';
		P.Inventory = Instigator.CreateInventory(P.InventoryClass);
		P.Velocity = Velocity;
		P.Instigator = Instigator;
		P.LifeSpan = class'KFDroppedPickup_Cash'.default.LifeSpan;
		P.SetPickupMesh(DroppedPickupMesh);
		P.SetPickupParticles(None);

		if (IsUberAmmo)
		{
			P.CashAmount = 0;
			P.SetEmptyMaterial();
		}
		else
			P.CashAmount = GetCashAmount();
	}
}

defaultproperties
{
	Name="Default__WMProj_Dosh"
}
