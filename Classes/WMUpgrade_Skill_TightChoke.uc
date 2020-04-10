Class WMUpgrade_Skill_TightChoke extends WMUpgrade_Skill;
	
var array<float> Spread;

static simulated function ModifyTightChokePassive( out float tightChokeFactor, int upgLevel)
{
	tightChokeFactor -= default.Spread[upgLevel-1];
}

defaultproperties
{
	upgradeName="Tight Choke"
	upgradeDescription(0)="Decrease shot spread 40%"
	upgradeDescription(1)="Decrease shot spread <font color=\"#b346ea\">70%</font>"
	Spread(0)=0.400000;
	Spread(1)=0.700000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke_Deluxe'
}