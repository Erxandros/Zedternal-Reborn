class WMWeap_Edged_Scythe_Precious extends KFWeap_Edged_Scythe;

simulated function ChangeMode(bool IsFolded, bool bApplyBlend = True)
{
	if (MeleeAttackHelper == None)
		return;

	super.ChangeMode(IsFolded, bApplyBlend);

	if (IsFolded)
		InstantHitDamage[BASH_FIREMODE] = 54;
	else
		InstantHitDamage[BASH_FIREMODE] = 81;
}

defaultproperties
{
	FoldedDamage=95
	FoldedDamageAlt=162
	UnfoldedDamage=189
	UnfoldedDamageAlt=257
	Name="Default__WMWeap_Edged_Scythe_Precious"
}
