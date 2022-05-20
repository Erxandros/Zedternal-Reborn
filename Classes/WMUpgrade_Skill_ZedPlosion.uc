class WMUpgrade_Skill_ZedPlosion extends WMUpgrade_Skill;

var array<float> Chance;

static function bool CouldBeZedShrapnel(int upgLevel, class<KFDamageType> KFDT)
{
	return True;
}

static function bool ShouldShrapnel(int upgLevel)
{
	return fRand() <= default.Chance[upgLevel - 1];
}

defaultproperties
{
	Chance(0)=0.2f
	Chance(1)=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_ZedPlosion"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ZedPlosion'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ZedPlosion_Deluxe'

	Name="Default__WMUpgrade_Skill_ZedPlosion"
}
