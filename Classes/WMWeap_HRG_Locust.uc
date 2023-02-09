class WMWeap_HRG_Locust extends KFWeap_HRG_Locust;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeap_GrenadeLauncher_Base).AdjustDamage(InDamage, DamageType, DamageCauser);
}

defaultproperties
{
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'WMProj_HRG_Locust'
	WeaponProjectiles(DEFAULT_FIREMODE)=class'WMProj_HRG_Locust'
	Name="Default__WMWeap_HRG_Locust"
}
