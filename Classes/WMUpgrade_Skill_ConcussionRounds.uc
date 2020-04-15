Class WMUpgrade_Skill_ConcussionRounds extends WMUpgrade_Skill;
	
var array<float> Effect;

static function ModifyStumblePowerPassive( out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.Effect[upgLevel-1];
}

static function ModifyStunPowerPassive( out float stunPowerFactor, int upgLevel)
{
	stunPowerFactor += default.Effect[upgLevel-1];
}

static function ModifyKnockdownPowerPassive( out float knockdownPowerFactor, int upgLevel)
{
	knockdownPowerFactor += default.Effect[upgLevel-1];
}

defaultproperties
{
	upgradeName="Concussion Rounds"
	upgradeDescription(0)="Increase stumble, stun and knockdown powers for <font color=\"#eaeff7\">all weapons</font> 50%"
	upgradeDescription(1)="Increase stumble, stun and knockdown powers for <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">125%</font>"
	Effect(0)=0.500000
	Effect(1)=1.250000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ConcussionRounds'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ConcussionRounds_Deluxe'
}