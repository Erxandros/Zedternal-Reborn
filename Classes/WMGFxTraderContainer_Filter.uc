class WMGFxTraderContainer_Filter extends KFGFxTraderContainer_Filter;

var array< class<KFPerk> > DefaultPerk;

function BuildPerkList()
{
	local byte i;
	
	// build perk list
	DefaultPerk.length = 1 + class'KFGame.KFPlayerController'.default.PerkList.length;
	DefaultPerk[0] = class'Zedternal.WMPerk';
	for (i=1; i<DefaultPerk.length; i+=1)
	{
		DefaultPerk[i] = class'KFGame.KFPlayerController'.default.PerkList[i-1].PerkClass;
	}
}

function SetPerkFilterData(byte FilterIndex)
{
 	local int i;
	local GFxObject DataProvider;
	local GFxObject FilterObject;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;

	SetBool("filterVisibliity", true);

    KFPC = KFPlayerController( GetPC() );
	if ( KFPC != none )
	{
		// build perk list filter
		if (DefaultPerk.length == 0)
			BuildPerkList();
		
		KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
		if ( KFPRI != none )
		{
			SetInt("selectedIndex", KFPRI.NetPerkIndex);

			// Set the title of this filter based on either the perk or the off perk string
			if( FilterIndex < DefaultPerk.Length )
			{
				SetString("filterText", DefaultPerk[FilterIndex].default.PerkName);
			}
			else
			{
				SetString("filterText", OffPerkString);
			}

		   	DataProvider = CreateArray();
			for (i = 0; i < DefaultPerk.Length; i++)
			{
				FilterObject = CreateObject( "Object" );
				FilterObject.SetString("source",  "img://"$DefaultPerk[i].static.GetPerkIconPath());
				FilterObject.SetBool("isMyPerk",  DefaultPerk[i] == KFPC.CurrentPerk.class);
			    DataProvider.SetElementObject( i, FilterObject );
			}

			FilterObject = CreateObject( "Object" );
			FilterObject.SetString("source",  "img://"$class'KFGFxObject_TraderItems'.default.OffPerkIconPath);
			DataProvider.SetElementObject( i, FilterObject );

			SetObject( "filterSource", DataProvider );
    	}
    }
}

defaultproperties
{
}
