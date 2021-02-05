class WMUpgrade_Skill_HotPepper_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var const float Radius, Update;
var const array<int> Damage;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		SetTimer(Update, True);
}

function Timer()
{
	local KFPawn_Monster KFM;
	local KFPlayerController KFPC;
	local int Dmg;

	if (Player != None && Player.Health > 0)
	{
		KFPC = KFPlayerController(Player.Controller);
		if (KFPC != None)
		{
			foreach DynamicActors(class'KFPawn_Monster', KFM)
			{
				if (KFM.IsAliveAndWell() && VSizeSQ(Player.Location - KFM.Location) <= Radius)
				{
					if (bDeluxe)
						Dmg = Damage[1];
					else
						Dmg = Damage[0];

					KFM.ApplyDamageOverTime(Dmg, KFPC, class'ZedternalReborn.WMDT_Napalm');
				}
			}
		}
	}
	else
		Destroy();
}

defaultproperties
{
	bDeluxe=False
	Radius=25600
	Update=0.5f
	Damage(0)=10
	Damage(1)=25

	Name="Default__WMUpgrade_Skill_HotPepper_Helper"
}
