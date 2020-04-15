Class WMUpgrade_Skill_HotPepper_Counter extends Info
	transient;

var KFPawn_Human Player;
var float pyromaniacLength, Delay;
var float radius;
var array<int> damage;
var bool bDeluxe;


function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	SetTimer(0.5f, true);
}

function Timer()
{
	local KFPawn_Monster KFM;
	local KFPlayerController KFPC;
	local int dmg;
	
	if (Player != none)
	{
		KFPC = KFPlayerController(Player.Controller);
		if (KFPC != none)
		{
			foreach DynamicActors(class'KFPawn_Monster', KFM)
			{
				if ( KFM.IsAliveAndWell() && VSizeSQ( Player.Location - KFM.Location ) <= Radius )
				{
					if (bDeluxe)
						dmg = default.damage[1];
					else
						dmg = default.damage[0];
					KFM.ApplyDamageOverTime(dmg, KFPC, Class'Zedternal.WMUpgrade_Napalm_DT');
				}
			}
		}
	}
	else
	{
		Destroy();
	}
}


defaultproperties
{
   damage(0)=10;
   damage(1)=25;
   radius=25600;
   bDeluxe=false
   Name="Default__WMUpgrade_Skill_HotPepper_Counter"
}
