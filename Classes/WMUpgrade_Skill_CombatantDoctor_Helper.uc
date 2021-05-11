class WMUpgrade_Skill_CombatantDoctor_Helper extends Info;

var int HealthCounter;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner == None)
		Destroy();
}

function AddHealedHealth(int InHealth)
{
	HealthCounter += InHealth;
}

function int GetAmmoMultiplier(int HealthThreshold)
{
	local int Multiplier;

	Multiplier = HealthCounter / HealthThreshold;
	HealthCounter -= HealthThreshold * Multiplier;
	return Multiplier;
}

defaultproperties
{
	HealthCounter=0

	Name="Default__WMUpgrade_Skill_CombatantDoctor_Helper"
}
