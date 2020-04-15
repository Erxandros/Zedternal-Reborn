Class WMUpgrade_Skill_TacticalMovement extends WMUpgrade_Skill;
	
var array<float> Speed;
var float moveSpeed;
	
static simulated function GetIronSightSpeedModifier(out float InSpeed, float DefaultSpeed, int upgLevel)
{
	InSpeed += DefaultSpeed * default.Speed[upgLevel-1];
}

static simulated function ModifySpeedPassive( out float speedFactor, int upgLevel)
{
	if (upgLevel > 1)
		speedFactor += default.moveSpeed;
}


defaultproperties
{
	upgradeName="Tactical Movement"
	upgradeDescription(0)="Ignore movement speed penalty for iron sights with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="<font color=\"#b346ea\">Gain</font> movement speed bonus for iron sights with <font color=\"#eaeff7\">all weapons</font>. Also increase movement speed by <font color=\"#b346ea\">5%</font>"
	Speed(0)=1.000000
	Speed(1)=1.150000
	moveSpeed=0.050000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalMovement'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_TacticalMovement_Deluxe'
}