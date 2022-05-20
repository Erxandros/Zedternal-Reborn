class WMSpecialWave_GiftFromAbove extends WMSpecialWave;

var float PickupFactor;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(15.0f, True, NameOf(UpdatePickup));
}

function UpdatePickup()
{
	local KFGameInfo KFG;

	foreach DynamicActors(class'KFGame.KFGameInfo', KFG)
	{
		KFG.ResetPickups(KFG.ItemPickups, int(float(KFG.NumWeaponPickups) * PickupFactor));
		KFG.ResetPickups(KFG.AmmoPickups, int(float(KFG.NumAmmoPickups) * PickupFactor));
	}
}

defaultproperties
{
	PickupFactor=9.0f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_GiftFromAbove"

	Name="Default__WMSpecialWave_GiftFromAbove"
}
