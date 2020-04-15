Class WMUpgrade_Skill_AirborneAgent_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var int RadiusSQ, criticalHealth;
var float Recharge, Update;

simulated function PostBeginPlay()
{
	SetTimer(default.Update, false);
	super.PostBeginPlay();
}

function Timer()
{
	local KFPawn_Human H;
	local bool bActivate;
	
	if (Player == none || Player.Health<=0)
		Destroy();
	
	bActivate = false;
	if (Player != none)
	{
		if (Player.Health <= criticalHealth && Player.Health > 0 )
			bActivate = true;
		else
		{
			foreach DynamicActors(class'KFPawn_Human', H)
			{
				if (H.Health <= criticalHealth && H.Health > 0 && VSizeSQ( Player.Location - H.Location ) <= RadiusSQ)
					bActivate = true;
			}
		}
	}
	
	if (!bActivate)
		SetTimer(default.Update, false);
	else
	{
		Player.StartAirBorneAgentEvent();
		Spawn(class'Zedternal.WMFX_AirborneAgent',,, Player.Location, Player.Rotation,,true);
		
		if (bDeluxe)
		{
			Player.HealDamage(35, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
			foreach DynamicActors(class'KFPawn_Human', H)
			{
				if (H != Player && VSizeSQ( Player.Location - H.Location ) <= RadiusSQ)
					H.HealDamage(20, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
			}
		}
		else
			Player.HealDamage(15, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
		SetTimer(default.Recharge);
	}
}

defaultproperties
{
   Recharge = 40.000000
   Update = 0.500000
   RadiusSQ = 60000
   criticalHealth = 60
   bDeluxe = false;
   Name="Default__WMUpgrade_Skill_AirborneAgent_Counter"
}
