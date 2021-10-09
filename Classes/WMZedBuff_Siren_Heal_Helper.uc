class WMZedBuff_Siren_Heal_Helper extends Info
	transient;

var float HealRadius, HealZed, HealLargeZed;

function PostBeginPlay()
{
	SetTimer(1.0f, True);
}

function Timer()
{
	local KFTrigger_SirenProjectileShield Scream;
	local KFPawn_Monster KFPM;

	foreach DynamicActors(class'KFTrigger_SirenProjectileShield', Scream)
	{
		// Rally nearby zeds
		foreach WorldInfo.GRI.VisibleCollidingActors(class'KFPawn_Monster', KFPM, HealRadius, Scream.Location)
		{
			if (KFPM.Health < KFPM.HealthMax)
			{
				KFPM.PlayHeal(class'KFDT_Healing');
				if (KFPM.bLargeZed)
					KFPM.Health = Min(KFPM.HealthMax, Round(KFPM.Health + KFPM.HealthMax * default.HealLargeZed));
				else
					KFPM.Health = Min(KFPM.HealthMax, Round(KFPM.Health + KFPM.HealthMax * default.HealZed));
			}
		}
	}
}

defaultproperties
{
	HealRadius=600.0f
	HealZed=0.3f
	HealLargeZed=0.15f

	Name="Default__WMZedBuff_Siren_Heal_Helper"
}
