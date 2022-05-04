class WMUpgrade_Skill_ImpactRounds extends WMUpgrade_Skill;

var array<float> Damage, Stumble;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Ballistic'))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static function ModifyStumblePowerPassive(out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.Stumble[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=0.1f
	Damage(1)=0.25f
	Stumble(0)=0.2f
	Stumble(1)=0.5f

	UpgradeName="Impact Rounds"
	UpgradeDescription(0)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> by 20% and increase <font color=\"#caab05\">ballistic</font> damage by 10%"
	UpgradeDescription(1)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">50%</font> and increase <font color=\"#caab05\">ballistic</font> damage by <font color=\"#b346ea\">25%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ImpactRounds'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ImpactRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_ImpactRounds"
}
