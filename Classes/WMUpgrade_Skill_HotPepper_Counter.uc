Class WMUpgrade_Skill_HotPepper_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var array<int> Damage;
var float Radius;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if(Player == None)
		Destroy();
	else
		SetTimer(0.5f, True);
}

function Timer()
{
	local KFPawn_Monster KFM;
	local KFPlayerController KFPC;
	local int Dmg;

	if (Player != None)
	{
		KFPC = KFPlayerController(Player.Controller);
		if (KFPC != None)
		{
			foreach DynamicActors(class'KFPawn_Monster', KFM)
			{
				if (KFM.IsAliveAndWell() && VSizeSQ(Player.Location - KFM.Location) <= Radius)
				{
					if (bDeluxe)
						Dmg = default.Damage[1];
					else
						Dmg = default.Damage[0];

					KFM.ApplyDamageOverTime(Dmg, KFPC, Class'ZedternalReborn.WMDT_Napalm');
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
	Damage(0)=10
	Damage(1)=25
	Radius=25600

	Name="Default__WMUpgrade_Skill_HotPepper_Counter"
}
