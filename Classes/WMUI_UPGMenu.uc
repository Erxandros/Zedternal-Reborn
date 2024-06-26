Class WMUI_UPGMenu extends GFxObject;

var WMUI_Menu Manager;
var WMPawn_Human Owner;
var WMPlayerController WMPC;
var WMPlayerReplicationInfo WMPRI;
var WMGameReplicationInfo WMGRI;

var GFxObject ItemDetailsContainer, EquipButton;
var int CurrentFilterIndex;
var array<int> PerkUPGIndex, WeaponUPGIndex, SkillUPGIndex, EquipmentUPGIndex;

var AkBaseSoundObject SelectSound, PerkSound, SkillSound, WeaponSound, EquipmentSound;

//For reroll
var int RerollPerkItemDefinition, RerollTotalCost;

enum EWMINV_Filter
{
	EWMInv_All,
	EWMInv_Available,
	EWMInv_Purchased,
};

var EWMINV_Filter CurrentUpgradeFilter;

var localized string TitleString;
var localized string MenuHeaderString;
var localized string MenuTab1String;
var localized string MenuTab2String;
var localized string MenuTab3String;
var localized string MenuTab4String;
var localized string MenuTab5String;
var localized string MenuTab6String;
var localized string MenuTab7String;
var localized string RerollButtonString;
var localized string EquipButtonString;
var localized string SkipButtonString;
var localized string CloseButtonString;
var localized string Filter1String;
var localized string Filter2String;
var localized string Filter3String;
var localized string Filter1Option1String;
var localized string Filter1Option2String;
var localized string Filter1Option3String;
var localized string PerkSkillListHeaderString;
var localized string SkillDeluxeString;
var localized string RerollSuccessTitleString;
var localized string RerollFeeDescriptionString;
var localized string RerollSellDescriptionString;
var localized string RerollRequiredDoshString;
var localized string RerollDoshRefundedString;
var localized string RerollFailTitleString;
var localized string RerollFailDescriptionString;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Initialization
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
		LocalizedObject.SetString("back", class'KFCommon_LocalizedStrings'.default.BackString);
		LocalizedObject.SetString("ok", class'KFCommon_LocalizedStrings'.default.OKString);
		LocalizedObject.SetString("equip", "");
		LocalizedObject.SetString("unequip", "");
		LocalizedObject.SetString("useString", "");
		LocalizedObject.SetString("recycle", default.RerollButtonString);
		LocalizedObject.SetString("inventory", default.TitleString);

		LocalizedObject.SetString("filters", default.MenuHeaderString);
		LocalizedObject.SetString("all", default.MenuTab1String);
		LocalizedObject.SetString("weaponSkins", default.MenuTab2String);
		LocalizedObject.SetString("cosmetics", default.MenuTab3String);
		LocalizedObject.SetString("items", default.MenuTab4String);
		LocalizedObject.SetString("craftingMats", default.MenuTab5String);
		LocalizedObject.SetString("emotes", default.MenuTab6String);
		LocalizedObject.SetString("sfx", default.MenuTab7String);

		LocalizedObject.SetString("craftWeapon", default.SkipButtonString);
		LocalizedObject.SetString("craftCosmetic", default.CloseButtonString);

		LocalizedObject.SetString("filterName_0", default.Filter1String);
		LocalizedObject.SetString("filterName_1", default.Filter2String);
		LocalizedObject.SetString("filterName_2", default.Filter3String);

		LocalizedObject.SetInt("filterIndex_0", int(CurrentUpgradeFilter));

		UpgradeList = CreateArray();

		TempObject = CreateObject("Object");
		TempObject.SetString("label", default.Filter1Option1String);
		UpgradeList.SetElementObject(0, TempObject);

		TempObject = CreateObject("Object");
		TempObject.SetString("label", default.Filter1Option2String);
		UpgradeList.SetElementObject(1, TempObject);

		TempObject = CreateObject("Object");
		TempObject.SetString("label", default.Filter1Option3String);
		UpgradeList.SetElementObject(2, TempObject);

		LocalizedObject.SetObject("filterData_0", UpgradeList);
	}
	SetObject("localizedText", LocalizedObject);
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Callback Functions
function GFxObject Callback_CheckForServerSync()
{
	local GFxObject TempObject;

	TempObject = CreateObject("Object");
	TempObject.SetBool("syncDone", !WMPRI.SyncTimerActive());

	return TempObject;
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
		Index = PerkUPGIndex[Index];
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
			UnlockRandomSkill(PathName(WMGRI.PerkUpgradesList[Index].PerkUpgrade), WMGRI.bDeluxeSkillUnlock[lvl] == 1);
			Owner.PlaySoundBase(default.PerkSound, True);
		}
	}
	else if (CurrentFilterIndex == 1) //Skill Upgrades
	{
		Index = SkillUPGIndex[Index];
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
			Owner.PlaySoundBase(default.SkillSound, True);
		}
	}
	else if (CurrentFilterIndex == 2) //Weapon Upgrades
	{
		Index = WeaponUPGIndex[Index];
		lvl = WMPRI.GetWeaponUpgrade(Index);
		UPGPrice = WMGRI.WeaponUpgradeSlotsList[Index].BasePrice * (lvl + 1);

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
			Owner.PlaySoundBase(default.WeaponSound, True);
		}
	}
	else if (CurrentFilterIndex == 3) //Equipment Upgrades
	{
		Index = EquipmentUPGIndex[Index];
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
			Owner.PlaySoundBase(default.EquipmentSound, True);
		}
	}
	else if (CurrentFilterIndex == 4) //Sidearms
	{
		UPGPrice = WMGRI.SidearmsList[Index].BuyPrice;
		if (WMPRI.bSidearmItem[Index] == 0 && UPGPrice > 0)
		{
			if (WMPRI.Score >= UPGPrice)
			{
				OriginalDosh = WMPRI.Score;
				if (WMPC.WorldInfo.NetMode != NM_Standalone)
					WMPRI.SyncCompleted = False;
				WMPC.BuySidearm(Index, UPGPrice);
				if (WMPC.WorldInfo.NetMode != NM_Standalone)
					WMPRI.bSidearmItem[Index] = 1;
				WMPRI.Score = OriginalDosh - UPGPrice;
				WMPC.ChangeSidearm(Index);
			}
		}
		else
			WMPC.ChangeSidearm(Index);
	}
	else if (CurrentFilterIndex == 5) //Grenades
	{
		WMPC.ChangeGrenade(Index);
	}
	else if (CurrentFilterIndex == 6) //Knives
	{
		WMPC.ChangeKnife(Index);
	}

	Refresh();
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

