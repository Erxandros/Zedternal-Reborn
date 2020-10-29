class WMPerk_Timers extends Actor;

//Timer Precision
const TimerDuration = 0.25f;

//Flags
var bool TightChokeModifierFlag;
var bool PenetrationModifierFlag;
var bool StunPowerModifierFlag;
var bool StumblePowerModifierFlag;
var bool KnockdownPowerModifierFlag;

//Cached variables
var float SavedTightChokeModifierValue;
var float SavedPenetrationModifierValue;
var float SavedStunPowerModifierValue;
var float SavedStumblePowerModifierValue;
var float SavedKnockdownPowerModifierValue;

simulated function SetTightChokeModifierTimer()
{
	TightChokeModifierFlag = True;
	if (!IsTimerActive('TightChokeModifierTimer'))
		SetTimer(TimerDuration, False, 'TightChokeModifierTimer');
}

simulated function TightChokeModifierTimer()
{
	TightChokeModifierFlag = False;
}

simulated function SetPenetrationModifierTimer()
{
	PenetrationModifierFlag = True;
	if (!IsTimerActive('PenetrationModifierTimer'))
		SetTimer(TimerDuration, False, 'PenetrationModifierTimer');
}

simulated function PenetrationModifierTimer()
{
	PenetrationModifierFlag = False;
}

function SetStunPowerModifierTimer()
{
	StunPowerModifierFlag = True;
	if (!IsTimerActive('StunPowerModifierTimer'))
		SetTimer(TimerDuration, False, 'StunPowerModifierTimer');
}

function StunPowerModifierTimer()
{
	StunPowerModifierFlag = False;
}

function SetStumblePowerModifierTimer()
{
	StumblePowerModifierFlag = True;
	if (!IsTimerActive('StumblePowerModifierTimer'))
		SetTimer(TimerDuration, False, 'StumblePowerModifierTimer');
}

function StumblePowerModifierTimer()
{
	StumblePowerModifierFlag = False;
}

function SetKnockdownPowerModifierTimer()
{
	KnockdownPowerModifierFlag = True;
	if (!IsTimerActive('KnockdownPowerModifierTimer'))
		SetTimer(TimerDuration, False, 'KnockdownPowerModifierTimer');
}

function KnockdownPowerModifierTimer()
{
	KnockdownPowerModifierFlag = False;
}

defaultproperties
{
	TightChokeModifierFlag=False
	PenetrationModifierFlag=False
	StunPowerModifierFlag=False
	StumblePowerModifierFlag=False
	KnockdownPowerModifierFlag=False

	bOnlyRelevantToOwner=True

	Name="Default__WMPerk_Timers"
}
