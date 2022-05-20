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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_TightChoke"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_TightChoke_Deluxe'

	Name="Default__WMUpgrade_Skill_TightChoke"
}