function Callback_InventoryFilter(int FilterIndex)
{
	local GFxObject ItemArray;

	CurrentFilterIndex = FilterIndex;
	ItemArray = CreateArray();

	if (FilterIndex == 0) //Perk Upgrades
	{
		BuildPerkUpgradeList(ItemArray);
	}
	else if (FilterIndex == 1) //Skill Upgrades
	{
		BuildSkillUpgradeList(ItemArray);
	}
	else if (FilterIndex == 2) //Weapon Upgrades
	{
		BuildWeaponUpgradeList(ItemArray);
	}
	else if (FilterIndex == 3) //Equipment Upgrades
	{
		BuildEquipmentUpgradeList(ItemArray);
	}
	else if (FilterIndex == 4) //Sidearms
	{
		BuildSideArmList(ItemArray);
	}
	else if (FilterIndex == 5) //Grenades
	{
		BuildGrenadeList(ItemArray);
	}
	else if (FilterIndex == 6 && WMPerk(WMPC.CurrentPerk) != None) //Knives
	{
		BuildKnifeList(ItemArray);
	}

	SetObject("inventoryList", ItemArray);
}

function CallBack_ItemDetailsClicked(int ItemDefinition)
{
	local int Index, lvl, price;

	if (!WMPRI.SyncCompleted && WMPRI.SyncTimerActive())
	{
		EquipButton.SetString("label", "...");
		return;
	}

	Index = ItemDefinition;
	Owner.PlaySoundBase(default.SelectSound, True);

	//Upgrades
	if (CurrentFilterIndex == 0) //Perk Upgrades
	{
		Index = PerkUPGIndex[Index];
		lvl = WMPRI.bPerkUpgrade[Index];
		price = WMGRI.PerkUpgPrice[lvl];

		EquipButton.SetString("label", ""$price$Chr(163));
	}
	else if (CurrentFilterIndex == 1) //Skill Upgrades
	{
		Index = SkillUPGIndex[Index];
		lvl = WMPRI.bSkillUpgrade[Index];

		if (WMPRI.bSkillDeluxe[Index] == 1)
			price = WMGRI.SkillUpgDeluxePrice;
		else
			price = WMGRI.SkillUpgPrice;
		EquipButton.SetString("label", ""$price$Chr(163));
	}
	else if (CurrentFilterIndex == 2) //Weapon Upgrades
	{
		Index = WeaponUPGIndex[Index];
		lvl = WMPRI.GetWeaponUpgrade(Index);
		EquipButton.SetString("label", ""$WMGRI.WeaponUpgradeSlotsList[Index].BasePrice * (lvl + 1)$Chr(163));
	}
	else if (CurrentFilterIndex == 3) //Equipment Upgrades
	{
		Index = EquipmentUPGIndex[Index];
		lvl = WMPRI.bEquipmentUpgrade[Index];
		if (WMGRI.EquipmentUpgradesList[Index].MaxLevel > 1)
			EquipButton.SetString("label", ""$WMGRI.EquipmentUpgradesList[Index].BasePrice +
				Round(float(WMGRI.EquipmentUpgradesList[Index].MaxPrice - WMGRI.EquipmentUpgradesList[Index].BasePrice) /
				float(WMGRI.EquipmentUpgradesList[Index].MaxLevel - 1) * lvl)$Chr(163));
		else
			EquipButton.SetString("label", ""$WMGRI.EquipmentUpgradesList[Index].BasePrice$Chr(163));
	}
	else if (CurrentFilterIndex == 4) //Sidearms
	{
		if (WMPRI.bSidearmItem[Index] == 0 && WMGRI.SidearmsList[Index].BuyPrice > 0)
			EquipButton.SetString("label", ""$WMGRI.SidearmsList[Index].BuyPrice$Chr(163));
		else
			EquipButton.SetString("label", default.EquipButtonString);
	}
	else if (CurrentFilterIndex == 5 || CurrentFilterIndex == 6) //Knives and Grenades
	{
		EquipButton.SetString("label", default.EquipButtonString);
	}
}

