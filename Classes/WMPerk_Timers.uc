class WMPerk_Timers extends Info;

//Timer Precision
const TimerDuration = 0.25f;

//Flags
var bool TightChokeModifierFlag;
var bool PenetrationModifierFlag;
var bool StunPowerModifierFlag;
var bool StumblePowerModifierFlag;
var bool KnockdownPowerModifierFlag;
var bool SnarePowerModifierFlag;

//Cached variables
var float SavedTightChokeModifierValue;
var float SavedPenetrationModifierValue;
var float SavedStunPowerModifierValue;
var float SavedStumblePowerModifierValue;
var float SavedKnockdownPowerModifierValue;
var float SavedSnarePowerModifierValue;

simulated function SetTightChokeModifierTimer()
{
	TightChokeModifierFlag = True;
	if (!IsTimerActive(nameof(TightChokeModifierTimer)))
		SetTimer(TimerDuration, False, nameof(TightChokeModifierTimer));
}

simulated function TightChokeModifierTimer()
{
	TightChokeModifierFlag = False;
}

simulated function SetPenetrationModifierTimer()
{
	PenetrationModifierFlag = True;
	if (!IsTimerActive(nameof(PenetrationModifierTimer)))
		SetTimer(TimerDuration, False, nameof(PenetrationModifierTimer));
}

simulated function PenetrationModifierTimer()
{
	PenetrationModifierFlag = False;
}

function SetStunPowerModifierTimer()
{
	StunPowerModifierFlag = True;
	if (!IsTimerActive(nameof(StunPowerModifierTimer)))
		SetTimer(TimerDuration, False, nameof(StunPowerModifierTimer));
}

function StunPowerModifierTimer()
{
	StunPowerModifierFlag = False;
}

function SetStumblePowerModifierTimer()
{
	StumblePowerModifierFlag = True;
	if (!IsTimerActive(nameof(StumblePowerModifierTimer)))
		SetTimer(TimerDuration, False, nameof(StumblePowerModifierTimer));
}

function StumblePowerModifierTimer()
{
	StumblePowerModifierFlag = False;
}

function SetKnockdownPowerModifierTimer()
{
	KnockdownPowerModifierFlag = True;
	if (!IsTimerActive(nameof(KnockdownPowerModifierTimer)))
		SetTimer(TimerDuration, False, nameof(KnockdownPowerModifierTimer));
}

function KnockdownPowerModifierTimer()
{
	KnockdownPowerModifierFlag = False;
}

simulated function SetSnarePowerModifierTimer()
{
	SnarePowerModifierFlag = True;
	if (!IsTimerActive(nameof(SnarePowerModifierTimer)))
		SetTimer(TimerDuration, False, nameof(SnarePowerModifierTimer));
}

simulated function SnarePowerModifierTimer()
{
	SnarePowerModifierFlag = False;
}

defaultproperties
{
	TightChokeModifierFlag=False
	PenetrationModifierFlag=False
	StunPowerModifierFlag=False
	StumblePowerModifierFlag=False
	KnockdownPowerModifierFlag=False
	SnarePowerModifierFlag=False

	bOnlyRelevantToOwner=True

	Name="Default__WMPerk_Timers"
}
