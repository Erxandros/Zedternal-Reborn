Class WMUpgrade_Skill_Bombardier_Regen extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var float TimeRegen, TimeRegenDeluxe;
var KFInventoryManager KFIM;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player == none || Player.InvManager == none)
		Destroy();
	else
	{
		KFIM = KFInventoryManager(Player.InvManager);
		SetTimer(TimeRegen,false);
	}
}
function Timer()
{
	if(Player==None || Player.Health<=0 || KFIM==None)
		Destroy();
	
	KFIM.AddGrenades( 1 );

	if (bDeluxe)
		SetTimer(TimeRegenDeluxe,false);
	else
		SetTimer(TimeRegen,false);
}

defaultproperties
{
   TimeRegen=45.000000
   TimeRegenDeluxe=20.000000
   bDeluxe=false
   Name="Default__WMUpgrade_Skill_Bombardier_Regen"
}
