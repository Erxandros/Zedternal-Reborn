Class WMUpgrade_Skill_Penetrator extends WMUpgrade_Skill;
	
var array<float> Penetration;

static simulated function ModifyPenetrationPassive( out float penetrationFactor, int upgLevel)
{
	penetrationFactor += default.Penetration[upgLevel-1];
}

defaultproperties
{
	upgradeName="Penetrator"
	upgradeDescription(0)="Increase penetration power of <font color=\"#caab05\">Shotguns, Rifles and Revolvers</font> 200%"
	upgradeDescription(1)="Increase penetration power of <font color=\"#caab05\">Shotguns, Rifles and Revolvers</font> <font color=\"#b346ea\">500%</font>"
	Penetration(0)=2.000000;
	Penetration(1)=5.000000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator_Deluxe'
}