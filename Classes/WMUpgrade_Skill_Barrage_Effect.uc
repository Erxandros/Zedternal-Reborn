Class WMUpgrade_Skill_Barrage_Effect extends Info
	transient;

var KFPawn_Human Player;
var bool bCanCreateEffect;

function PostBeginPlay()
{
	Player = KFPawn_Human(Owner);
	if(Player==none)
		Destroy();
	else
		bCanCreateEffect = true;
}

function CreateEffect()
{
	local vector Loc;
	
	if (bCanCreateEffect)
	{
		Loc = Player.Location;
		Loc.Z -= Player.GetCollisionHeight() - 1;
		Spawn(class'ZedternalReborn.WMFX_Barrage',,, Loc, Player.Rotation,,true);
		bCanCreateEffect = false;
		SetTimer(0.8f, false, nameof(ResetEffect));
	}
}

function ResetEffect()
{
	bCanCreateEffect = true;
}

defaultproperties
{
   bCanCreateEffect=true
   Name="Default__WMUpgrade_Skill_Barrage_Effect"
}
