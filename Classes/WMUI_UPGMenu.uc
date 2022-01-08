Class WMUI_UPGMenu extends GFxObject;

var WMUI_Menu Manager;
var WMPawn_Human Owner;
var WMPlayerController WMPC;
var WMPlayerReplicationInfo WMPRI;
var WMGameReplicationInfo WMGRI;

var GFxObject ItemDetailsContainer,EquipButton;
var int CurrentFilterIndex;
var array<int> perkUPGIndex, weaponUPGIndex, skillUPGIndex, equipmentUPGIndex, GrenadeIndex;

var AkBaseSoundObject selectSound, perkSound, skillSound, weaponSound, equipmentSound;

//For reroll
var int RerollPerkItemDefinition, RerollTotalCost;

enum EWMINV_Filter
{
	EWMInv_All,
	EWMInv_Available,
	EWMInv_Purchased,
};

var EWMINV_Filter CurrentUpgradeFilter;

function InitializeMenu(WMUI_Menu MenuManager)
{
	Manager = MenuManager;
	WMGRI = WMGameReplicationInfo(WMPC.WorldInfo.GRI);
	if (Owner == None || WMPC == None || WMPRI == None || WMGRI == None)
	{
		Manager.CloseMenu();
		return;
	}

	// check if player is using a controller
	SetBool("bUsingGamepad", class'WorldInfo'.static.IsConsoleBuild());

	CurrentFilterIndex = 0;
	CurrentUpgradeFilter = EWMINV_Filter(WMPC.UPG_UpgradeListIndex);

	UpdateText();
	ItemDetailsContainer = GetObject("itemDetailsContainer");
	EquipButton = ItemDetailsContainer.GetObject("equipButton");
	UpdateCraftButtons(); //check if player voted to skip trader time
}

function UpdateText()
{
	local GFxObject LocalizedObject, UpgradeList, TempObject;

	LocalizedObject = GetObject("localizedText");
	if (LocalizedObject == None)
	{
		LocalizedObject = CreateObject("Object");
		LocalizedObject.SetString("noItems", "");
		LocalizedObject.SetString("back", Class'KFCommon_LocalizedStrings'.default.BackString);
		LocalizedObject.SetString("ok", Class'KFCommon_LocalizedStrings'.default.OKString);
		LocalizedObject.SetString("equip", "");
		LocalizedObject.SetString("unequip", "");
		LocalizedObject.SetString("useString", "");
		LocalizedObject.SetString("recycle", "Reroll Skills");
		LocalizedObject.SetString("inventory", "Upgrade Menu");

		LocalizedObject.SetString("filters", "Loadout");
		LocalizedObject.SetString("all", "Perk Upgrades");
		LocalizedObject.SetString("weaponSkins", "Skill Upgrades");
		LocalizedObject.SetString("cosmetics", "Weapon Upgrades");
		LocalizedObject.SetString("items", "Equipment Upgrades");
		LocalizedObject.SetString("craftingMats", "Grenades");
		LocalizedObject.SetString("emotes", "Knives");
		LocalizedObject.SetString("sfx", " ");

		LocalizedObject.SetString("craftWeapon", "Skip Trader Time");
		LocalizedObject.SetString("craftCosmetic", "Close Menu");

		LocalizedObject.SetString("filterName_0", "Upgrades");
		LocalizedObject.SetString("filterName_1", "");
		LocalizedObject.SetString("filterName_2", "");

		LocalizedObject.SetInt("filterIndex_0", int(CurrentUpgradeFilter));

		UpgradeList = CreateArray();

		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Show All");
		UpgradeList.SetElementObject(0, TempObject);

		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Available");
		UpgradeList.SetElementObject(1, TempObject);

		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Purchased");
		UpgradeList.SetElementObject(2, TempObject);

		LocalizedObject.SetObject("filterData_0", UpgradeList);
	}
	SetObject("localizedText", LocalizedObject);
}

function GFxObject Callback_FilterOneEnable(int FilterIndex)
{
	local GFxObject TempObject;

	TempObject = CreateObject("Object");
	switch (FilterIndex)
	{
		case 0:
			TempObject.SetBool("enable", True);
			break;
		case 1:
			TempObject.SetBool("enable", True);
			break;
		case 2:
			TempObject.SetBool("enable", True);
			break;
		case 3:
			TempObject.SetBool("enable", True);
			break;
		default:
			TempObject.SetBool("enable", False);
	}

	return TempObject;
}

function GFxObject Callback_FilterTwoEnable(int FilterIndex)
{
	local GFxObject TempObject;

	TempObject = CreateObject("Object");
	switch (FilterIndex)
	{
		default:
			TempObject.SetBool("enable", False);
	}

	return TempObject;
}

