class WMWeap_GravityImploder extends KFWeap_GravityImploder;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeapon).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser != None && DamageCauser.Instigator == Instigator
		&& (ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_GravityImploder')
		|| ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_GravityImploderWave')))
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	Name="Default__WMWeap_GravityImploder"
}
