class WMGFxMenu_Trader extends KFGFxMenu_Trader;

var bool bBlinkPerkButton;

var int SelectedItemIndexInt;

function InitializeMenu( KFGFxMoviePlayer_Manager InManager )
{
	super.InitializeMenu(InManager);
	
	SetString("exitMenuString", "PERK MENU");
	SetString("backPromptString", Localize("KFGFxWidget_ButtonPrompt","CancelString","KFGame"));
	LocalizeText();
}

event OnClose()
{
	CreateUPGMenu();
	super.OnClose();
}

function CreateUPGMenu()
{
	local WMUI_Menu UPGMenu;
	local WMPlayerController WMPC;

	WMPC = WMPlayerController(MyKFPC);
	if (WMPC == None || WMPC.bUpgradeMenuOpen)
		return;

	UPGMenu = new class'ZedternalReborn.WMUI_Menu';
	UPGMenu.Owner = KFPawn_Human(MyKFPC.Pawn);
	UPGMenu.KFPC = MyKFPC;
	UPGMenu.KFPRI = KFPlayerReplicationInfo(MyKFPC.PlayerReplicationInfo);
	UPGMenu.SetTimingMode(TM_Real);
	UPGMenu.Init(LocalPLayer(MyKFPC.Player));

	WMPC.bUpgradeMenuOpen = true;
}

////////
//Copy and pasted from KFGFxMenu_Trader, but with SelectedItemIndex replaced with SelectedItemIndexInt
////////

function SetTraderItemDetails(int ItemIndex)
{
	local STraderItem SelectedItem;
	local bool bCanAfford, bCanBuyItem, bCanCarry;
	SelectedList = TL_Shop;
	if (ItemDetails != none && ShopContainer != none)
	{
		if (MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length >= 0 && ItemIndex < MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length)
		{
			SelectedItemIndexInt = ItemIndex;
			SelectedItem = MyKFPC.GetPurchaseHelper().TraderItems.SaleItems[ItemIndex];

			bCanAfford = MyKFPC.GetPurchaseHelper().GetCanAfford( MyKFPC.GetPurchaseHelper().GetAdjustedBuyPriceFor(SelectedItem) );
			bCanCarry = MyKFPC.GetPurchaseHelper().CanCarry( SelectedItem );

			if (!bCanAfford || !bCanCarry)
			{
				bCanBuyItem = false;
			}
			else
			{
				bCanBuyItem = true;
			}

			PurchaseError(!bCanAfford, !bCanCarry);

			ItemDetails.SetShopItemDetails(SelectedItem, MyKFPC.GetPurchaseHelper().GetAdjustedBuyPriceFor(SelectedItem), bCanCarry, bCanBuyItem);
			bCanBuyOrSellItem = bCanBuyItem;
		}
		else
		{
			ItemDetails.SetVisible(false);
		}
	}
}

function SetPlayerItemDetails(int ItemIndex)
{
	local STraderItem SelectedItem;

	SelectedList = TL_Player;
	if( ItemDetails != none && ItemIndex < OwnedItemList.length)
	{
		bGenericItemSelected = false;
		SelectedItemIndexInt = ItemIndex;
		SelectedItem = OwnedItemList[ItemIndex].DefaultItem;
		ItemDetails.SetPlayerItemDetails(SelectedItem, OwnedItemList[ItemIndex].SellPrice, OwnedItemList[ItemIndex].ItemUpgradeLevel);
		bCanBuyOrSellItem = MyKFPC.GetPurchaseHelper().IsSellable(SelectedItem);
		PurchaseError(false, false);//clear it
	}
}

function SetNewSelectedIndex(int ListLength)
{
	if (SelectedItemIndexInt >= ListLength)
	{
		if (SelectedItemIndexInt != 0)
		{
			--SelectedItemIndexInt;
		}
	}
}

