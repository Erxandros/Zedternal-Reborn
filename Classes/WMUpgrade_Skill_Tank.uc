Class WMUpgrade_Skill_Tank extends WMUpgrade_Skill;
	
var array<float> Resistance, Critical;
	
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local float limit;
	
	if (upgLevel>1)
		limit = default.Critical[0];
	else
		limit = default.Critical[1];
	
	if (OwnerPawn != none && OwnerPawn.Health >= int(float(OwnerPawn.HealthMax) * limit))
		InDamage -= Max(1, Round( float(DefaultDamage) * default.Resistance[upgLevel-1] ));
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tank_Effect UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tank_Effect',UPG)
			bFound = true;
		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tank_Effect',OwnerPawn);
			UPG.Player = KFPawn_Human(OwnerPawn);
			UPG.bDeluxe = (upgLevel > 1);
		}
	}
}

defaultproperties
{
	upgradeName="Tank"
	upgradeDescription(0)="Increase damage resistance 20% while your health is higher than 90%"
	upgradeDescription(1)="Increase damage resistance <font color=\"#b346ea\">30%</font> while your health is higher than 90%"
	Resistance(0)=0.200000
	Resistance(1)=0.300000
	Critical(0)=0.900000
	Critical(1)=0.700000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tank'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tank_Deluxe'
}