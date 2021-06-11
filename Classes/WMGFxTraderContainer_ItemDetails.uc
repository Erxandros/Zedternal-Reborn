class WMGFxTraderContainer_ItemDetails extends KFGFxTraderContainer_ItemDetails;

function SetPlayerItemDetails(out STraderItem TraderItem, int ItemPrice, optional int UpgradeLevel = INDEX_NONE)
{
	local GFxObject ItemData;
	local int CanAffordIndex, CanCarryIndex;

	KFPC.GetPurchaseHelper().CanUpgrade(TraderItem, CanCarryIndex, CanAffordIndex);

	ItemData = CreateObject("Object");

	ItemData.SetInt("price", ItemPrice);
	ItemData.SetBool("bUsingBuyLabel", False);

	ItemData.SetString("buyOrSellLabel", SellString);
	ItemData.SetString("cannotBuyOrSellLabel", CannotSellString);

	ItemData.SetBool("bCanBuyUpgrade", False);
	ItemData.SetBool("bCanCarryUpgrade", False);

	ItemData.SetInt("upgradePrice", 0);
	ItemData.SetInt("upgradeWeight", 0);
	ItemData.SetBool("bCanUpgrade", False);

	ItemData.SetInt("weaponTier", INDEX_NONE);

	ItemData.SetBool("bCanCarry", True);
	ItemData.SetBool("bCanBuyOrSell", KFPC.GetPurchaseHelper().IsSellable(TraderItem));
	ItemData.SetBool("bHideStats", (TraderItem.WeaponStats.Length == 0));

	ItemData.SetBool("bCanFavorite", True);

	SetGenericItemDetails(TraderItem, ItemData, INDEX_NONE);
}

defaultproperties
{
	Name="Default__WMGFxTraderContainer_ItemDetails"
}
