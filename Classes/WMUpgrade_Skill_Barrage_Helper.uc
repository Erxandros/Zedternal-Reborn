class WMUpgrade_Skill_Barrage_Effect extends Info
	transient;

var KFPawn_Human Player;
var bool bCanCreateEffect;

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None)
		Destroy();
	else
		bCanCreateEffect = True;
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
		SetTimer(0.8f, False, nameof(ResetEffect));
	}
}

function ResetEffect()
{
	bCanCreateEffect = True;
}

defaultproperties
{
	bCanCreateEffect=True

	Name="Default__WMUpgrade_Skill_Barrage_Effect"
}
