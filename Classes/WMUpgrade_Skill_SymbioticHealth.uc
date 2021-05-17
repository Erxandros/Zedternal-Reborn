class WMUpgrade_Skill_SymbioticHealth extends WMUpgrade_Skill;

var array<float> Bonus;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += DefaultHealth * default.Bonus[upgLevel - 1];
}

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.Bonus[upgLevel - 1];
}

defaultproperties
{
	Bonus(0)=0.1f
	Bonus(1)=0.25f

	upgradeName="Symbiotic Health"
	upgradeDescription(0)="Increase total health by 10% and heal 10% of your health while healing teammates"
	upgradeDescription(1)="Increase total health by <font color=\"#b346ea\">25%</font> and heal <font color=\"#b346ea\">25%</font> of your health while healing teammates"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SymbioticHealth'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SymbioticHealth_Deluxe'

	Name="Default__WMUpgrade_Skill_SymbioticHealth"
}