function RefreshItemComponents(optional bool bInitOwnedItems=false)
{
	if( PlayerInventoryContainer != none && PlayerInfoContainer != none )
	{
		if(bInitOwnedItems)
		{
			MyKFPC.GetPurchaseHelper().InitializeOwnedItemList();
		}
		OwnedItemList = MyKFPC.GetPurchaseHelper().OwnedItemList;
		PlayerInventoryContainer.RefreshPlayerInventory();
		RefreshShopItemList(CurrentTab, CurrentFilterIndex);
		GameInfoContainer.UpdateGameInfo();
		GameInfoContainer.SetDosh(MyKFPC.GetPurchaseHelper().TotalDosh);
		GameInfoContainer.SetCurrentWeight(MyKFPC.GetPurchaseHelper().TotalBlocks, MyKFPC.GetPurchaseHelper().MaxBlocks);

		if(SelectedList == TL_Shop)
		{
			SetTraderItemDetails(SelectedItemIndexInt);
		}
		else if(bGenericItemSelected)
		{
			SetGenericItemDetails(LastDefaultItemInfo, LastItemInfo);
		}
		else
		{
			SetPlayerItemDetails(SelectedItemIndexInt);
		}
	}
}

function RefreshShopItemList( TabIndices TabIndex, byte FilterIndex )
{
	if (ShopContainer != none && FilterContainer != none)
	{
		switch (TabIndex)
		{
			case (TI_Perks):
				ShopContainer.RefreshWeaponListByPerk(FilterIndex, MyKFPC.GetPurchaseHelper().TraderItems.SaleItems);
				FilterContainer.SetPerkFilterData(FilterIndex);
			break;
			case (TI_Type):
				ShopContainer.RefreshItemsByType(FilterIndex, MyKFPC.GetPurchaseHelper().TraderItems.SaleItems);
				FilterContainer.SetTypeFilterData(FilterIndex);
			break;
			case (TI_Favorites):
				ShopContainer.RefreshFavoriteItems(MyKFPC.GetPurchaseHelper().TraderItems.SaleItems);
				FilterContainer.ClearFilters();
			break;
			case (TI_All):
				ShopContainer.RefreshAllItems(MyKFPC.GetPurchaseHelper().TraderItems.SaleItems);
				FilterContainer.ClearFilters();
			break;
		}
		FilterContainer.SetInt("selectedTab", TabIndex);
		FilterContainer.SetInt("selectedFilter", FilterIndex);

		if(SelectedList == TL_Shop)
		{
			if( SelectedItemIndexInt >= MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length )
			{
				SelectedItemIndexInt = MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length - 1;
			}

			SetTraderItemDetails(SelectedItemIndexInt);
			ShopContainer.SetSelectedIndex(SelectedItemIndexInt);
		}
	}
}

function Callback_BuyOrSellItem()
{
	local STraderItem ShopItem;
	local SItemInformation ItemInfo;

	if (bCanBuyOrSellItem)
	{
		if (SelectedList == TL_Shop)
		{
			ShopItem = MyKFPC.GetPurchaseHelper().TraderItems.SaleItems[SelectedItemIndexInt];

			MyKFPC.GetPurchaseHelper().PurchaseWeapon(ShopItem);
			SetNewSelectedIndex(MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length);
			SetTraderItemDetails(SelectedItemIndexInt);
			ShopContainer.ActionScriptVoid("itemBought");
		}
		else
		{
			`log("Callback_BuyOrSellItem: SelectedItemIndexInt="$SelectedItemIndexInt, MyKFIM.bLogInventory);
			ItemInfo = OwnedItemList[SelectedItemIndexInt];
			`log("Callback_BuyOrSellItem: ItemInfo="$ItemInfo.DefaultItem.ClassName, MyKFIM.bLogInventory);
			MyKFPC.GetPurchaseHelper().SellWeapon(ItemInfo, SelectedItemIndexInt);

			SetNewSelectedIndex(OwnedItemList.length);
			SetPlayerItemDetails(SelectedItemIndexInt);
			PlayerInventoryContainer.ActionScriptVoid("itemSold");
		}
	}
	else if( SelectedList == TL_Shop )
	{
		ShopItem = MyKFPC.GetPurchaseHelper().TraderItems.SaleItems[SelectedItemIndexInt];

		MyKFPC.PlayTraderSelectItemDialog( !MyKFPC.GetPurchaseHelper().GetCanAfford( MyKFPC.GetPurchaseHelper().GetAdjustedBuyPriceFor(ShopItem) ), !MyKFPC.GetPurchaseHelper().CanCarry( ShopItem ) );
	}
	RefreshItemComponents();
}

