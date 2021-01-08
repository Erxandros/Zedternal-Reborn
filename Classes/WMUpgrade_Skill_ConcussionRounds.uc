class WMUpgrade_Skill_ConcussionRounds extends WMUpgrade_Skill;

var array<float> Effect;

static function ModifyStumblePowerPassive(out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.Effect[upgLevel - 1];
}

static function ModifyStunPowerPassive(out float stunPowerFactor, int upgLevel)
{
	stunPowerFactor += default.Effect[upgLevel - 1];
}

static function ModifyKnockdownPowerPassive(out float knockdownPowerFactor, int upgLevel)
{
	knockdownPowerFactor += default.Effect[upgLevel - 1];
}

defaultproperties
{
	Effect(0)=0.5f
	Effect(1)=1.25f

	upgradeName="Concussion Rounds"
	upgradeDescription(0)="Increase stumble, stun and knockdown powers for <font color=\"#eaeff7\">all weapons</font> by 50%"
	upgradeDescription(1)="Increase stumble, stun and knockdown powers for <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">125%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ConcussionRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ConcussionRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_ConcussionRounds"
}
