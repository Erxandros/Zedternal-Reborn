class WMUpgrade_Skill_Destruction_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe, bReady;
var const float Update;
var const array<int> Radius;

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
	local int rad;

	if (Player == None || Player.Health <= 0)
	{
		Destroy();
		return;
	}

	if (bReady && Player.WorldInfo.TimeDilation < 1)
	{
		bReady = False;

		if (!bDeluxe)
			rad = default.Radius[0];
		else
			rad = default.Radius[1];

		foreach DynamicActors(class'KFPawn_Monster', KFM)
		{
			if (KFM.IsAliveAndWell() && VSizeSQ(Player.Location - KFM.Location) <= rad)
			{
				if (KFM.CanDoSpecialMove(SM_Knockdown))
					KFM.Knockdown(vect(0,0,0), vect(1,1,1), KFM.Location, 1000, 100);
			}
		}
	}
	else if (!bReady && Player.WorldInfo.TimeDilation >= 1)
		bReady = True;
}

defaultproperties
{
	bDeluxe=False
	bReady=True
	Update=0.25f
	Radius(0)=250000
	Radius(1)=1000000

	Name="Default__WMUpgrade_Skill_Destruction_Helper"
}
