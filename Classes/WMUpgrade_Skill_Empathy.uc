Class WMUpgrade_Skill_Empathy extends WMUpgrade_Skill;
	
var array<float> Syringe, selfHealing;
	
static function ModifyHealAmount( out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Syringe[upgLevel-1];
}

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel)
{
	InHealingPct += default.selfHealing[upgLevel-1];
}

defaultproperties
{
	upgradeName="Empathy"
	upgradeDescription(0)="Increase Health restored by syringe by 25%. Healing teammates will heal you 10% of your total Health"
	upgradeDescription(1)="Increase Health restored by syringe by <font color=\"#b346ea\">50%</font>. Healing teammates will heal you <font color=\"#b346ea\">25%</font> of your total Health"
	Syringe(0)=0.250000;
	Syringe(1)=0.500000;
	selfHealing(0)=0.100000;
	selfHealing(1)=0.250000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Empathy_Deluxe'
}