class WMSpecialWave_Dosh extends WMSpecialWave;

var float MaxDoshVelocity;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local KFDroppedPickup_Cash KFDP;
	local vector Vel;
	local int i, HealthValue;
	
	HealthValue = KFPawn_Monster(KilledPawn).default.Health;
	for (i=0;i<=HealthValue;i+=125)
	{
		KFDP = Spawn(Class'KFGame.KFDroppedPickup_Cash',Killer,, KilledPawn.Location,,,true);
		KFDP.SetPhysics(PHYS_Falling);
		Vel.X = MaxDoshVelocity*(fRand()-0.500000);
		Vel.Y = MaxDoshVelocity*(fRand()-0.500000);
		Vel.Z = MaxDoshVelocity*(0.500000*fRand()+0.500000);
		KFDP.Velocity = Vel;
		KFDP.Inventory = none;
		KFDP.InventoryClass = class'KFGameContent.KFInventory_Money';
		KFDP.SetPickupMesh(class'KFGameContent.KFInventory_Money'.default.DroppedPickupMesh);
		KFDP.SetPickupParticles(class'KFGameContent.KFInventory_Money'.default.DroppedPickupParticles);
		KFDP.CashAmount = 2;
	}
}

defaultproperties
{
   Title="Dosh"
   Description="It's raining Dosh!"
   MaxDoshVelocity=600.000000
   Name="Default__WMSpecialWave_Dosh"
}