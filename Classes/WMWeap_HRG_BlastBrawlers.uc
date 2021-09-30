class WMWeap_HRG_BlastBrawlers extends KFWeap_HRG_BlastBrawlers;

simulated function DecrementAmmo()
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if (InstigatorPerk == None || !InstigatorPerk.GetIsUberAmmoActive(self))
		AmmoCount[DEFAULT_FIREMODE] = Max(AmmoCount[DEFAULT_FIREMODE] - 1, 0);
}

defaultproperties
{
	Name="Default__WMWeap_HRG_BlastBrawlers"
}
