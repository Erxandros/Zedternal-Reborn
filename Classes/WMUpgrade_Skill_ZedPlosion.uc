Class WMUpgrade_Skill_ZedPlosion extends WMUpgrade_Skill;
	
var array<float> Chance;

static function bool CouldBeZedShrapnel( int upgLevel, class<KFDamageType> KFDT )
{
	return true;
}

static function bool ShouldShrapnel( int upgLevel)
{
	return fRand() <= default.Chance[upgLevel-1];
}

defaultproperties
{
	upgradeName="Zed-plosion"
	upgradeDescription(0)="Zeds you kill have a 20% chance to explode, damaging and knocking down nearby ZEDs"
	upgradeDescription(1)="Zeds you kill have a <font color=\"#b346ea\">50%</font> chance to explode, damaging and knocking down nearby ZEDs"
	Chance(0)=0.200000
	Chance(1)=0.500000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ZedPlosion'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ZedPlosion_Deluxe'
}