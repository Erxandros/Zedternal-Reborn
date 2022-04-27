class WMWeap_Shotgun_Nailgun extends KFWeap_Shotgun_Nailgun;

simulated function ConsumeAmmo(byte FireModeNum)
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != None && InstigatorPerk.GetIsUberAmmoActive(self))
		return;

	super.ConsumeAmmo(FireModeNum);
}

simulated function byte GetNumProjectilesToFire(byte FireModeNum)
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != None && InstigatorPerk.GetIsUberAmmoActive(self))
		return NumPellets[CurrentFireMode];

	return super.GetNumProjectilesToFire(FireModeNum);
}

defaultproperties
{
	Name="Default__WMWeap_Shotgun_Nailgun"
}
