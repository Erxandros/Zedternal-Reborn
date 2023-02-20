class WMWeap_RocketLauncher_SealSqueal extends KFWeap_RocketLauncher_SealSqueal;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeap_GrenadeLauncher_Base).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser != None && DamageCauser.Instigator == Instigator
		&& ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_SealSqueal'))
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	Name="Default__WMWeap_RocketLauncher_SealSqueal"
}