function GFxObject Callback_FilterThreeEnable(int FilterIndex)
{
	local GFxObject TempObject;

	TempObject = CreateObject("Object");
	switch (FilterIndex)
	{
		default:
			TempObject.SetBool("enable", False);
	}

	return TempObject;
}

function GFxObject Callback_CheckForServerSync()
{
	local GFxObject TempObject;

	TempObject = CreateObject("Object");
	TempObject.SetBool("syncDone", !WMPRI.SyncTimerActive());

	return TempObject;
}

function Callback_InventoryFilter(int FilterIndex)
{
	local GFxObject ItemArray, ItemObject;
	local int i, j, tempPrice, maxLevel, lvl;
	local string S;
	local bool bPurchased;
	local WMPerk WMP;

	CurrentFilterIndex = FilterIndex;
	ItemArray = CreateArray();
	j = 0;
	perkUPGIndex.length = 0;
	weaponUPGIndex.length = 0;
	skillUPGIndex.length = 0;
	equipmentUPGIndex.length = 0;

	GrenadeIndex.length = 0;

	if (FilterIndex == 0) //Perk Upgrades
	{
		for (i = 0; i < WMGRI.PerkUpgradesList.length; ++i)
		{
			if (WMPRI.bPerkUpgradeAvailable[i] > 0)
			{
				lvl = WMPRI.bPerkUpgrade[i];

				// Get Max Level of that upgrade
				maxLevel = WMGRI.PerkUpgMaxLevel;

				// Is it fully bought?
				if (lvl >= maxLevel)
					bPurchased = True;
				else
					bPurchased = False;

				// Create info arch
				if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
				{
					if (bPurchased)
						--lvl;
					ItemObject = CreateObject("Object");

					tempPrice = WMGRI.PerkUpgPrice[lvl];
					ItemObject.SetInt("count", tempPrice);

					if (maxLevel > 1)
					{
						if (bPurchased)
							ItemObject.SetString("label", WMGRI.PerkUpgradesList[i].default.upgradeName $ " (" $ maxLevel $ "/" $ maxLevel $ ")");
						else
							ItemObject.SetString("label", WMGRI.PerkUpgradesList[i].default.upgradeName $ " (" $ lvl $ "/" $ maxLevel $ ")");
					}
					else
						ItemObject.SetString("label", WMGRI.PerkUpgradesList[i].default.upgradeName);

					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", False);
					ItemObject.SetBool("recyclable", WMGRI.bAllowSkillReroll ? lvl > 0 : False);
					ItemObject.SetInt("definition", j);
					if (bPurchased)
					{
						ItemObject.SetInt("type", 1);
						ItemObject.SetBool("active", True);
						ItemObject.SetInt("rarity", 0);
					}
					else
					{
						if (WMPRI.Score < tempPrice)
							ItemObject.SetInt("type", 1);
						else
							ItemObject.SetInt("type", 0);
						ItemObject.SetBool("active", False);
					}
					S = "img://"$PathName(WMGRI.PerkUpgradesList[i].static.GetupgradeIcon(lvl));
					ItemObject.SetString("description", GetUpgradeDescription(i, lvl));
					ItemObject.SetString("iconURLSmall", S);
					ItemObject.SetString("iconURLLarge", S);
					ItemArray.SetElementObject(j, ItemObject);
					perkUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	else if (FilterIndex == 1) //Skill Upgrades
	{
		for (i = 0; i < WMGRI.SkillUpgradesList.Length; ++i)
		{
			if (WMPRI.bSkillUnlocked[i] == 1)
			{
				lvl = WMPRI.bSkillUpgrade[i];

				// Is it fully bought?
				if (lvl == 0)
					bPurchased = False;
				else
					bPurchased = True;

				// Create info arch
				if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
				{
					ItemObject = CreateObject("Object");

					if (WMPRI.bSkillDeluxe[i] == 1)
					{
						ItemObject.SetString("label", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeName $ " [Deluxe]");
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeDescription[1]);
						S = "img://"$PathName(WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetupgradeIcon(1));
						tempPrice = WMGRI.SkillUpgDeluxePrice;
					}
					else
					{
						ItemObject.SetString("label", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeName);
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeDescription[0]);
						S = "img://"$PathName(WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetupgradeIcon(0));
						tempPrice = WMGRI.SkillUpgPrice;
					}
					ItemObject.SetInt("count", tempPrice);

					ItemObject.SetString("iconURLSmall", S);
					S = "img://"$PathName(WMGRI.PerkUpgradesList[GetPerkRelatedIndex(i)].static.GetupgradeIcon(0));
					ItemObject.SetString("iconURLLarge", S);

					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", False);
					ItemObject.SetBool("recyclable", False);
					ItemObject.SetInt("definition", j);
					if (bPurchased)
					{
						ItemObject.SetInt("type", 1);
						ItemObject.SetBool("active", True);
						ItemObject.SetInt("rarity", 0);
					}
					else
					{
						if (WMPRI.Score < tempPrice)
							ItemObject.SetInt("type", 1);
						else
							ItemObject.SetInt("type", 0);
						ItemObject.SetBool("active", False);
					}

					ItemArray.SetElementObject(j, ItemObject);
					skillUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	else if (FilterIndex == 2) //Weapon Upgrades
	{
		for (i = 0; i < WMGRI.WeaponUpgradesList.Length; ++i)
		{
			if (isWeaponInInventory(WMGRI.WeaponUpgradesList[i].KFWeapon))
			{
				lvl = WMPRI.GetWeaponUpgrade(i);

				maxLevel = WMGRI.WeaponUpgMaxLevel;

				// Is it fully bought?
				if (lvl >= maxLevel)
					bPurchased = True;
				else
					bPurchased = False;

				// Create info arch
				if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
				{
					if (bPurchased)
						--lvl;
					ItemObject = CreateObject("Object");
					ItemObject.SetInt("count", WMGRI.WeaponUpgradesList[i].BasePrice * (lvl + 1));

					if (maxLevel > 1)
					{
						if (bPurchased)
							ItemObject.SetString("label", WMGRI.WeaponUpgradesList[i].KFWeaponUpgrade.default.upgradeName $ " (" $ maxLevel $ "/" $ maxLevel $ ")");
						else
							ItemObject.SetString("label", WMGRI.WeaponUpgradesList[i].KFWeaponUpgrade.default.upgradeName $ " (" $ lvl $ "/" $ maxLevel $ ")");
					}

					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", False);
					ItemObject.SetBool("recyclable", False);
					ItemObject.SetInt("definition", j);
					if (bPurchased)
					{
						ItemObject.SetInt("type", 1);
						ItemObject.SetBool("active", True);
						ItemObject.SetInt("rarity", 0);
					}
					else
					{
						if (WMPRI.Score < WMGRI.WeaponUpgradesList[i].BasePrice * (lvl + 1))
							ItemObject.SetInt("type", 1);
						else
							ItemObject.SetInt("type", 0);
						ItemObject.SetBool("active", False);
					}
					S = "img://"$PathName(WMGRI.WeaponUpgradesList[i].KFWeapon.default.WeaponSelectTexture);
					ItemObject.SetString("description", repl(WMGRI.WeaponUpgradesList[i].KFWeaponUpgrade.default.upgradeDescription[0], "%x%", WMGRI.WeaponUpgradesList[i].KFWeaponUpgrade.static.GetBonusValue(lvl + 1)));
					ItemObject.SetString("iconURLSmall", S);
					ItemObject.SetString("iconURLLarge", S);
					ItemArray.SetElementObject(j, ItemObject);
					weaponUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	else if (FilterIndex == 3) //Equipment Upgrades
	{
		for (i = 0; i < WMGRI.EquipmentUpgradesList.Length; ++i)
		{
			lvl = WMPRI.bEquipmentUpgrade[i];

			// Get Max Level of that upgrade
			maxLevel = WMGRI.EquipmentUpgradesList[i].MaxLevel;

			// Is it fully bought?
			if (lvl >= maxLevel)
				bPurchased = True;
			else
				bPurchased = False;

			// Create info arch
			if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
			{
				if (bPurchased)
					--lvl;
				ItemObject = CreateObject("Object");

				if (WMGRI.EquipmentUpgradesList[i].MaxLevel > 1)
					tempPrice = WMGRI.EquipmentUpgradesList[i].BasePrice + Round(float(WMGRI.EquipmentUpgradesList[i].MaxPrice - WMGRI.EquipmentUpgradesList[i].BasePrice) /
						float(WMGRI.EquipmentUpgradesList[i].MaxLevel - 1) * lvl);
				else
					tempPrice = WMGRI.EquipmentUpgradesList[i].BasePrice;

				ItemObject.SetInt("count", tempPrice);

				if (maxLevel > 1)
				{
					if (bPurchased)
						ItemObject.SetString("label", WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.default.upgradeName $ " (" $ maxLevel $ "/" $ maxLevel $ ")");
					else
						ItemObject.SetString("label", WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.default.upgradeName $ " (" $ lvl $ "/" $ maxLevel $ ")");
				}
				else
					ItemObject.SetString("label", WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.default.upgradeName);

				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", False);
				ItemObject.SetBool("recyclable", False);
				ItemObject.SetInt("definition", j);
				if (bPurchased)
				{
					ItemObject.SetInt("type", 1);
					ItemObject.SetBool("active", True);
					ItemObject.SetInt("rarity", 0);
				}
				else
				{
					if (WMPRI.Score < tempPrice)
						ItemObject.SetInt("type", 1);
					else
						ItemObject.SetInt("type", 0);
					ItemObject.SetBool("active", False);
				}
				S = "img://"$PathName(WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.static.GetupgradeIcon(lvl));
				ItemObject.SetString("description", GetEquipmentDescription(i, lvl));
				ItemObject.SetString("iconURLSmall", S);
				ItemObject.SetString("iconURLLarge", S);
				ItemArray.SetElementObject(j, ItemObject);
				equipmentUPGIndex.AddItem(i);
				++j;
			}
		}
	}
	else if (FilterIndex == 4) //Grenades
	{
		for (i = 0; i < WMGRI.GrenadesList.length; ++i)
		{
			if (WMGRI.GrenadesList[i] != None)
			{
				ItemObject = CreateObject("Object");
				ItemObject.SetInt("count", 1);
				ItemObject.SetString("label", WMGRI.GrenadesList[i].static.GetItemName());
				ItemObject.SetString("description", "");
				ItemObject.SetString("iconURLSmall", "img://" $ WMGRI.GrenadesList[i].static.GetImagePath());
				ItemObject.SetString("iconURLLarge", "img://" $ WMGRI.GrenadesList[i].static.GetImagePath());
				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", False);
				ItemObject.SetBool("recyclable", False);
				ItemObject.SetInt("definition", j);
				ItemObject.SetInt("type" ,0);
				if (WMPC.CurrentPerk.GrenadeWeaponDef == WMGRI.GrenadesList[i])
				{
					ItemObject.SetBool("active", True);
					ItemObject.SetInt("type", 1);
				}
				else
				{
					ItemObject.SetBool("active", False);
					ItemObject.SetInt("type", 0);
				}
				ItemArray.SetElementObject(j, ItemObject);
				GrenadeIndex.AddItem(i);
				++j;
			}
		}
	}
	else if (FilterIndex == 5 && WMPerk(WMPC.CurrentPerk) != None) //Knives
	{
		WMP = WMPerk(WMPC.CurrentPerk);
		for (i = 0; i < WMP.KnivesWeaponDef.length; ++i)
		{
			ItemObject = CreateObject("Object");
			ItemObject.SetInt("count", 1);
			ItemObject.SetString("label", WMP.KnivesWeaponDef[i].static.GetItemName());
			ItemObject.SetString("description", "");
			ItemObject.SetString("iconURLSmall", "img://" $ WMP.KnivesWeaponDef[i].static.GetImagePath());
			ItemObject.SetString("iconURLLarge", "img://" $ WMP.KnivesWeaponDef[i].static.GetImagePath());
			ItemObject.SetString("price", "");
			ItemObject.Setstring("typeRarity", "");
			ItemObject.SetBool("exchangeable", False);
			ItemObject.SetBool("recyclable", False);
			ItemObject.SetInt("definition", j);
			ItemObject.SetInt("type", 0);
			if (WMPC.Preferences != None && i == WMPC.Preferences.KnifeIndex)
			{
				ItemObject.SetBool("active", True);
				ItemObject.SetInt("type", 1);
			}
			else
			{
				ItemObject.SetBool("active", False);
				ItemObject.SetInt("type", 0);
			}
			ItemArray.SetElementObject(j, ItemObject);
			++j;
		}
	}

	SetObject("inventoryList", ItemArray);
}

function string GetUpgradeDescription(int index, int lvl)
{
	local string str, textColor;
	local bool bFirstSkill;
	local int i;

	// write list of passive bonuses
	if (WMGRI.PerkUpgradesList[index].default.upgradeDescription.length == 0)
		return "";
	else
		str = repl(WMGRI.PerkUpgradesList[index].default.upgradeDescription[0], "%x%", WMGRI.PerkUpgradesList[index].static.GetBonusValue(0, lvl + 1));

	for (i = 1; i < WMGRI.PerkUpgradesList[index].default.upgradeDescription.length; ++i)
	{
		str = str $ "\n" $ repl(WMGRI.PerkUpgradesList[index].default.upgradeDescription[i], "%x%", WMGRI.PerkUpgradesList[index].static.GetBonusValue(i, lvl + 1));
	}

	// write associated skills (and use different colors for locked, unlocked and bought skills)
	bFirstSkill = True;
	str = str $ "\n\n\n\nBuying this upgrade will unlocked one of these skills :\n";
	for (i = 0; i < WMGRI.SkillUpgradesList.length; ++i)
	{
		if (WMGRI.SkillUpgradesList[i].PerkPathName ~= PathName(WMGRI.PerkUpgradesList[index]))
		{
			if (WMPRI.bSkillUpgrade[i] != 0)
			{
				if (WMPRI.bSkillDeluxe[i] != 0)
					textColor = "b346ea";
				else
					textColor = "05b6ca";
			}
			else if (WMPRI.bSkillUnlocked[i] != 0)
			{
				if (WMPRI.bSkillDeluxe[i] != 0)
					textColor = "f0cff7";
				else
					textColor = "eaeff7";
			}
			else
				textColor = "919191";

			if (bFirstSkill)
			{
				str = str $ "\n<font color=\"#" $textColor$ "\">" $WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeName$ "</font>";
				bFirstSkill = False;
			}
			else
				str = str $ ", <font color=\"#" $textColor$ "\">" $WMGRI.SkillUpgradesList[i].SkillUpgrade.default.upgradeName$ "</font>";
		}
	}

	return str;
}

function string GetEquipmentDescription(int index, int lvl)
{
	local string str;
	local int i;

	// write list of equipment bonuses
	if (WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.upgradeDescription.length == 0)
		return "";
	else
		str = repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.upgradeDescription[0], "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(0, lvl + 1));

	for (i = 1; i < WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.upgradeDescription.length; ++i)
	{
		str = str $ "\n" $ repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.upgradeDescription[i], "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(i, lvl + 1));
	}

	return str;
}

function ResetRerollVars()
{
	RerollPerkItemDefinition = -1;
	RerollTotalCost = 0;
}

function ConfirmSkillReroll()
{
	local string RerollPerkPathName;
	local int i, OriginalDosh;

	if (RerollPerkItemDefinition != INDEX_NONE)
	{
		OriginalDosh = WMPRI.Score;
		++WMPRI.RerollCounter;
		if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.RerollSyncCompleted = False;

		RerollPerkPathName = PathName(WMGRI.PerkUpgradesList[perkUPGIndex[RerollPerkItemDefinition]]);
		WMPC.RerollSkillsForPerk(RerollPerkPathName, RerollTotalCost);

		for (i = 0; i < WMGRI.SkillUpgradesList.length; ++i)
		{
			if (RerollPerkPathName ~= WMGRI.SkillUpgradesList[i].PerkPathName)
			{
				WMPRI.bSkillUpgrade[i] = 0;
				WMPRI.bSkillUnlocked[i] = 0;
				WMPRI.bSkillDeluxe[i] = 0;

				if (WMPRI.Purchase_SkillUpgrade.Find(i) != INDEX_NONE)
				{
					WMPRI.Purchase_SkillUpgrade.RemoveItem(i);
					WMGRI.SkillUpgradesList[i].SkillUpgrade.static.DeleteHelperClass(Owner);
					WMGRI.SkillUpgradesList[i].SkillUpgrade.static.RevertUpgradeChanges(Owner);
				}
			}
		}

		WMPRI.Score = OriginalDosh - RerollTotalCost;
		Owner.PlaySoundBase(default.skillSound, True);

		SkillRerollUnlock(perkUPGIndex[RerollPerkItemDefinition]);
	}
	else
		ResetRerollVars();
}

function SkillRerollUnlock(int PerkIndex)
{
	local string RerollPerkPathName;
	local int i;

	if (WMPRI.RerollSyncCompleted)
	{
		RerollPerkPathName = PathName(WMGRI.PerkUpgradesList[PerkIndex]);

		for (i = 0; i < WMPRI.bPerkUpgrade[PerkIndex]; ++i)
		{
			UnlockRandomSkill(RerollPerkPathName, WMGRI.bDeluxeSkillUnlock[i] == 1);
		}

		Refresh();
		ResetRerollVars();
	}
	else
		WMPRI.SetRerollSyncTimer(self, PerkIndex);
}

function Callback_RecycleItem(int ItemDefinition)
{
	local string STitle, SDescription;
	local int RerollCost, SkillRefund, TotalCost;
	local byte b, Count;

	RerollCost = WMGRI.RerollCost * (WMGRI.RerollMultiplier ** WMPRI.RerollCounter);
	SkillRefund = 0;
	Count = 0;
	foreach WMPRI.Purchase_SkillUpgrade(b)
	{
		if (WMGRI.SkillUpgradesList[b].PerkPathName ~= PathName(WMGRI.PerkUpgradesList[perkUPGIndex[ItemDefinition]]))
		{
			if (WMPRI.bSkillDeluxe[b] > 0)
				SkillRefund += Round(float(WMGRI.SkillUpgDeluxePrice) * WMGRI.RerollSkillSellPercent);
			else
				SkillRefund += Round(float(WMGRI.SkillUpgPrice) * WMGRI.RerollSkillSellPercent);

			++Count;
		}
	}

	TotalCost = RerollCost - SkillRefund;
	if (WMPRI.Score >= TotalCost)
	{
		RerollPerkItemDefinition = ItemDefinition;
		RerollTotalCost = TotalCost;

		STitle = "Reroll skills for perk" @WMGRI.PerkUpgradesList[perkUPGIndex[ItemDefinition]].default.upgradeName $"?";
		SDescription = "This will cost a reroll fee of" @RerollCost @"Dosh.";
		if (Count > 0)
		{
			SDescription = SDescription @Count @"skill(s) will be sold at a" @Round(WMGRI.RerollSkillSellPercent * 100) $"% rate for a total refund of" @SkillRefund @"Dosh.";
			if (TotalCost > 0)
				SDescription = SDescription @"\nRequired Dosh:" @TotalCost;
			else
				SDescription = SDescription @"\nDosh Refunded:" @-TotalCost;
		}

		Manager.OpenUPGMenuPopup(STitle, SDescription, "Confirm", "Cancel", ConfirmSkillReroll, ResetRerollVars);
	}
	else
		Manager.OpenUPGMenuPopup("Lack of Dosh", "Current Dosh:" @Round(WMPRI.Score) $"\nRequired Dosh:" @TotalCost, , , , , "Okay", ResetRerollVars);
}

// Upgrade Filter
function Callback_RarityTypeFilterChanged(int NewFilterIndex)
{
	CurrentUpgradeFilter = EWMINV_Filter(NewFilterIndex);
	WMPC.UPG_UpgradeListIndex = NewFilterIndex;
	Refresh();
}

function bool isWeaponInInventory(class<KFWeapon> weaponClass)
{
	local KFWeapon Weapon;

	foreach Owner.InvManager.InventoryActors(class'KFWeapon', Weapon)
	{
		if (ClassIsChildOf(Weapon.Class, weaponClass) && ClassIsChildOf(weaponClass, Weapon.Class))
			return True;
		else if (Weapon.DualClass != None && ClassIsChildOf(Weapon.DualClass, weaponClass) && ClassIsChildOf(weaponClass, Weapon.DualClass))
			return True;
		else if (KFWeap_DualBase(Weapon) != None && ClassIsChildOf(KFWeap_DualBase(Weapon).default.SingleClass, weaponClass) && ClassIsChildOf(weaponClass, KFWeap_DualBase(Weapon).default.SingleClass))
			return True;
	}

	return False;
}

function CallBack_RequestWeaponCraftInfo() // Vote to skip trader
{
	if (WMGRI.bTraderIsOpen)
	{
		if (!WMPRI.bVotingActive || WMPC.WorldInfo.NetMode == NM_Standalone)
			WMPRI.RequestSkiptTrader(WMPRI);
		else
			WMPRI.CastSkipTraderVote(WMPRI, True);
	}

	//refresh button
	UpdateCraftButtons();

	Manager.CloseMenu();
}

function UpdateCraftButtons()
{
	local GFxObject ItemListContainer, CraftWeaponButton;

	ItemListContainer = GetObject("inventoryListContainer");
	if (ItemListContainer != None)
	{
		CraftWeaponButton = ItemListContainer.GetObject("craftWeaponsButton");
		if (CraftWeaponButton != None)
			CraftWeaponButton.SetBool("enabled", WMGRI.bTraderIsOpen && (WMPC.WorldInfo.NetMode == NM_Standalone ? True : !WMPRI.bHasVoted));
	}
}

function CallBack_RequestCosmeticCraftInfo() // Close menu.
{
	Manager.CloseMenu();
}

function Refresh()
{
	Callback_InventoryFilter(CurrentFilterIndex);
	UpdateText();
	EquipButton.SetString("label", "Synchronizing...");
}

function Callback_RequestInitialnventory()
{
	Callback_InventoryFilter(0);
}

function CallBack_ItemDetailsClicked(int ItemDefinition)
{
	local int Index, lvl, price;

	if (!WMPRI.SyncCompleted && WMPRI.SyncTimerActive())
	{
		EquipButton.SetString("label", "Synchronizing...");
		return;
	}

	Index = ItemDefinition;
	Owner.PlaySoundBase(default.selectSound, True);

	//Upgrades
	if (CurrentFilterIndex == 0) //Perk Upgrades
	{
		Index = perkUPGIndex[Index];
		lvl = WMPRI.bPerkUpgrade[Index];
		price = WMGRI.PerkUpgPrice[lvl];

		EquipButton.SetString("label", ""$price$Chr(163));
	}
	else if (CurrentFilterIndex == 1) //Skill Upgrades
	{
		Index = skillUPGIndex[Index];
		lvl = WMPRI.bSkillUpgrade[Index];

		if (WMPRI.bSkillDeluxe[Index] == 1)
			price = WMGRI.SkillUpgDeluxePrice;
		else
			price = WMGRI.SkillUpgPrice;
		EquipButton.SetString("label", ""$price$Chr(163));
	}
	else if (CurrentFilterIndex == 2) //Weapon Upgrades
	{
		Index = weaponUPGIndex[Index];
		lvl = WMPRI.GetWeaponUpgrade(Index);
		EquipButton.SetString("label", ""$WMGRI.WeaponUpgradesList[Index].BasePrice * (lvl + 1)$Chr(163));
	}
	else if (CurrentFilterIndex == 3) //Equipment Upgrades
	{
		Index = equipmentUPGIndex[Index];
		lvl = WMPRI.bEquipmentUpgrade[Index];
		if (WMGRI.EquipmentUpgradesList[Index].MaxLevel > 1)
			EquipButton.SetString("label", ""$WMGRI.EquipmentUpgradesList[Index].BasePrice +
				Round(float(WMGRI.EquipmentUpgradesList[Index].MaxPrice - WMGRI.EquipmentUpgradesList[Index].BasePrice) /
				float(WMGRI.EquipmentUpgradesList[Index].MaxLevel - 1) * lvl)$Chr(163));
		else
			EquipButton.SetString("label", ""$WMGRI.EquipmentUpgradesList[Index].BasePrice$Chr(163));
	}
	else if (CurrentFilterIndex == 4 || CurrentFilterIndex == 5)//Knives and Grenades
	{
		EquipButton.SetString("label", "Equip");
	}
}

function Callback_Equip(int ItemDefinition)
{
	local int Index, lvl, UPGPrice, OriginalDosh;

	if (ItemDefinition == -1)
		return;

	if (!WMPRI.SyncCompleted)
	{
		if (!WMPRI.SyncTimerActive())
			WMPRI.SetSyncTimer(self, ItemDefinition);

		return;
	}

	Index = ItemDefinition;

	//Upgrades
	if (CurrentFilterIndex == 0) //Perk Upgrades
	{
		Index = perkUPGIndex[Index];
		lvl = WMPRI.bPerkUpgrade[Index];
		UPGPrice = WMGRI.PerkUpgPrice[lvl];

		if (WMPRI.Score >= UPGPrice)
		{
			OriginalDosh = WMPRI.Score;
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.SyncCompleted = False;
			WMPC.BuyPerkUpgrade(Index, UPGPrice);
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.bPerkUpgrade[Index] = lvl + 1;
			WMPRI.Score = OriginalDosh - UPGPrice;
			if (WMPRI.Purchase_PerkUpgrade.Find(Index) == INDEX_NONE)
				WMPRI.Purchase_PerkUpgrade.AddItem(Index);
			UnlockRandomSkill(PathName(WMGRI.PerkUpgradesList[Index]), WMGRI.bDeluxeSkillUnlock[lvl] == 1);
			Owner.PlaySoundBase(default.perkSound, True);
		}
	}
	else if (CurrentFilterIndex == 1) //Skill Upgrades
	{
		Index = skillUPGIndex[Index];
		lvl = WMPRI.bSkillUpgrade[Index];

		if (WMPRI.bSkillDeluxe[Index] == 1)
			UPGPrice = WMGRI.SkillUpgDeluxePrice;
		else
			UPGPrice = WMGRI.SkillUpgPrice;

		if (WMPRI.Score >= UPGPrice)
		{
			OriginalDosh = WMPRI.Score;
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.SyncCompleted = False;
			WMPC.BuySkillUpgrade(Index, GetPerkRelatedIndex(Index), UPGPrice, WMPRI.bSkillDeluxe[Index] + 1);
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.bSkillUpgrade[Index] = lvl + WMPRI.bSkillDeluxe[Index] + 1;
			WMPRI.Score = OriginalDosh - UPGPrice;
			if (WMPRI.Purchase_SkillUpgrade.Find(Index) == INDEX_NONE)
				WMPRI.Purchase_SkillUpgrade.AddItem(Index);
			Owner.PlaySoundBase(default.skillSound, True);
		}
	}
	else if (CurrentFilterIndex == 2) //Weapon Upgrades
	{
		Index = weaponUPGIndex[Index];
		lvl = WMPRI.GetWeaponUpgrade(Index);
		UPGPrice = WMGRI.WeaponUpgradesList[Index].BasePrice * (lvl + 1);

		if (WMPRI.Score >= UPGPrice)
		{
			OriginalDosh = WMPRI.Score;
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.SyncCompleted = False;
			WMPC.BuyWeaponUpgrade(Index, UPGPrice);
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.SetWeaponUpgrade(Index, lvl + 1);
			WMPRI.Score = OriginalDosh - UPGPrice;
			WMPC.UpdateWeaponMagAndCap();
			if (WMPRI.Purchase_WeaponUpgrade.Find(Index) == INDEX_NONE)
				WMPRI.Purchase_WeaponUpgrade.AddItem(Index);
			Owner.PlaySoundBase(default.weaponSound, True);
		}
	}
	else if (CurrentFilterIndex == 3) //Equipment Upgrades
	{
		Index = equipmentUPGIndex[Index];
		lvl = WMPRI.bEquipmentUpgrade[Index];
		if (WMGRI.EquipmentUpgradesList[Index].MaxLevel > 1)
			UPGPrice = WMGRI.EquipmentUpgradesList[Index].BasePrice +
			Round(float(WMGRI.EquipmentUpgradesList[Index].MaxPrice - WMGRI.EquipmentUpgradesList[Index].BasePrice) / float(WMGRI.EquipmentUpgradesList[Index].MaxLevel - 1) * lvl);
		else
			UPGPrice = WMGRI.EquipmentUpgradesList[Index].BasePrice;

		if (WMPRI.Score >= UPGPrice)
		{
			OriginalDosh = WMPRI.Score;
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.SyncCompleted = False;
			WMPC.BuyEquipmentUpgrade(Index, UPGPrice);
			if (WMPC.WorldInfo.NetMode != NM_Standalone)
				WMPRI.bEquipmentUpgrade[Index] = lvl + 1;
			WMPRI.Score = OriginalDosh - UPGPrice;
			WMPC.UpdateWeaponMagAndCap();
			if (WMPRI.Purchase_EquipmentUpgrade.Find(Index) == INDEX_NONE)
				WMPRI.Purchase_EquipmentUpgrade.AddItem(Index);
			Owner.PlaySoundBase(default.equipmentSound, True);
		}
	}
	else if (CurrentFilterIndex == 4) //Grenades
	{
		WMPC.ChangeGrenade(GrenadeIndex[Index]);
	}
	else if (CurrentFilterIndex == 5) //Knives
	{
		WMPC.ChangeKnife(Index);
	}

	Refresh();
}

function int GetPerkRelatedIndex(int SkillIndex)
{
	//return Skill perk related index
	local byte b;

	for (b = 0; b < WMGRI.PerkUpgradesList.length; ++b)
	{
		if (PathName(WMGRI.PerkUpgradesList[b]) ~= WMGRI.SkillUpgradesList[SkillIndex].PerkPathName)
			return b;
	}

	return 0;
}

function UnlockRandomSkill(string perkPathName, bool bShouldBeDeluxe)
{
	local array<int> availableIndex;
	local int i, choice;

	for (i = 0; i < WMGRI.SkillUpgradesList.length; ++i)
	{
		if (WMGRI.SkillUpgradesList[i].PerkPathName ~= perkPathName && WMPRI.bSkillUnlocked[i] == 0)
			availableIndex.AddItem(i);
	}

	if (availableIndex.length > 0)
	{
		choice = Rand(availableIndex.length);
		WMPC.UnlockSkill(availableIndex[choice], bShouldBeDeluxe);

		WMPRI.bSkillUnlocked[availableIndex[choice]] = 1;
		if (bShouldBeDeluxe)
			WMPRI.bSkillDeluxe[availableIndex[choice]] = 1;
	}
}

defaultproperties
{
	selectSound=AkEvent'WW_UI_Menu.Play_TRADER_INVENTORY_ITEM_CLICK'
	weaponSound=AkEvent'WW_UI_Menu.Play_UI_Weapon_Upgrade'
	perkSound=AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Sell'
	skillSound=AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Buy'
	equipmentSound=AkEvent'WW_UI_PlayerCharacter.Play_UI_Pickup_Armor'

	RerollPerkItemDefinition=-1

	Name="Default__WMUI_UPGMenu"
}
