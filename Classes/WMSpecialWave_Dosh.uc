class WMSpecialWave_Dosh extends WMSpecialWave;

var float MaxDoshVelocity;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFDroppedPickup_Cash KFDP;
	local KFInventory_Money KFIM;
	local vector Vel;
	local int i, HealthValue;

	HealthValue = KFPawn_Monster(KilledPawn).default.Health;
	for (i = 0; i <= HealthValue; i += 125)
	{
		KFDP = Spawn(class'KFGame.KFDroppedPickup_Cash', Killer, , KilledPawn.Location, , , True);
		KFIM = Spawn(class'KFGameContent.KFInventory_Money');
		if (KFDP != None && KFIM != None)
		{
			Vel.X = MaxDoshVelocity * (fRand() - 0.5f);
			Vel.Y = MaxDoshVelocity * (fRand() - 0.5f);
			Vel.Z = MaxDoshVelocity * (0.5f * fRand() + 0.5f);

			KFDP.SetPhysics(PHYS_Falling);
			KFDP.Velocity = Vel;
			KFDP.Inventory = KFIM;
			KFDP.InventoryClass = KFIM.class;
			KFDP.SetPickupMesh(KFIM.default.DroppedPickupMesh);
			KFDP.SetPickupParticles(KFIM.default.DroppedPickupParticles);
			KFDP.CashAmount = 3;
		}
	}
}

defaultproperties
{
	MaxDoshVelocity=600.0f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Dosh"

	Name="Default__WMSpecialWave_Dosh"
}
