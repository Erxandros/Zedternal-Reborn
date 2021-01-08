class WMUpgrade_Skill_TightChoke extends WMUpgrade_Skill;

var array<float> Spread;

static simulated function ModifyTightChokePassive(out float tightChokeFactor, int upgLevel)
{
	tightChokeFactor -= default.Spread[upgLevel - 1];
}

defaultproperties
{
	Spread(0)=0.4f
	Spread(1)=0.7f

	upgradeName="Tight Choke"
	upgradeDescription(0)="Decrease shot spread by 40%"
	upgradeDescription(1)="Decrease shot spread by <font color=\"#b346ea\">70%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke_Deluxe'

	Name="Default__WMUpgrade_Skill_TightChoke"
}
