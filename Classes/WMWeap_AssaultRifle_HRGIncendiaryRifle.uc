class WMWeap_AssaultRifle_HRGIncendiaryRifle extends KFWeap_AssaultRifle_HRGIncendiaryRifle;

var transient bool bManualAltReload;

simulated function BeginFire(Byte FireModeNum)
{
	bManualAltReload = true;
	super.BeginFire(FireModeNum);
	bManualAltReload = false;
}

simulated function SendToAltReload()
{
	local int Amount;

	Amount = Min(Max(0, MagazineCapacity[1] - AmmoCount[1]), MagazineCapacity[1]);
	ReloadAmountLeft = Amount;
	GotoState('AltReloading');
	if (Role < ROLE_Authority)
		ServerSendToAltReloadAmount(Amount);
}

reliable server function ServerSendToAltReloadAmount(int Amount)
{
	ReloadAmountLeft = Amount;
	GotoState('AltReloading');
}

simulated function bool CanAltAutoReload()
{
	if (Instigator.IsLocallyControlled() && !bManualAltReload && AmmoCount[1] != 0)
		return false;

	return super.CanAltAutoReload();
}

defaultproperties
{
	Name="Default__WMWeap_AssaultRifle_HRGIncendiaryRifle"
}
