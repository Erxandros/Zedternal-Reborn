class WMUpgrade_Skill_Bombardier_Regen extends Info
	transient;

var KFPawn_Human Player;
var bool bDeluxe;
var float TimeRegen, TimeRegenDeluxe;
var KFInventoryManager KFIM;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.InvManager == None)
		Destroy();
	else
	{
		KFIM = KFInventoryManager(Player.InvManager);
		SetTimer(TimeRegen, False);
	}
}

function Timer()
{
	if (Player == None || Player.Health <= 0 || KFIM == None)
	{
		Destroy();
		return;
	}

	KFIM.AddGrenades(1);

	if (bDeluxe)
		SetTimer(TimeRegenDeluxe, False);
	else
		SetTimer(TimeRegen, False);
}

defaultproperties
{
	TimeRegen=45.0f
	TimeRegenDeluxe=20.0f
	bDeluxe=False

	Name="Default__WMUpgrade_Skill_Bombardier_Regen"
}
