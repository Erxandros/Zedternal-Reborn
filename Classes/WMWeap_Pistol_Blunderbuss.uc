class WMWeap_Pistol_Blunderbuss extends KFWeap_Pistol_Blunderbuss;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeap_PistolBase).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser != None && DamageCauser.Instigator == Instigator
		&& ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_Blunderbuss'))
	{
		InDamage *= SelfDamageReductionValue;
	}
}

defaultproperties
{
	Name="Default__WMWeap_Pistol_Blunderbuss"
}
