class WMGFxWidget_PartyInGame extends KFGFxWidget_PartyInGame;

function GFxObject RefreshSlot(int SlotIndex, KFPlayerReplicationInfo KFPRI)
{
	local GFxObject WMPlayerInfoObject, WMPerkIconObject;
	local WMPlayerReplicationInfo WMPRI;

	WMPlayerInfoObject = super.RefreshSlot(SlotIndex, KFPRI);

	if (MemberSlots[SlotIndex].PRI != none)
	{
		WMPRI = WMPlayerReplicationInfo(MemberSlots[SlotIndex].PRI);
		if (WMPRI != none)
		{
			WMPlayerInfoObject.SetString("perkLevel", string(WMPRI.perkLvl));

			WMPerkIconObject = CreateObject("Object");
			WMPerkIconObject.SetString("perkIcon", "img://"$PathName(WMPRI.GetCurrentIconToDisplay()));
			WMPerkIconObject.SetString("prestigeIcon", "");

			WMPlayerInfoObject.SetObject("perkImageSource", WMPerkIconObject);
		}
	}

	return WMPlayerInfoObject;
}

defaultproperties
{
	PlayerSlots=12
	Name="Default__WMGFxWidget_PartyInGame"
}
