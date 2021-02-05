class WMUpgrade_Skill_Bombardier_Helper extends Info
	transient;

var KFPawn_Human Player;
var KFInventoryManager KFIM;
var const array<float> TimeRegen;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0 || Player.InvManager == None)
		Destroy();
	else
		KFIM = KFInventoryManager(Player.InvManager);
}

function StartTimer(bool bDeluxe)
{
	if (bDeluxe)
		SetTimer(TimeRegen[1], True);
	else
		SetTimer(TimeRegen[0], True);
}

function Timer()
{
	if (Player == None || Player.Health <= 0 || KFIM == None)
		Destroy();
	else
		KFIM.AddGrenades(1);
}

defaultproperties
{
	TimeRegen(0)=45.0f
	TimeRegen(1)=20.0f

	Name="Default__WMUpgrade_Skill_Bombardier_Helper"
}
