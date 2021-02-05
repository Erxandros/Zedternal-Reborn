class WMUpgrade_Skill_Barrage_Helper extends Info
	transient;

var KFPawn_Human Player;
var bool bCanCreateEffect;
var const float ResetDelay;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function CreateEffect()
{
	local vector Loc;

	if (bCanCreateEffect)
	{
		Loc = Player.Location;
		Loc.Z -= Player.GetCollisionHeight() - 1;
		Spawn(class'ZedternalReborn.WMFX_Barrage', , , Loc, Player.Rotation, , True);
		bCanCreateEffect = False;
		SetTimer(ResetDelay, False, NameOf(ResetEffect));
	}
}

function ResetEffect()
{
	if (Player == None || Player.Health <= 0)
		Destroy();
	else
		bCanCreateEffect = True;
}

defaultproperties
{
	bCanCreateEffect=True
	ResetDelay=0.8f

	Name="Default__WMUpgrade_Skill_Barrage_Helper"
}
