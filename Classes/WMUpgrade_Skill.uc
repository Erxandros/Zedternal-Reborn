class WMUpgrade_Skill extends WMUpgrade
	abstract;

// IMPORTANT : upgLevel for default skill is 1. upgLevel will be equal to 2 if skill is "Deluxe"

defaultproperties
{
	upgradeCost(0)=350
	upgradeName="default"
	upgradeDescription(0)="default description"
	upgradeDescription(1)="default Deluxe description"

	Name="Default__WMUpgrade_Skill"
}
