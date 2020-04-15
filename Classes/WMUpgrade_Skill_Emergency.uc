Class WMUpgrade_Skill_Emergency extends WMUpgrade_Skill;

var int minHealth;
var float minHealthInv;
var array<float> maxSpeed;

static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	if (OwnerPawn.Health < default.minHealth)
		InSpeed += DefaultSpeed * default.maxSpeed[upgLevel-1] * float(default.minHealth - OwnerPawn.Health) * default.minHealthInv;
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_TOOLS_SpeedUpdateHelper UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_TOOLS_SpeedUpdateHelper',UPG)
			bFound = true;
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_TOOLS_SpeedUpdateHelper',OwnerPawn);
	}
}

defaultproperties
{
	upgradeName="Emergency"
	upgradeDescription(0)="Increase movement speed up to 30% when your health is low"
	upgradeDescription(1)="Increase movement speed up to <font color=\"#b346ea\">75%</font> when your health is low"
	minHealth = 50
	minHealthInv = 0.020000
	maxSpeed(0) = 0.300000
	maxSpeed(1) = 0.750000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Emergency'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Emergency_Deluxe'
}