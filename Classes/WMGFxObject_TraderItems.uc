class WMGFxObject_TraderItems extends KFGFxObject_TraderItems;

function bool GetItemIndicesFromArcheZedternal( out int ItemIndex, name WeaponClassName )
{
	local int i;

	for (i = 0; i < SaleItems.Length; ++i)
	{
		if( WeaponClassName == SaleItems[i].ClassName )
		{
			ItemIndex = i;
			return true;
		}
	}
	return false;
}

defaultproperties
{
	Name="Default__WMGFxObject_TraderItems";
}
