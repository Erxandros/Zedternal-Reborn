class WMGFxTraderContainer_Store extends KFGFxTraderContainer_Store;

function RefreshWeaponListByPerk(byte FilterIndex, const out array<STraderItem> ItemList)
{
	local int i, SlotIndex;
	local GFxObject ItemDataArray; // This array of information is sent to ActionScript to update the Item data
	local array<STraderItem> OnPerkWeapons, SecondaryWeapons, OffPerkWeapons;
	local class<KFPerk> TargetPerkClass;

	if (FilterIndex == 255 || FilterIndex == INDEX_NONE)
		return;

	if (KFPC != None)
	{
		TargetPerkClass = GetPerkFilterClass(FilterIndex);

		SlotIndex = 0;
		ItemDataArray = CreateArray();

		for (i = 0; i < ItemList.Length; ++i)
		{
			if (IsItemFiltered(ItemList[i]))
			{
				continue; // Skip this item if it's in our inventory
			}
			else if (ItemList[i].AssociatedPerkClasses.Length > 0 && ItemList[i].AssociatedPerkClasses[0] != None
				&& TargetPerkClass != class'KFPerk_Survivalist' && TargetPerkClass != KFPC.default.PerkList[0].PerkClass
				&& (TargetPerkClass == None || ItemList[i].AssociatedPerkClasses.Find(TargetPerkClass) == INDEX_NONE))
			{
				continue; // filtered by perk
			}
			else
			{
				if (TargetPerkClass == KFPC.default.PerkList[0].PerkClass)
				{
					if (IsPreciousVariant(ItemList[i]))
						OnPerkWeapons.AddItem(ItemList[i]);
					else if (IsModdedWeapon(ItemList[i]))
						SecondaryWeapons.AddItem(ItemList[i]);
				}
				else if (ItemList[i].AssociatedPerkClasses.Length > 0)
				{
					switch (ItemList[i].AssociatedPerkClasses.Find(TargetPerkClass))
					{
						case 0: //primary perk
							if (OnPerkWeapons.Length == 0 && MyTraderMenu.SelectedList == TL_Shop)
							{
								if (GetInt("currentSelectedIndex") == 0)
									MyTraderMenu.SetTraderItemDetails(i);
							}
							OnPerkWeapons.AddItem(ItemList[i]);
							break;

						case 1: //secondary perk
							SecondaryWeapons.AddItem(ItemList[i]);
							break;

						default: //off perk
							OffPerkWeapons.AddItem(ItemList[i]);
							break;
					}
				}
			}
		}

		for (i = 0; i < OnPerkWeapons.Length; ++i)
		{
			SetItemInfo(ItemDataArray, OnPerkWeapons[i], SlotIndex);
			++SlotIndex;
		}

		for (i = 0; i < SecondaryWeapons.Length; ++i)
		{
			SetItemInfo(ItemDataArray, SecondaryWeapons[i], SlotIndex);
			++SlotIndex;
		}

		for (i = 0; i < OffPerkWeapons.Length; ++i)
		{
			SetItemInfo(ItemDataArray, OffPerkWeapons[i], SlotIndex);
			++SlotIndex;
		}

		SetObject("shopData", ItemDataArray);
	}
}

function class<KFPerk> GetPerkFilterClass(byte index)
{
	if (index < KFPC.default.PerkList.Length - 1)
		return KFPC.default.PerkList[index + 1].PerkClass;
	else if (index == KFPC.default.PerkList.Length - 1)
		return KFPC.default.PerkList[0].PerkClass;
	else
		return None;
}

/** returns True if this item should not be displayed */
function bool IsItemFiltered(STraderItem Item, optional bool bDebug)
{
	local bool bUses9mm;

	if (KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.ClassName))
		return True;

	if (KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.DualClassName))
		return True;

	if (!KFPC.GetPurchaseHelper().IsSellable(Item))
		return True;

	if (WMGameReplicationInfo(KFPC.PlayerReplicationInfo.WorldInfo.GRI) != None && !WMGameReplicationInfo(KFPC.PlayerReplicationInfo.WorldInfo.GRI).IsItemAllowed(Item))
		return True;

	bUses9mm = Has9mmGun();
	if (bUses9mm && (Item.ClassName == 'KFWeap_HRG_93R' || Item.ClassName == 'KFWeap_HRG_93R_Dual'))
		return True;

	if (!bUses9mm && (Item.ClassName == 'KFWeap_Pistol_9mm' || Item.ClassName == 'KFWeap_Pistol_Dual9mm'))
		return True;

	return False;
}

function bool IsPreciousVariant(STraderItem Item)
{
	if (Len(Item.ClassName) >= 8)
		return Right(Item.ClassName, 8) ~= "Precious";

	return False;
}

function bool IsModdedWeapon(STraderItem Item)
{
	local string ClassPath;

	ClassPath = Caps(PathName(Item.WeaponDef));

	if (InStr(ClassPath, "KFGAME") != 0 && InStr(ClassPath, "KFGAMECONTENT") != 0 && InStr(ClassPath, "ZEDTERNALREBORN") != 0)
		return True;

	return False;
}

defaultproperties
{
	Name="Default__WMGFxTraderContainer_Store"
}
