class WMProj_Dosh_Precious extends WMProj_Dosh;

function int GetCashAmount()
{
	return class'ZedternalReborn.WMWeap_AssaultRifle_Doshinegun_Precious'.default.DoshCost;
}

defaultproperties
{
	Damage=13
	Name="Default__WMProj_Dosh_Precious"
}