// Upgrade Filter
function Callback_RarityTypeFilterChanged(int NewFilterIndex)
{
	CurrentUpgradeFilter = EWMINV_Filter(NewFilterIndex);
	WMPC.UPG_UpgradeListIndex = NewFilterIndex;
	Refresh();
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
		if (WMGRI.SkillUpgradesList[b].PerkPathName ~= PathName(WMGRI.PerkUpgradesList[PerkUPGIndex[ItemDefinition]].PerkUpgrade))
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

		if (WMGRI.PerkUpgradesList[PerkUPGIndex[ItemDefinition]].PerkUpgrade.default.bShouldLocalize)
			STitle = repl(default.RerollSuccessTitleString, "%x%", WMGRI.PerkUpgradesList[PerkUPGIndex[ItemDefinition]].PerkUpgrade.static.GetUpgradeName());
		else
			STitle = repl(default.RerollSuccessTitleString, "%x%", WMGRI.PerkUpgradesList[PerkUPGIndex[ItemDefinition]].PerkUpgrade.default.UpgradeName);

		SDescription = repl(default.RerollFeeDescriptionString, "%x%", RerollCost);
		if (Count > 0)
		{
			SDescription = SDescription @Count @default.RerollSellDescriptionString;
			SDescription = repl(SDescription, "%x%", Round(WMGRI.RerollSkillSellPercent * 100));
			SDescription = repl(SDescription, "%y%", SkillRefund);
			if (TotalCost > 0)
				SDescription = SDescription $"\n" $default.RerollRequiredDoshString @TotalCost;
			else
				SDescription = SDescription $"\n" $default.RerollDoshRefundedString @-TotalCost;
		}

		Manager.OpenUPGMenuPopup(STitle, SDescription, class'KFCommon_LocalizedStrings'.default.ConfirmString, class'KFCommon_LocalizedStrings'.default.CancelString, ConfirmSkillReroll, ResetRerollVars);
	}
	else
	{
		STitle = default.RerollFailTitleString;
		SDescription = default.RerollFailDescriptionString @Round(WMPRI.Score);
		SDescription = SDescription $"\n" $default.RerollRequiredDoshString @TotalCost;
		Manager.OpenUPGMenuPopup(STitle, SDescription, , , , , class'KFCommon_LocalizedStrings'.default.OKString, ResetRerollVars);
	}
}

// Close menu
function CallBack_RequestCosmeticCraftInfo()
{
	Manager.CloseMenu();
}

function Callback_RequestInitialnventory()
{
	Callback_InventoryFilter(0);
}

