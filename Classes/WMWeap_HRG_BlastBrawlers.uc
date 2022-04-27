class WMWeap_HRG_BlastBrawlers extends KFWeap_HRG_BlastBrawlers;

simulated function DecrementAmmo()
{
	local KFPerk InstigatorPerk;

	InstigatorPerk = GetPerk();
	if (InstigatorPerk != None && InstigatorPerk.GetIsUberAmmoActive(self))
		return;

	super.DecrementAmmo();
}

defaultproperties
{
	Name="Default__WMWeap_HRG_BlastBrawlers"
}
