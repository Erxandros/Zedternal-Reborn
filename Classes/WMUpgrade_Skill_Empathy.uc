class WMUpgrade_Skill_Empathy extends WMUpgrade_Skill;

var array<float> Syringe, SelfHealing;

static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Syringe[upgLevel - 1];
}

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.SelfHealing[upgLevel - 1];
}

defaultproperties
{
	Syringe(0)=0.25f
	Syringe(1)=0.5f
	SelfHealing(0)=0.1f
	SelfHealing(1)=0.25f

	upgradeName="Empathy"
	upgradeDescription(0)="Increase medical syringe healing effectiveness by 25%. Healing teammates will heal 10% of your total health"
	upgradeDescription(1)="Increase medical syringe healing effectiveness by <font color=\"#b346ea\">50%</font>. Healing teammates will heal <font color=\"#b346ea\">25%</font> of your total health"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy_Deluxe'

	Name="Default__WMUpgrade_Skill_Empathy"
}
