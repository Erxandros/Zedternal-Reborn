class WMSpecialWave_GiftFromAbove extends WMSpecialWave;

var float PickupFactor;

function PostBeginPlay()
{
	SetTimer(15.f,true,nameof(UpdatePickup));
	super.PostBeginPlay();
}

function UpdatePickup()
{
	local KFGameInfo KFG;
	
	foreach DynamicActors(class'KFGame.KFGameInfo', KFG)
	{
		KFG.ResetPickups( KFG.ItemPickups, int(float(KFG.NumWeaponPickups) * PickupFactor) );
		KFG.ResetPickups( KFG.AmmoPickups, int(float(KFG.NumAmmoPickups) * PickupFactor) );
	}
}


defaultproperties
{
   Title="Gift From Above"
   Description="More gifts spawn during the wave!"
   
   PickupFactor=9.000000
   
   Name="Default__WMSpecialWave_GiftFromAbove"
}