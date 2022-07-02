class WMWeaponAmmoFix extends Actor;
//This class fixes the issue with the functions ClientForceAmmoUpdate and ServerSendToReload
//within KFWeapon where the main input parameter is a byte and not an int, so the byte sometimes overflows and syncs bad data between the client and server

//Timer Precision
const InitDuration = 0.625f;
const TimerDuration = 0.1f;

//Vars
var KFWeapon KFW;
var int FailCount;

//Client Vars
var bool bInactiveState;
var int AmmoCountPrimary;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(InitDuration, False, NameOf(InitTimer));
}

simulated function InitTimer()
{
	KFW = KFWeapon(Owner);
	if (KFW == None || KFW.Owner == None)
	{
		FailCount++;
		if (FailCount >= 4)
			Destroy();
		else
			SetTimer(InitDuration, False, NameOf(InitTimer));
	}
	else
	{
		AmmoCountPrimary = KFW.AmmoCount[0];

		if (Role == Role_Authority)
			SetTimer(TimerDuration, True, NameOf(ServerTimer));
		else
			SetTimer(TimerDuration, True, NameOf(ClientTimer));
	}
}

reliable server function AmmoSync(int ClientAmmoCount)
{
	if (KFW != None)
		KFW.AmmoCount[0] = ClientAmmoCount;
}

function ServerTimer()
{
	if (KFW == None || KFW.Owner == None)
		Destroy();
}

simulated function ClientTimer()
{
	local name StateName;

	if (KFW == None || KFW.Owner == None)
	{
		Destroy();
		return;
	}

	StateName = KFW.GetStateName();
	if (StateName == 'Inactive')
	{
		if (!bInactiveState)
		{
			bInactiveState = True;
			AmmoSync(AmmoCountPrimary);
		}
	}
	else
		bInactiveState = False;

	if (AmmoCountPrimary < KFW.AmmoCount[0] && StateName == 'Reloading')
		AmmoSync(KFW.AmmoCount[0]);

	if ((AmmoCountPrimary - KFW.AmmoCount[0]) < 250)
		AmmoCountPrimary = KFW.AmmoCount[0];
	else
	{
		KFW.AmmoCount[0] = AmmoCountPrimary;
		if (Pawn(KFW.Owner) != None)
			KFW.NotifyHUDofWeapon(Pawn(KFW.Owner));
	}
}

defaultproperties
{
	bAlwaysRelevant=True
	bHidden=True
	bOnlyRelevantToOwner=True

	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=1
	NetPriority=5.0f

	Name="Default__WMWeaponAmmoFix"
}
