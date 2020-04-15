class WMUpgrade_Napalm_DT extends KFDT_Fire
	abstract;

static function int GetKillerDialogID()
{
	return 86;//KILL_Fire
}

static function int GetDamagerDialogID()
{
	return 102;//DAMZ_Fire
}

static function int GetDamageeDialogID()
{
	return 116;//DAMP_Fire
}

defaultproperties
{
   DoT_DamageScale=2.500000
   DoT_Duration=7.000000
   DoT_Interval=1.000000
   BurnPower=20.000000
   MicrowavePower=5.000000
   StumblePower=3.000000
   Name="Default__WMUpgrade_Napalm_DT"
}
