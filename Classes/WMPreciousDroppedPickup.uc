class WMPreciousDroppedPickup extends KFDroppedPickup;

simulated event SetPickupSkin(int ItemId, bool bFinishedLoading = false)
{
	local array<MaterialInterface> SkinMICs;

	if (ItemId > 0 && WorldInfo.NetMode != NM_DedicatedServer && !bWaitingForWeaponSkinLoad)
	{
		if (bFinishedLoading || !StartLoadPickupSkin(ItemId))
		{
			SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(ItemId, WST_Pickup);
			if ( SkinMICs.Length > 0 )
			{
				MyMeshComp.SetMaterial(0, SkinMICs[0]);
			}
		}
	}

	SetUpgradedMaterial();

	if (bEmptyPickup)
    {
        SetEmptyMaterial();
    }
}

defaultproperties
{
}
