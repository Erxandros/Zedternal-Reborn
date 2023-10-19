class WMSpecialWave_GiftFromAbove extends WMSpecialWave;

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
		KFG.ResetPickups(KFG.ItemPickups, KFG.NumWeaponPickups);
		KFG.ResetPickups(KFG.AmmoPickups, KFG.NumAmmoPickups);
	}
}

defaultproperties
{
	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_GiftFromAbove"

	Name="Default__WMSpecialWave_GiftFromAbove"
}
