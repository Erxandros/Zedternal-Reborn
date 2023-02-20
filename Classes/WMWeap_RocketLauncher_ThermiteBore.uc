class WMWeap_RocketLauncher_ThermiteBore extends KFWeap_RocketLauncher_ThermiteBore;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeap_GrenadeLauncher_Base).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser != None && DamageCauser.Instigator == Instigator
		&& ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_Thermite'))
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	Name="Default__WMWeap_RocketLauncher_ThermiteBore"
}
