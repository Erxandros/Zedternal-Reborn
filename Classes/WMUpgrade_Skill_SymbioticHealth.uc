Class WMUpgrade_Skill_SymbioticHealth extends WMUpgrade_Skill;

var array<float> Health;
var array<float> Healing;

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += DefaultHealth * default.Health[upgLevel - 1];
}

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.Healing[upgLevel - 1];
}

defaultproperties
{
	Health(0)=0.1f
	Health(1)=0.25f
	Healing(0)=0.1f
	Healing(1)=0.25f

	upgradeName="Symbiotic Health"
	upgradeDescription(0)="Increase total health by 10%. Healing teammates will also heal 10% of your health"
	upgradeDescription(1)="Increase total health by <font color=\"#b346ea\">25%</font>. Healing teammates will also heal <font color=\"#b346ea\">25%</font> of your health"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SymbioticHealth'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SymbioticHealth_Deluxe'

	Name="Default__WMUpgrade_Skill_SymbioticHealth"
}
