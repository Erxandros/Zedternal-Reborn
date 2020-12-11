Class WMUpgrade_Skill_SonicResistantRounds extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Sonic'))
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static simulated function bool ProjSirenResist(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Damage(0)=0.4f
	Damage(1)=1.0f

	upgradeName="Sonic Resistant Rounds"
	upgradeDescription(0)="Your explosives are immune to the Siren's screams and will always explode. Also increase resistance to sonic damage by 40%"
	upgradeDescription(1)="Your explosives are immune to the Siren's screams and will always explode. Also increase resistance to sonic damage by <font color=\"#b346ea\">100%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_SonicResistantRounds"
}
