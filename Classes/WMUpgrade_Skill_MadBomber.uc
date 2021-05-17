class WMUpgrade_Skill_MadBomber extends WMUpgrade_Skill;

var array<float> Resistance;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Explosive') && InstigatedBy != None && InstigatedBy == OwnerPawn.Controller)
		InDamage -= Round(float(DefaultDamage) * default.Resistance[upgLevel - 1]);
}

static simulated function bool ShouldNeverDud(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Resistance(0)=0.3f
	Resistance(1)=0.7f

	upgradeName="Mad Bomber"
	upgradeDescription(0)="<font color=\"#caab05\">Explosive rounds</font> can explode at any range and resistance to your <font color=\"#eaeff7\">own explosives</font> increases by 30%"
	upgradeDescription(1)="<font color=\"#caab05\">Explosive rounds</font> can explode at any range and resistance to your <font color=\"#eaeff7\">own explosives</font> increases by <font color=\"#b346ea\">75%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MadBomber'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_MadBomber_Deluxe'

	Name="Default__WMUpgrade_Skill_MadBomber"
}
