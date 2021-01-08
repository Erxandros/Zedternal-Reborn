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
	Stumble(0)=1.0f
	Stumble(1)=2.5f

	upgradeName="Impact Rounds"
	upgradeDescription(0)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> by 100%. Increase <font color=\"#eaeff7\">ballistic</font> damage by 10%"
	upgradeDescription(1)="Increase stumble power of <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">250%</font>. Increase <font color=\"#eaeff7\">ballistic</font> damage by <font color=\"#b346ea\">25%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ImpactRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ImpactRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_ImpactRounds"
}
