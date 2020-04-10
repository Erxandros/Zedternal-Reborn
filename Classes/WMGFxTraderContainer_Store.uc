class WMGFxTraderContainer_Store extends KFGFxTraderContainer_Store;

/** returns true if this item should not be displayed */
function bool IsItemFiltered(STraderItem Item, optional bool bDebug)
{
	if ( KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.ClassName) )
		return true;
	if ( KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.DualClassName) )
		return true;
	if ( !KFPC.GetPurchaseHelper().IsSellable(Item) )
		return true;
	//if ( !WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).IsItemAllowed(Item))
	if ( WMGameReplicationInfo(KFPC.PlayerReplicationInfo.WorldInfo.GRI) != none && !WMGameReplicationInfo(KFPC.PlayerReplicationInfo.WorldInfo.GRI).IsItemAllowed(Item))
		return true;
	//if ( Item.WeaponDef.default.SharedUnlockId != SCU_None && !class'KFUnlockManager'.static.IsSharedContentUnlocked(Item.WeaponDef.default.SharedUnlockId) )
    // 	 	return true;

   	return false;
}

function RefreshWeaponListByPerk(byte FilterIndex, const out array<STraderItem> ItemList)
{
 	local int i, SlotIndex;
	local GFxObject ItemDataArray; // This array of information is sent to ActionScript to update the Item data
	local array<STraderItem> FullItemList;
	local class<KFPerk> TargetPerkClass;
	
	if(FilterIndex == 255 || FilterIndex == INDEX_NONE)
	{
		return;
	}
	if (KFPC != none)
	{
		SlotIndex = 0;
	    //ItemList.length = 0;	    
	    ItemDataArray = CreateArray();
		
		TargetPerkClass = GetPerkFilterClass(FilterIndex);

		FullItemList = WMGameReplicationInfo(KFPC.PlayerReplicationInfo.WorldInfo.GRI).TraderItems.SaleItems;

		for (i = 0; i < FullItemList.Length; i++)
		{
			if ( IsItemFiltered(FullItemList[i]) )
			{
				continue; // Skip this item if it's in our inventory
			}
			else if ( FullItemList[i].AssociatedPerkClasses.length > 0 && FullItemList[i].AssociatedPerkClasses[0] != none && TargetPerkClass != class'ZedternalReborn.WMPerk' && TargetPerkClass != class'KFPerk_Survivalist'
				&& (FilterIndex > KFPC.default.PerkList.Length || FullItemList[i].AssociatedPerkClasses.Find(TargetPerkClass) == INDEX_NONE ) )
			{
				continue; // filtered by perk
			}
			else
			{
				SetItemInfo(ItemDataArray, FullItemList[i], SlotIndex);
				SlotIndex++;
			}
		}

		SetObject("shopData", ItemDataArray);
	}
}

function class<KFPerk> GetPerkFilterClass(byte index)
{
	if (index == 0)
		return class'ZedternalReborn.WMPerk';
	else if (index <= class'KFGame.KFPlayerController'.default.PerkList.length)
		return class'KFGame.KFPlayerController'.default.PerkList[index-1].PerkClass;
	else return none;
}



defaultproperties
{
   Name="Default__WMGFxTraderContainer_Store"
}
