class WMUpgrade_Skill extends WMUpgrade
	abstract;

// Last Skill unlocked from a perk upgrade will always be "Deluxe"
// Deluxe Skill upgrade should be way better than the original, but cost more
// -They will reward player who spends lot of dosh on a single perk upgrade
// -Also, player that got "bad" skill upgrade will be tempting to invest more (because the last skill could be a good one)

// IMPORTANT : upgLevel for default skill is 1. upgLevel will be equal to 2 if skill is "Deluxe"

defaultproperties
{
	upgradeCost(0)=350
	upgradeName="default"
	upgradeDescription(0)="default description"
	upgradeDescription(1)="default Deluxe description"

	Name="Default__WMUpgrade_Skill"
}
