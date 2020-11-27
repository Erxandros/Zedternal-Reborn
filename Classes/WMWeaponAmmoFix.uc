class WMWeaponAmmoFix extends Actor;
//This class fixes the issue with the functions ClientForceAmmoUpdate and ClientForceSecondaryAmmoUpdate
//within KFWeapon where the main input parameter is a byte and not an int, so the byte sometimes overflows and syncs bad data with the client

//Timer Precision
const InitDuration = 0.5f;
const TimerDuration = 0.1f;

//Ammo Precision
const AmmoPrecision = 3;

//Vars
var KFWeapon KFW;
var int AmmoCountPrimary, AmmoCountSecondary;
var byte Counter;
var bool bShouldRefreshGUI;

function PostBeginPlay()
{
	super.PostBeginPlay();

	KFW = KFWeapon(Owner);
	if (KFW == None || KFW.Owner == None)
		Destroy();
	else
		SetTimer(InitDuration, False, nameof(InitTimer));
}

function InitTimer()
{
	if (KFW == None || KFW.Owner == None)
		Destroy();
	else
	{
		AmmoCountPrimary = KFW.AmmoCount[0];
		AmmoCountSecondary = KFW.AmmoCount[1];

		SetTimer(TimerDuration, True);
	}
}

function Timer()
{
	if (KFW == None)
	{
		Destroy();
		return;
	}

	if (AmmoCountPrimary - KFW.AmmoCount[0] < 256 - AmmoPrecision)
		AmmoCountPrimary = KFW.AmmoCount[0];
	else
	{
		KFW.AmmoCount[0] = AmmoCountPrimary;
		bShouldRefreshGUI = True;
	}

	if (AmmoCountSecondary - KFW.AmmoCount[1] < 256 - AmmoPrecision)
		AmmoCountSecondary = KFW.AmmoCount[1];
	else
	{
		KFW.AmmoCount[1] = AmmoCountSecondary;
		bShouldRefreshGUI = True;
	}

	if (bShouldRefreshGUI)
	{
		if (KFW.Owner != None)
			KFW.NotifyHUDofWeapon(Pawn(KFW.Owner));
		bShouldRefreshGUI = False;
	}

	if (KFW.Owner == None)
	{
		++Counter;
		if (Counter > 3)
			Destroy();
	}
}

defaultproperties
{
	bShouldRefreshGUI=False
	Counter=0
	bOnlyRelevantToOwner=True

	Name="Default__WMWeaponAmmoFix"
}
