class WMGFxTraderContainer_ItemDetails extends KFGFxTraderContainer_ItemDetails;


function SetPlayerItemDetails(out STraderItem TraderItem, int ItemPrice, optional int UpgradeLevel = INDEX_NONE)
{
	local GFxObject ItemData;
	local int CanAffordIndex, CanCarryIndex;

	KFPC.GetPurchaseHelper().CanUpgrade(TraderItem, CanCarryIndex, CanAffordIndex);

	ItemData = CreateObject("Object");

	ItemData.SetInt("price", ItemPrice);
	ItemData.SetBool("bUsingBuyLabel", false);

	ItemData.SetString("buyOrSellLabel", SellString);
	ItemData.SetString("cannotBuyOrSellLabel", CannotSellString);

	ItemData.SetBool("bCanUpgrade", false);
	ItemData.SetInt("upgradePrice", 0);
	ItemData.SetInt("upgradeWeight", 0);
	ItemData.SetBool("bCanBuyUpgrade", false);
	ItemData.SetBool("bCanCarryUpgrade", false);

	ItemData.SetInt("weaponTier", 0);

	ItemData.SetBool("bCanCarry", true);
	ItemData.SetBool("bCanBuyOrSell", KFPC.GetPurchaseHelper().IsSellable(TraderItem));
	ItemData.SetBool("bHideStats", (TraderItem.WeaponStats.Length == 0));

	ItemData.SetBool("bCanFavorite", true);//KFPC.GetPurchaseHelper().IsSellable(TraderItem));

	SetGenericItemDetails(TraderItem, ItemData, UpgradeLevel);
}


defaultproperties
{
   Name="Default__WMGFxTraderContainer_ItemDetails"
}
