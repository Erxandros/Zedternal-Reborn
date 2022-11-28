Class WMDmgInd extends Info;

struct FPairedUser
{
	var Controller User;
	var WMDmgRep Rep;
};
var transient array<FPairedUser> Users;
var transient FPairedUser CacheUser;

var transient Pawn LastHitPawn;
var transient int LastHitHP;
var transient vector LastDamagePosition;
var transient PlayerController LastDamageInstigator;

function NotifyLogout(Controller Exiting)
{
	local int i;

	if (PlayerController(Exiting) != None)
	{
		i = Users.Find('User', Exiting);
		if (i >= 0)
		{
			Users[i].Rep.Destroy();
			Users.Remove(i, 1);
		}
	}
}

function NotifyLogin(Controller NewPlayer)
{
	local int i;

	if (PlayerController(NewPlayer) != None && PlayerController(NewPlayer).Player != None)
	{
		i = Users.Length;
		Users.Length = i + 1;
		Users[i].User = NewPlayer;
		Users[i].Rep = Spawn(class'ZedternalReborn.WMDmgRep', NewPlayer);
	}
}

function CleanupUsers()
{
	local int i;

	for (i = 0; i < Users.Length; ++i)
	{
		if (Users[i].Rep != None)
			Users[i].Rep.Destroy();
	}

	Users.Length = 0;
}

function NetDamage(Pawn Injured, Controller InstigatedBy, vector HitLocation)
{
	if (LastDamageInstigator != None)
	{
		ClearTimer('CheckDamageDone');
		CheckDamageDone();
	}

	if (PlayerController(InstigatedBy) != None && Injured != None && InstigatedBy.Pawn != Injured && Injured.Health > 0)
	{
		// Must delay this until next to get accurate damage dealt result.
		LastHitPawn = Injured;
		LastHitHP = Injured.Health;
		LastDamagePosition = HitLocation;
		LastDamageInstigator = PlayerController(InstigatedBy);
		SetTimer(0.001, false, 'CheckDamageDone');
	}
}

function CheckDamageDone()
{
	local int i;

	if (LastDamageInstigator != None)
	{
		if (CacheUser.User != LastDamageInstigator)
		{
			CacheUser.User = LastDamageInstigator;
			i = Users.Find('User', LastDamageInstigator);
			if (i >= 0)
				CacheUser.Rep = Users[i].Rep;
			else
				CacheUser.Rep = None;
		}
		if (CacheUser.Rep != None)
		{
			if (LastHitPawn != None)
				i = LastHitHP - Max(LastHitPawn.Health, 0);
			else
				i = LastHitHP;

			CacheUser.Rep.ClientPopupMessage(i, LastDamagePosition);
		}

		LastDamageInstigator = None;
	}
}

defaultproperties
{
	Name="Default__WMDmgInd"
}
