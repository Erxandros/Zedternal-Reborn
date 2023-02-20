class WMWeap_HRG_Crossboom extends KFWeap_HRG_Crossboom;

function AdjustDamage(out int InDamage, class<DamageType> DamageType, Actor DamageCauser)
{
	super(KFWeap_ScopedBase).AdjustDamage(InDamage, DamageType, DamageCauser);

	if (Instigator != None && DamageCauser.Instigator == Instigator
		&& (ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_HRG_Crossboom')
		|| ClassIsChildOf(DamageType, class'KFGameContent.KFDT_Explosive_HRG_CrossboomAlt')))
	{
		InDamage *= SelfDamageReductionValue;
	}
}


defaultproperties
{
	Name="Default__WMWeap_HRG_Crossboom"
}
