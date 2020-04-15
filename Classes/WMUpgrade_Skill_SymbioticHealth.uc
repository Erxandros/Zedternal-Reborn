Class WMUpgrade_Skill_SymbioticHealth extends WMUpgrade_Skill;

var array<float> Health;
var array<float> Healing;

static function ModifyHealth( out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += DefaultHealth * default.Health[upgLevel-1];
}
	
static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.Healing[upgLevel-1];
}

defaultproperties
{
	upgradeName="Symbiotic Health"
	upgradeDescription(0)="Increase total Health by 10%. Healing teammates will heal you 10% of your Health"
	upgradeDescription(1)="Increase total Health by <font color=\"#b346ea\">25%</font>. Healing teammates will heal you <font color=\"#b346ea\">25%</font> of your Health"
	Health(0)=0.100000;
	Health(1)=0.250000;
	Healing(0)=0.100000;
	Healing(1)=0.250000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_SymbioticHealth'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_SymbioticHealth_Deluxe'
}