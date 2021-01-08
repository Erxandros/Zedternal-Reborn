class WMUpgrade_Skill_Penetrator extends WMUpgrade_Skill;

var array<float> Penetration;

static simulated function ModifyPenetrationPassive(out float penetrationFactor, int upgLevel)
{
	penetrationFactor += default.Penetration[upgLevel - 1];
}

defaultproperties
{
	Penetration(0)=2.0f
	Penetration(1)=5.0f

	upgradeName="Penetrator"
	upgradeDescription(0)="Increase penetration power of <font color=\"#caab05\">Shotguns, Rifles and Revolvers</font> by 200%"
	upgradeDescription(1)="Increase penetration power of <font color=\"#caab05\">Shotguns, Rifles and Revolvers</font> by <font color=\"#b346ea\">500%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Penetrator_Deluxe'

	Name="Default__WMUpgrade_Skill_Penetrator"
}
