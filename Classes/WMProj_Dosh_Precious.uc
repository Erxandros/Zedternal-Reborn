class WMProj_Dosh_Precious extends WMProj_Dosh
	hidedropdown;

function int GetCashAmount()
{
	return class'ZedternalReborn.WMWeap_AssaultRifle_Doshinegun_Precious'.default.DoshCost;
}

defaultproperties
{
	Damage=14
	Name="Default__WMProj_Dosh_Precious"
}