// Vote to skip trader
function CallBack_RequestWeaponCraftInfo()
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
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// GUI Helpers
function Refresh()
{
	Callback_InventoryFilter(CurrentFilterIndex);
	UpdateText();
	EquipButton.SetString("label", "...");
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
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Perk Upgrade Functions
function BuildPerkUpgradeList(out GFxObject ItemArray)
{
	local bool bPurchased;
	local GFxObject ItemObject;
	local int i, x, lvl, MaxLevel, TempPrice;
	local string S;

	PerkUPGIndex.Length = 0;
	x = 0;

	for (i = 0; i < WMGRI.PerkUpgradesList.Length; ++i)
	{
		if (WMPRI.bPerkUpgradeAvailable[i] > 0)
		{
			lvl = WMPRI.bPerkUpgrade[i];

			// Get Max Level of that upgrade
			MaxLevel = WMGRI.PerkUpgMaxLevel;

			// Is it fully bought?
			if (lvl >= MaxLevel)
				bPurchased = True;
			else
				bPurchased = False;

			// Create info arch
			if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
			{
				if (bPurchased)
					--lvl;

				ItemObject = CreateObject("Object");

				TempPrice = WMGRI.PerkUpgPrice[lvl];
				ItemObject.SetInt("count", TempPrice);

				if (WMGRI.PerkUpgradesList[i].PerkUpgrade.default.bShouldLocalize)
					S = WMGRI.PerkUpgradesList[i].PerkUpgrade.static.GetUpgradeName();
				else
					S = WMGRI.PerkUpgradesList[i].PerkUpgrade.default.UpgradeName;

				if (MaxLevel > 1)
				{
					if (bPurchased)
						S @= "(" $MaxLevel $"/" $MaxLevel $")";
					else
						S @= "(" $lvl $"/" $MaxLevel $")";
				}

				ItemObject.SetString("label", S);
				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", False);
				ItemObject.SetBool("recyclable", WMGRI.bAllowSkillReroll ? lvl > 0 : False);
				ItemObject.SetInt("definition", x);
				if (bPurchased)
				{
					ItemObject.SetInt("type", 1);
					ItemObject.SetBool("active", True);
					ItemObject.SetInt("rarity", 0);
				}
				else
				{
					if (WMPRI.Score < TempPrice)
						ItemObject.SetInt("type", 1);
					else
						ItemObject.SetInt("type", 0);

					ItemObject.SetBool("active", False);
				}
				S = "img://"$PathName(WMGRI.PerkUpgradesList[i].PerkUpgrade.static.GetUpgradeIcon(lvl));
				ItemObject.SetString("description", GetPerkDescription(i, lvl));
				ItemObject.SetString("iconURLSmall", S);
				ItemObject.SetString("iconURLLarge", S);
				ItemArray.SetElementObject(x, ItemObject);
				PerkUPGIndex.AddItem(i);
				++x;
			}
		}
	}
}

function string GetPerkDescription(int index, int lvl)
{
	local string S, TextColor;
	local bool bFirstSkill;
	local int i;

	// write list of passive bonuses
	if (WMGRI.PerkUpgradesList[index].PerkUpgrade.default.bShouldLocalize)
	{
		if (WMGRI.PerkUpgradesList[index].PerkUpgrade.default.LocalizeDescriptionLineCount == 0)
			return "";
		else
			S = repl(WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetUpgradeDescription(0), "%x%", WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetBonusValue(0, lvl + 1));

		for (i = 1; i < WMGRI.PerkUpgradesList[index].PerkUpgrade.default.LocalizeDescriptionLineCount; ++i)
		{
			S $= "\n" $repl(WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetUpgradeDescription(i), "%x%", WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetBonusValue(i, lvl + 1));
		}
	}
	else
	{
		if (WMGRI.PerkUpgradesList[index].PerkUpgrade.default.UpgradeDescription.Length == 0)
			return "";
		else
			S = repl(WMGRI.PerkUpgradesList[index].PerkUpgrade.default.UpgradeDescription[0], "%x%", WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetBonusValue(0, lvl + 1));

		for (i = 1; i < WMGRI.PerkUpgradesList[index].PerkUpgrade.default.UpgradeDescription.Length; ++i)
		{
			S $= "\n" $repl(WMGRI.PerkUpgradesList[index].PerkUpgrade.default.UpgradeDescription[i], "%x%", WMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetBonusValue(i, lvl + 1));
		}
	}

	// write associated skills (and use different colors for locked, unlocked and bought skills)
	bFirstSkill = True;
	S $= "\n\n\n\n" $default.PerkSkillListHeaderString $"\n";
	for (i = 0; i < WMGRI.SkillUpgradesList.Length; ++i)
	{
		if (WMGRI.SkillUpgradesList[i].PerkPathName ~= PathName(WMGRI.PerkUpgradesList[index].PerkUpgrade))
		{
			if (WMPRI.bSkillUpgrade[i] != 0)
			{
				if (WMPRI.bSkillDeluxe[i] != 0)
					TextColor = "b346ea";
				else
					TextColor = "05b6ca";
			}
			else if (WMPRI.bSkillUnlocked[i] != 0)
			{
				if (WMPRI.bSkillDeluxe[i] != 0)
					TextColor = "f0cff7";
				else
					TextColor = "eaeff7";
			}
			else
				TextColor = "919191";

			if (bFirstSkill)
			{
				S $= "\n";
				bFirstSkill = False;
			}
			else
				S $= ", ";

			if (WMGRI.SkillUpgradesList[i].SkillUpgrade.default.bShouldLocalize)
				S $= "<font color=\"#" $TextColor $"\">" $WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeName() $"</font>";
			else
				S $= "<font color=\"#" $TextColor $"\">" $WMGRI.SkillUpgradesList[i].SkillUpgrade.default.UpgradeName $"</font>";
		}
	}

	return S;
}

function UnlockRandomSkill(string PerkPathName, bool bShouldBeDeluxe)
{
	local array<int> AvailableIndex;
	local int i, choice;

	for (i = 0; i < WMGRI.SkillUpgradesList.Length; ++i)
	{
		if (WMGRI.SkillUpgradesList[i].PerkPathName ~= PerkPathName && WMPRI.bSkillUnlocked[i] == 0)
			AvailableIndex.AddItem(i);
	}

	if (AvailableIndex.Length > 0)
	{
		choice = Rand(AvailableIndex.Length);
		WMPC.UnlockSkill(AvailableIndex[choice], bShouldBeDeluxe);

		WMPRI.bSkillUnlocked[AvailableIndex[choice]] = 1;
		if (bShouldBeDeluxe)
			WMPRI.bSkillDeluxe[AvailableIndex[choice]] = 1;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Skill Upgrade Functions
function BuildSkillUpgradeList(out GFxObject ItemArray)
{
	local bool bPurchased;
	local GFxObject ItemObject;
	local int i, x, lvl, TempPrice;
	local string S;

	SkillUPGIndex.Length = 0;
	x = 0;

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

				if (WMGRI.SkillUpgradesList[i].SkillUpgrade.default.bShouldLocalize)
					S = WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeName();
				else
					S = WMGRI.SkillUpgradesList[i].SkillUpgrade.default.UpgradeName;

				if (WMPRI.bSkillDeluxe[i] == 1)
				{
					ItemObject.SetString("label", S @default.SkillDeluxeString);
					if (WMGRI.SkillUpgradesList[i].SkillUpgrade.default.bShouldLocalize)
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeDescription(True));
					else
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.UpgradeDescription[1]);
					S = "img://"$PathName(WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeIcon(1));
					TempPrice = WMGRI.SkillUpgDeluxePrice;
				}
				else
				{
					ItemObject.SetString("label", S);
					if (WMGRI.SkillUpgradesList[i].SkillUpgrade.default.bShouldLocalize)
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeDescription(False));
					else
						ItemObject.SetString("description", WMGRI.SkillUpgradesList[i].SkillUpgrade.default.UpgradeDescription[0]);
					S = "img://"$PathName(WMGRI.SkillUpgradesList[i].SkillUpgrade.static.GetUpgradeIcon(0));
					TempPrice = WMGRI.SkillUpgPrice;
				}
				ItemObject.SetInt("count", TempPrice);

				ItemObject.SetString("iconURLSmall", S);
				S = "img://"$PathName(WMGRI.PerkUpgradesList[GetPerkRelatedIndex(i)].PerkUpgrade.static.GetUpgradeIcon(0));
				ItemObject.SetString("iconURLLarge", S);

				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", False);
				ItemObject.SetBool("recyclable", False);
				ItemObject.SetInt("definition", x);
				if (bPurchased)
				{
					ItemObject.SetInt("type", 1);
					ItemObject.SetBool("active", True);
					ItemObject.SetInt("rarity", 0);
				}
				else
				{
					if (WMPRI.Score < TempPrice)
						ItemObject.SetInt("type", 1);
					else
						ItemObject.SetInt("type", 0);

					ItemObject.SetBool("active", False);
				}
				ItemArray.SetElementObject(x, ItemObject);
				SkillUPGIndex.AddItem(i);
				++x;
			}
		}
	}
}

