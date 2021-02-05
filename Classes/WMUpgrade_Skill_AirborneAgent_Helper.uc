class WMUpgrade_Skill_AirborneAgent_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var int RadiusSQ, criticalHealth;
var float Recharge, Update;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		SetTimer(default.Update, False);
}

function Timer()
{
	local KFPawn_Human KFPH;
	local bool bActivate;

	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	bActivate = False;
	if (Player.Health <= criticalHealth && Player.Health > 0)
		bActivate = True;
	else
	{
		foreach DynamicActors(class'KFPawn_Human', KFPH)
		{
			if (KFPH.Health <= criticalHealth && KFPH.Health > 0 && VSizeSQ(Player.Location - KFPH.Location) <= RadiusSQ)
			{
				bActivate = True;
				break;
			}
		}
	}

	if (!bActivate)
		SetTimer(default.Update, False);
	else
	{
		Player.StartAirBorneAgentEvent();
		Spawn(class'ZedternalReborn.WMFX_AirborneAgent', , , Player.Location, Player.Rotation, , True);

		if (bDeluxe)
		{
			Player.HealDamage(35, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
			foreach DynamicActors(class'KFPawn_Human', KFPH)
			{
				if (KFPH != Player && VSizeSQ(Player.Location - KFPH.Location) <= RadiusSQ)
					KFPH.HealDamage(20, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
			}
		}
		else
			Player.HealDamage(15, Player.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');

		SetTimer(default.Recharge, False);
	}
}

defaultproperties
{
	Recharge=40.0f
	Update=0.5f
	RadiusSQ=60000
	criticalHealth=60
	bDeluxe=False

	Name="Default__WMUpgrade_Skill_AirborneAgent_Helper"
}
