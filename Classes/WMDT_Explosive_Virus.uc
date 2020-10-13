class WMDT_Explosive_Virus extends KFDT_Explosive_CrawlerSuicide
	abstract
	hidedropdown;

defaultproperties
{
	bAnyPerk=True
	bStackDoT=True

	DoT_Type=DOT_Bleeding
	DoT_Duration=5.0f
	DoT_Interval=1.0f
	DoT_DamageScale=0.5f

	StumblePower=200.0f
	GunHitPower=0.0f
	BleedPower=125.0f

	KDeathUpKick=400.0f
	KDeathVel=450.0f
	KDamageImpulse=900.0f

	Name="Default__WMDT_Explosive_Virus"
}
