Class WMUpgrade_Skill_Destruction_Counter extends Info
	transient;

var KFPawn_Human Player;
var bool bReady;
var bool bDeluxe;
var array< int > Radius;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	SetTimer(0.2f, true);
}

function Timer()
{
	local KFPawn_Monster KFM;
	local int rad;
	
	if (Player == none)
	{
		Destroy();
	}
	
	if (bReady && Player.WorldInfo.TimeDilation < 1)
	{
		if (!bDeluxe)
			rad = default.Radius[0];
		else
			rad = default.Radius[1];
		
		foreach DynamicActors(class'KFPawn_Monster', KFM)
		{
			if ( KFM.IsAliveAndWell() && VSizeSQ( Player.Location - KFM.Location ) <= rad )
			{
				if(KFM.CanDoSpecialMove( SM_Knockdown ))
	 				KFM.Knockdown( vect(0,0,0), vect(1,1,1), KFM.Location, 1000, 100 );
			}
		}
		bReady = false;
	}
	else if (!bReady && Player.WorldInfo.TimeDilation >= 1)
		bReady = true;
}

defaultproperties
{
   bReady=true
   bDeluxe=false
   Radius(0)=250000
   Radius(1)=1000000
   Name="Default__WMUpgrade_Skill_Destruction_Counter"
}
