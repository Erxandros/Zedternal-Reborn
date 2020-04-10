Class WMUpgrade_Skill_SonicResistantRounds extends WMUpgrade_Skill;
	
var array<float> Damage;

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if( class<KFDT_Sonic>(Damagetype) != none )
		InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
}

static simulated function bool ProjSirenResist(int upgLevel, KFPawn OwnerPawn)
{
	return true;
}

defaultproperties
{
	upgradeName="Sonic Resistant Rounds"
	upgradeDescription(0)="Your explosives are immunne to the Siren's screams and will always explode. Also increase resistance to sonic by 40%"
	upgradeDescription(1)="Your explosives are immunne to the Siren's screams and will always explode. Also increase resistance to sonic by <font color=\"#b346ea\">99%</font>"
	Damage(0)=0.400000;
	Damage(1)=1.000000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SonicResistantRounds_Deluxe'
}