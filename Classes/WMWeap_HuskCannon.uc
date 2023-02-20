class WMWeap_HuskCannon extends KFWeap_HuskCannon;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeapon).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser != None && DamageCauser.Instigator == Instigator
		&& ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_HuskCannon'))
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	Name="Default__WMWeap_HuskCannon"
}