function Callback_FavoriteItem()
{
	if (SelectedList == TL_Shop)
	{
		ToggleFavorite(MyKFPC.GetPurchaseHelper().TraderItems.SaleItems[SelectedItemIndexInt].ClassName);
		if (CurrentTab == TI_Favorites)
		{
			SetNewSelectedIndex(MyKFPC.GetPurchaseHelper().TraderItems.SaleItems.length);
		}
		SetTraderItemDetails(SelectedItemIndexInt);
	}
	else
	{
		ToggleFavorite(OwnedItemList[SelectedItemIndexInt].DefaultItem.ClassName);
		SetPlayerItemDetails(SelectedItemIndexInt);
	}
	RefreshItemComponents();
}

function Callback_UpgradeItem()
{
	local SItemInformation ItemInfo;
	local KFAutoPurchaseHelper PurchaseHelper;

	//only relevant in the player inventory
	if (SelectedList == TL_Player)
	{
		PurchaseHelper = MyKFPC.GetPurchaseHelper();
		if (PurchaseHelper.UpgradeWeapon(SelectedItemIndexInt))
		{
			ItemInfo = PurchaseHelper.OwnedItemList[SelectedItemIndexInt];
			PurchaseHelper.OwnedItemList[SelectedItemIndexInt].ItemUpgradeLevel++;
			// SellPrice is updated in UpgradeWeapon, but client-side upgrade level is set here,
			// so update the sellprice again, now that we've updated the upgrade level
			PurchaseHelper.OwnedItemList[SelectedItemIndexInt].SellPrice =
				PurchaseHelper.GetAdjustedSellPriceFor(ItemInfo.DefaultItem);
			RefreshItemComponents();
			ShopContainer.ActionScriptVoid("itemBought");
			class'KFMusicStingerHelper'.static.PlayWeaponUpgradeStinger(MyKFPC);
		}
	}
}

////////
//Override these functions because they use bytes instead of ints
////////

function bool GetIsFavorite(name ClassName)
{
	local int i;
	for (i = 0; i < FavoritedItems.length; i++)
	{
		if (ClassName == FavoritedItems[i])
		{
			return true;
		}
	}
	return false;
}

/** Add or remove the current selected item from the favorites list */
function ToggleFavorite(name ClassName)
{
	local int i;
	local bool bUnfavoriteItem;
	for (i = 0; i < FavoritedItems.length; i++)
	{
		if (ClassName == FavoritedItems[i])
		{
			FavoritedItems.Remove(i, 1);
			bUnfavoriteItem = true;
			Manager.CachedProfile.UnFavoriteWeapon(ClassName);
			break;
		}
	}

	if (!bUnfavoriteItem)
	{
		FavoritedItems.AddItem(ClassName);
		Manager.CachedProfile.FavoriteWeapon(ClassName);
	}

	SaveConfig();
}

defaultproperties
{
	SubWidgetBindings(1)=(WidgetName="FilterContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_Filter')
	SubWidgetBindings(2)=(WidgetName="ShopContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_Store')
	SubWidgetBindings(5)=(WidgetName="ItemDetailsContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_ItemDetails')
	bBlinkPerkButton=false
	Name="Default__WMGFxMenu_Trader"
}