function int GetPerkRelatedIndex(int SkillIndex)
{
	//return Skill perk related index
	local byte b;

	for (b = 0; b < WMGRI.PerkUpgradesList.Length; ++b)
	{
		if (PathName(WMGRI.PerkUpgradesList[b].PerkUpgrade) ~= WMGRI.SkillUpgradesList[SkillIndex].PerkPathName)
			return b;
	}

	return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Weapon Upgrade Functions
function BuildWeaponUpgradeList(out GFxObject ItemArray)
{
	local bool bPurchased;
	local GFxObject ItemObject;
	local int i, x, lvl, MaxLevel, TempPrice;
	local string S;

	WeaponUPGIndex.Length = 0;
	x = 0;

	for (i = 0; i < WMGRI.WeaponUpgradeSlotsList.Length; ++i)
	{
		if (IsWeaponInInventory(WMGRI.WeaponUpgradeSlotsList[i].KFWeapon))
		{
			lvl = WMPRI.GetWeaponUpgrade(i);

			MaxLevel = WMGRI.WeaponUpgradeSlotsList[i].MaxLevel;

			// Is it fully bought?
			if (lvl >= MaxLevel)
				bPurchased = True;
			else
				bPurchased = False;

			// Create info arch
			if ((CurrentUpgradeFilter == EWMInv_All) || (CurrentUpgradeFilter == EWMInv_Available && !bPurchased) || (CurrentUpgradeFilter == EWMInv_Purchased && bPurchased))
			{
				if (bPurchased)
					--lvl;

				ItemObject = CreateObject("Object");
				TempPrice = WMGRI.WeaponUpgradeSlotsList[i].BasePrice * (lvl + 1);
				ItemObject.SetInt("count", TempPrice);

				if (WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.default.bShouldLocalize)
					S = WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.static.GetUpgradeName();
				else
					S = WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.default.UpgradeName;

				if (MaxLevel > 1)
				{
					if (bPurchased)
						S @= "(" $MaxLevel $"/" $MaxLevel $")";
					else
						S @= "(" $lvl $"/" $MaxLevel $")";
				}

				ItemObject.SetString("label", S);
				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", False);
				ItemObject.SetBool("recyclable", False);
				ItemObject.SetInt("definition", x);
				if (bPurchased)
				{
					ItemObject.SetInt("type", 1);
					ItemObject.SetBool("active", True);
					ItemObject.SetInt("rarity", 0);
				}
				else
				{
					if (WMPRI.Score < TempPrice)
						ItemObject.SetInt("type", 1);
					else
						ItemObject.SetInt("type", 0);

					ItemObject.SetBool("active", False);
				}

				if (WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.default.bShouldLocalize)
					S = repl(WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.static.GetUpgradeDescription(), "%x%", WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.static.GetBonusValue(lvl + 1));
				else
					S = repl(WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.default.UpgradeDescription[0], "%x%", WMGRI.WeaponUpgradeSlotsList[i].WeaponUpgrade.static.GetBonusValue(lvl + 1));
				ItemObject.SetString("description", S);
				S = "img://"$PathName(WMGRI.WeaponUpgradeSlotsList[i].KFWeapon.default.WeaponSelectTexture);
				ItemObject.SetString("iconURLSmall", S);
				ItemObject.SetString("iconURLLarge", S);
				ItemArray.SetElementObject(x, ItemObject);
				WeaponUPGIndex.AddItem(i);
				++x;
			}
		}
	}
}

function bool IsWeaponInInventory(class<KFWeapon> WeaponClass)
{
	local KFWeapon Weapon;

	foreach Owner.InvManager.InventoryActors(class'KFWeapon', Weapon)
	{
		if (ClassIsChildOf(Weapon.Class, WeaponClass) && ClassIsChildOf(WeaponClass, Weapon.Class))
			return True;
		else if (Weapon.DualClass != None && ClassIsChildOf(Weapon.DualClass, WeaponClass) && ClassIsChildOf(WeaponClass, Weapon.DualClass))
			return True;
		else if (KFWeap_DualBase(Weapon) != None && ClassIsChildOf(KFWeap_DualBase(Weapon).default.SingleClass, WeaponClass) && ClassIsChildOf(WeaponClass, KFWeap_DualBase(Weapon).default.SingleClass))
			return True;
	}

	return False;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Equipment Upgrade Functions
function BuildEquipmentUpgradeList(out GFxObject ItemArray)
{
	local bool bPurchased;
	local GFxObject ItemObject;
	local int i, x, lvl, MaxLevel, TempPrice;
	local string S;

	EquipmentUPGIndex.Length = 0;
	x = 0;

	for (i = 0; i < WMGRI.EquipmentUpgradesList.Length; ++i)
	{
		lvl = WMPRI.bEquipmentUpgrade[i];

		// Get Max Level of that upgrade
		MaxLevel = WMGRI.EquipmentUpgradesList[i].MaxLevel;

		// Is it fully bought?
		if (lvl >= MaxLevel)
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
				TempPrice = WMGRI.EquipmentUpgradesList[i].BasePrice + Round(float(WMGRI.EquipmentUpgradesList[i].MaxPrice - WMGRI.EquipmentUpgradesList[i].BasePrice) /
					float(WMGRI.EquipmentUpgradesList[i].MaxLevel - 1) * lvl);
			else
				TempPrice = WMGRI.EquipmentUpgradesList[i].BasePrice;

			ItemObject.SetInt("count", TempPrice);

			if (WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.default.bShouldLocalize)
				S = WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.static.GetUpgradeName();
			else
				S = WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.default.UpgradeName;

			if (MaxLevel > 1)
			{
				if (bPurchased)
					S @= "(" $MaxLevel $"/" $MaxLevel $")";
				else
					S @= "(" $lvl $"/" $MaxLevel $")";
			}

			ItemObject.SetString("label", S);
			ItemObject.SetString("price", "");
			ItemObject.Setstring("typeRarity", "");
			ItemObject.SetBool("exchangeable", False);
			ItemObject.SetBool("recyclable", False);
			ItemObject.SetInt("definition", x);
			if (bPurchased)
			{
				ItemObject.SetInt("type", 1);
				ItemObject.SetBool("active", True);
				ItemObject.SetInt("rarity", 0);
			}
			else
			{
				if (WMPRI.Score < TempPrice)
					ItemObject.SetInt("type", 1);
				else
					ItemObject.SetInt("type", 0);

				ItemObject.SetBool("active", False);
			}
			S = "img://"$PathName(WMGRI.EquipmentUpgradesList[i].EquipmentUpgrade.static.GetUpgradeIcon(lvl));
			ItemObject.SetString("description", GetEquipmentDescription(i, lvl));
			ItemObject.SetString("iconURLSmall", S);
			ItemObject.SetString("iconURLLarge", S);
			ItemArray.SetElementObject(x, ItemObject);
			EquipmentUPGIndex.AddItem(i);
			++x;
		}
	}
}

function string GetEquipmentDescription(int index, int lvl)
{
	local string S;
	local int i;

	// write list of equipment bonuses
	if (WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.bShouldLocalize)
	{
		if (WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.LocalizeDescriptionLineCount == 0)
			return "";
		else
			S = repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetUpgradeDescription(0), "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(0, lvl + 1));

		for (i = 1; i < WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.LocalizeDescriptionLineCount; ++i)
		{
			S $= "\n" $repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetUpgradeDescription(i), "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(i, lvl + 1));
		}
	}
	else
	{
		if (WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.UpgradeDescription.Length == 0)
			return "";
		else
			S = repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.UpgradeDescription[0], "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(0, lvl + 1));

		for (i = 1; i < WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.UpgradeDescription.Length; ++i)
		{
			S $= "\n" $repl(WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.default.UpgradeDescription[i], "%x%", WMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBonusValue(i, lvl + 1));
		}
	}

	return S;
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Sidearm, Grenade, and Knife Functions
function BuildSideArmList(out GFxObject ItemArray)
{
	local GFxObject ItemObject;
	local int i;

	for (i = 0; i < WMGRI.SidearmsList.Length; ++i)
	{
		ItemObject = CreateObject("Object");
		ItemObject.SetInt("count", 1);
		ItemObject.SetString("label", WMGRI.SidearmsList[i].Sidearm.static.GetItemName());
		ItemObject.SetString("description", "");
		ItemObject.SetString("iconURLSmall", "img://" $WMGRI.SidearmsList[i].Sidearm.static.GetImagePath());
		ItemObject.SetString("iconURLLarge", "img://" $WMGRI.SidearmsList[i].Sidearm.static.GetImagePath());
		ItemObject.SetString("price", "");
		ItemObject.Setstring("typeRarity", "");
		ItemObject.SetBool("exchangeable", False);
		ItemObject.SetBool("recyclable", False);
		ItemObject.SetInt("definition", i);
		ItemObject.SetInt("type", 0);
		if (WMPC.CurrentPerk.GetSecondaryWeaponClassPath() ~= WMGRI.SidearmsList[i].Sidearm.default.WeaponClassPath)
		{
			ItemObject.SetBool("active", True);
			ItemObject.SetInt("type", 1);
		}
		else
		{
			ItemObject.SetBool("active", False);
			ItemObject.SetInt("type", 0);
		}
		ItemArray.SetElementObject(i, ItemObject);
	}
}

function BuildGrenadeList(out GFxObject ItemArray)
{
	local GFxObject ItemObject;
	local int i;

	for (i = 0; i < WMGRI.GrenadesList.Length; ++i)
	{
		if (WMGRI.GrenadesList[i].Grenade != None)
		{
			ItemObject = CreateObject("Object");
			ItemObject.SetInt("count", 1);
			ItemObject.SetString("label", WMGRI.GrenadesList[i].Grenade.static.GetItemName());
			ItemObject.SetString("description", "");
			ItemObject.SetString("iconURLSmall", "img://" $WMGRI.GrenadesList[i].Grenade.static.GetImagePath());
			ItemObject.SetString("iconURLLarge", "img://" $WMGRI.GrenadesList[i].Grenade.static.GetImagePath());
			ItemObject.SetString("price", "");
			ItemObject.Setstring("typeRarity", "");
			ItemObject.SetBool("exchangeable", False);
			ItemObject.SetBool("recyclable", False);
			ItemObject.SetInt("definition", i);
			ItemObject.SetInt("type", 0);
			if (WMPC.CurrentPerk.GrenadeWeaponDef == WMGRI.GrenadesList[i].Grenade)
			{
				ItemObject.SetBool("active", True);
				ItemObject.SetInt("type", 1);
			}
			else
			{
				ItemObject.SetBool("active", False);
				ItemObject.SetInt("type", 0);
			}
			ItemArray.SetElementObject(i, ItemObject);
		}
	}
}

function BuildKnifeList(out GFxObject ItemArray)
{
	local GFxObject ItemObject;
	local int i;
	local WMPerk WMP;
	local byte KnifeIndex;

	WMP = WMPerk(WMPC.CurrentPerk);
	KnifeIndex = class'ZedternalReborn.Config_LocalPreferences'.static.GetKnifeIndex();

	for (i = 0; i < WMP.KnivesWeaponDef.Length; ++i)
	{
		ItemObject = CreateObject("Object");
		ItemObject.SetInt("count", 1);
		ItemObject.SetString("label", WMP.KnivesWeaponDef[i].static.GetItemName());
		ItemObject.SetString("description", "");
		ItemObject.SetString("iconURLSmall", "img://" $WMP.KnivesWeaponDef[i].static.GetImagePath());
		ItemObject.SetString("iconURLLarge", "img://" $WMP.KnivesWeaponDef[i].static.GetImagePath());
		ItemObject.SetString("price", "");
		ItemObject.Setstring("typeRarity", "");
		ItemObject.SetBool("exchangeable", False);
		ItemObject.SetBool("recyclable", False);
		ItemObject.SetInt("definition", i);
		ItemObject.SetInt("type", 0);
		if (i == KnifeIndex)
		{
			ItemObject.SetBool("active", True);
			ItemObject.SetInt("type", 1);
		}
		else
		{
			ItemObject.SetBool("active", False);
			ItemObject.SetInt("type", 0);
		}
		ItemArray.SetElementObject(i, ItemObject);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// Reroll Functions
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

		RerollPerkPathName = PathName(WMGRI.PerkUpgradesList[PerkUPGIndex[RerollPerkItemDefinition]].PerkUpgrade);
		WMPC.RerollSkillsForPerk(RerollPerkPathName, RerollTotalCost);

		for (i = 0; i < WMGRI.SkillUpgradesList.Length; ++i)
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
		Owner.PlaySoundBase(default.SkillSound, True);

		SkillRerollUnlock(PerkUPGIndex[RerollPerkItemDefinition]);
	}
	else
		ResetRerollVars();
}

function ResetRerollVars()
{
	RerollPerkItemDefinition = -1;
	RerollTotalCost = 0;
}

function SkillRerollUnlock(int PerkIndex)
{
	local string RerollPerkPathName;
	local int i;

	if (WMPRI.RerollSyncCompleted)
	{
		RerollPerkPathName = PathName(WMGRI.PerkUpgradesList[PerkIndex].PerkUpgrade);

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
////////////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
	SelectSound=AkEvent'WW_UI_Menu.Play_TRADER_INVENTORY_ITEM_CLICK'
	WeaponSound=AkEvent'WW_UI_Menu.Play_UI_Weapon_Upgrade'
	PerkSound=AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Sell'
	SkillSound=AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Buy'
	EquipmentSound=AkEvent'WW_UI_PlayerCharacter.Play_UI_Pickup_Armor'

	RerollPerkItemDefinition=-1

	Name="Default__WMUI_UPGMenu"
}
