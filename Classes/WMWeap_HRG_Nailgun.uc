class WMWeap_HRG_Nailgun extends KFWeap_HRG_Nailgun;

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
	Name="Default__WMWeap_HRG_Nailgun"
}
