class WMProj_Dosh_Precious extends KFProj_Dosh
	hidedropdown;

function SpawnDosh(Actor BouncedOff)
{
	local KFDroppedPickup_Cash P;
	local int i;

	if (WorldInfo.NetMode == NM_Client)
		return;

	if (Pawn(BouncedOff) == None)
	{
		P = Spawn(class'KFDroppedPickup_Cash', , , Location, Rotation, , False);

		if (P == None)
		{
			for (i = 0; i < 20; ++i)
			{
				P = Spawn(class'KFDroppedPickup_Cash', , , PreviousLocations[i], PreviousRotations[i], , False);
				if (P != None)
					break;
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
		P.SetPickupMesh(DroppedPickupMesh);
		P.SetPickupParticles(None);
		P.CashAmount = class'ZedternalReborn.WMWeap_AssaultRifle_Doshinegun_Precious'.default.DoshCost;
	}
}

defaultproperties
{
	Name="Default__WMProj_Dosh_Precious"
}
