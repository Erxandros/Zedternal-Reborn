class WMGFxTraderContainer_Filter extends KFGFxTraderContainer_Filter;

var array< class<KFPerk> > DefaultPerk;

var localized string CustomWeaponsString;

function BuildPerkList()
{
	local byte i;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetPC());
	if (KFPC != None)
	{
		// Build perk list
		DefaultPerk.Length = 0;
		for (i = 1; i < KFPC.default.PerkList.Length; ++i)
		{
			DefaultPerk.AddItem(KFPC.default.PerkList[i].PerkClass);
		}

		// Add WMPerk last
		DefaultPerk.AddItem(KFPC.default.PerkList[0].PerkClass);
	}
}

function SetPerkFilterData(byte FilterIndex)
{
	local int i;
	local GFxObject DataProvider;
	local GFxObject FilterObject;

	SetBool("filterVisibliity", True);

	if (DefaultPerk.Length == 0)
		BuildPerkList();

	if (DefaultPerk.Length != 0)
	{
		// WMPerk is always zero
		SetInt("selectedIndex", 0);

		// Set the title of this filter based on either the perk or the off perk string
		if (FilterIndex < DefaultPerk.Length - 1)
		{
			SetString("filterText", DefaultPerk[FilterIndex].default.PerkName);
		}
		else if (FilterIndex == DefaultPerk.Length - 1)
		{
			SetString("filterText", default.CustomWeaponsString);
		}
		else
		{
			SetString("filterText", OffPerkString);
		}

		DataProvider = CreateArray();
		for (i = 0; i < DefaultPerk.Length; ++i)
		{
			FilterObject = CreateObject("Object");
			FilterObject.SetString("source", "img://"$DefaultPerk[i].static.GetPerkIconPath());
			DataProvider.SetElementObject(i, FilterObject);
		}

		FilterObject = CreateObject("Object");
		FilterObject.SetString("source", "img://"$class'KFGFxObject_TraderItems'.default.OffPerkIconPath);
		DataProvider.SetElementObject(i, FilterObject);

		SetObject("filterSource", DataProvider);
	}
}

defaultproperties
{
	Name="Default__WMGFxTraderContainer_Filter"
}
