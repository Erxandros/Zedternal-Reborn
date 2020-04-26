class WMPreciousDroppedPickup extends KFDroppedPickup;

// Skin assigned for dropped precious weapon
var int PreciousSkinItemId;

replication
{
	if ( bNetInitial )
		PreciousSkinItemId;
}

simulated event SetPickupSkin(int ItemId, bool bFinishedLoading = false)
{
	local array<MaterialInterface> SkinMICs;

	if (PreciousSkinItemId > 0 && WorldInfo.NetMode != NM_DedicatedServer && !bWaitingForWeaponSkinLoad)
	{
		if (bFinishedLoading || !StartLoadPickupSkin(PreciousSkinItemId))
		{
			SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(PreciousSkinItemId, WST_Pickup);
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
