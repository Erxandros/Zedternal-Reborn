Class WMUI_UPGMenu extends GFxObject;

var WMUI_Menu Manager;
var GFxObject ItemDetailsContainer,EquipButton;
var int CurrentFilterIndex;
var int CurrentBuyIndex;
var string CurrentBuyType;
var int CurrentBuyLvl;
var KFPawn_Human Owner;
var KFPlayerController KFPC;
var KFPlayerReplicationInfo KFPRI;
var int perkUPGLength, weaponUPGLength, skillUPGLength;
var int skillLastUnlocked;
var array< int > perkUPGIndex, weaponUPGIndex, skillUPGIndex, weaponSkinIndex, weaponSkinPackIndex, weaponSkinPackSkinIndex, GrenadeIndex;

var AkBaseSoundObject selectSound, perkSound, skillSound, weaponSound;

enum ItemType
{
	ITP_WeaponSkin,
	ITP_CharacterSkin,
	ITP_KeyCrate,
	ITP_CraftingComponent,
	ITP_Item,
	ITP_NONE,
};

enum EWMINV_Filter
{
	EWMInv_Hide,
	EWMInv_All,
	EWMInv_Available,
	EWMInv_Bought,
};
var EWMINV_Filter CurrentPerkFilter;
var EWMINV_Filter CurrentSkillFilter;
var EWMINV_Filter CurrentWeaponFilter;

function InitializeMenu(WMUI_Menu Manag)
{	
	Manager = Manag;
	// check if player is using a controller
	SetBool("bUsingGamepad", class'WorldInfo'.static.IsConsoleBuild());
	
	CurrentFilterIndex = 1;
	CurrentBuyIndex = 0;
	CurrentBuyType = "";
	if (WMPlayerController(KFPC) != none)
	{
		CurrentPerkFilter = EWMINV_Filter(WMPlayerController(KFPC).UPG_PerkListIndex);
		CurrentSkillFilter = EWMINV_Filter(WMPlayerController(KFPC).UPG_SkillListIndex);
		CurrentWeaponFilter = EWMINV_Filter(WMPlayerController(KFPC).UPG_WeaponListIndex);
	}
	else
	{
		CurrentPerkFilter = EWMInv_All;
		CurrentSkillFilter = EWMInv_All;
		CurrentWeaponFilter = EWMInv_All;
	}
	UpdateText();
	ItemDetailsContainer = GetObject("itemDetailsContainer");
	EquipButton = ItemDetailsContainer.GetObject("equipButton");
	UpdateCraftButtons(); //check if player voted to skip trader time
}

function UpdateText()
{
	local GFxObject LocalizedObject;
	local GFxObject PerkList;
	local GFxObject SkillList;
	local GFxObject WeaponList;
	local GFxObject TempObject;

	LocalizedObject = GetObject("localizedText");
	if( LocalizedObject==None )
	{
		LocalizedObject = CreateObject( "Object" );
		LocalizedObject.SetString("noItems","");
		LocalizedObject.SetString("back", Class'KFCommon_LocalizedStrings'.default.BackString);
		LocalizedObject.SetString("ok", Class'KFCommon_LocalizedStrings'.default.OKString);
		LocalizedObject.SetString("equip","");
		LocalizedObject.SetString("unequip","");
		LocalizedObject.SetString("useString","");
		LocalizedObject.SetString("recycle","");
		LocalizedObject.SetString("inventory","Upgrade Menu");
		LocalizedObject.SetString("all","Upgrades List");
		LocalizedObject.SetString("weaponSkins","Grenades");
		LocalizedObject.SetString("cosmetics","Knives");
		LocalizedObject.SetString("emotes",""); 
		LocalizedObject.SetString("items","");
		LocalizedObject.SetString("filters","");
		LocalizedObject.SetString("craftWeapon","Skip Trader Time");
		LocalizedObject.SetString("craftCosmetic","Close Menu");
		LocalizedObject.SetString("craftingMats","");
		LocalizedObject.SetString("sfx"," ");
		
		LocalizedObject.SetString("filterName_0","Perk Upgrades"); 		
		LocalizedObject.SetString("filterName_1","Skill Upgrades"); 	
		LocalizedObject.SetString("filterName_2","Weapon Upgrades"); 	
		
		LocalizedObject.SetInt("filterIndex_0", int(CurrentPerkFilter) );
		LocalizedObject.SetInt("filterIndex_1", int(CurrentSkillFilter) );
		LocalizedObject.SetInt("filterIndex_2", int(CurrentWeaponFilter) );
		
		PerkList = CreateArray();
		SkillList = CreateArray();
		WeaponList = CreateArray();
		
		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Hide all");
		PerkList.SetElementObject(0, TempObject);
		SkillList.SetElementObject(0, TempObject);
		WeaponList.SetElementObject(0, TempObject);
		
		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Show All");
		PerkList.SetElementObject(1, TempObject);
		SkillList.SetElementObject(1, TempObject);
		WeaponList.SetElementObject(1, TempObject);
		
		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Availables");
		PerkList.SetElementObject(2, TempObject);
		SkillList.SetElementObject(2, TempObject);
		WeaponList.SetElementObject(2, TempObject);
		
		TempObject = CreateObject("Object");
		TempObject.SetString("label", "Boughts");
		PerkList.SetElementObject(3, TempObject);
		SkillList.SetElementObject(3, TempObject);
		WeaponList.SetElementObject(3, TempObject);
		
		LocalizedObject.SetObject("filterData_0", PerkList);
		LocalizedObject.SetObject("filterData_1", SkillList);	
		LocalizedObject.SetObject("filterData_2", WeaponList);
	}
	SetObject("localizedText", LocalizedObject);
}

function Callback_InventoryFilter( int FilterIndex )
{
	local GFxObject ItemArray, ItemObject;
	local int i,j;
	local int tempPrice;
	local int maxLevel;
	local string S;
	local bool bBought;
	local int lvl;
	local WMGameReplicationInfo WMGRI;
	local WMPlayerController WMPC;
	local WMPlayerReplicationInfo WMPRI;
	local WMPerk WMP;
	
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	WMPC = WMPlayerController(KFPC);
	CurrentFilterIndex = FilterIndex;
	ItemArray = CreateArray();
	j = 0;
	perkUPGLength=0;
	weaponUPGLength=0;
	skillUPGLength=0;
	perkUPGIndex.length=0;
	weaponUPGIndex.length=0;
	skillUPGIndex.length=0;
	
	weaponSkinIndex.length=0;
	weaponSkinPackIndex.length=0;
	weaponSkinPackSkinIndex.length=0;
	
	GrenadeIndex.length=0;
	
	if (FilterIndex==0) //Perk Upgrades
	{
		for(i=0;i<WMGRI.perkUpgrades.length;i+=1)
		{
			if (WMPRI.bPerkUpgradeAvailable[i] > 0)
			{
				lvl = WMPRI.bPerkUpgrade[i];
				if (CurrentBuyType=="perk" && CurrentBuyIndex==i)
					lvl = CurrentBuyLvl;
				
				// Get Max Level of that upgrade
				maxLevel = WMGRI.perkMaxLevel;
				
				// Is it fully bought?
				if (lvl >= maxLevel)
					bBought=true;
				else
					bBought=false;
				
				// Create info arch
				if (CurrentPerkFilter != EWMInv_Hide && ((CurrentPerkFilter == EWMInv_All) || (CurrentPerkFilter == EWMInv_Available && !bBought) || (CurrentPerkFilter == EWMInv_Bought && bBought)))
				{
					if (bBought)
						lvl -= 1;
					ItemObject = CreateObject("Object");
					
					tempPrice = WMGRI.perkPrice[lvl];
					ItemObject.SetInt("count", tempPrice);
					
					if (maxLevel > 1)
					{
						if (bBought)
							ItemObject.SetString("label", WMGRI.perkUpgrades[i].default.upgradeName $ " (" $ maxLevel $ "/" $ maxLevel $ ")");
						else
							ItemObject.SetString("label", WMGRI.perkUpgrades[i].default.upgradeName $ " (" $ lvl $ "/" $ maxLevel $ ")");
					}
					else
						ItemObject.SetString("label", WMGRI.perkUpgrades[i].default.upgradeName);
					
					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", false);
					ItemObject.SetBool("recyclable", false);
					ItemObject.SetInt("definition", j);
					if (bBought)
					{
						ItemObject.SetInt("type",1);
						ItemObject.SetBool("active", true);
						ItemObject.SetInt("rarity", 0);
					}
					else
					{
						if (KFPRI.Score < tempPrice)
							ItemObject.SetInt("type",1);
						else
							ItemObject.SetInt("type",0);
						ItemObject.SetBool("active", false);	
					}
					S = "img://"$PathName(WMGRI.perkUpgrades[i].static.GetupgradeIcon(lvl));
					ItemObject.SetString("description", GetUpgradeDescription(i, lvl, WMGRI, WMPRI));
					ItemObject.SetString("iconURLSmall", S);
					ItemObject.SetString("iconURLLarge", S);
					ItemArray.SetElementObject(j, ItemObject);
					perkUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	perkUPGLength = j;
	if (FilterIndex==0) //Skill Upgrades
	{
		for( i=0;i<WMGRI.skillUpgrades.Length;i+=1)
		{
			if (WMPRI.bSkillUnlocked[i] == 1 || (skillLastUnlocked-1) == i)
			{
				lvl = WMPRI.bSkillUpgrade[i];
				if (CurrentBuyType=="skill" && CurrentBuyIndex==i)
					lvl = CurrentBuyLvl;
				
				// Is it fully bought?
				if (lvl == 0)
					bBought=false;
				else
					bBought=true;

				// Create info arch
				if (CurrentSkillFilter != EWMInv_Hide && ((CurrentSkillFilter == EWMInv_All) || (CurrentSkillFilter == EWMInv_Available && !bBought) || (CurrentSkillFilter == EWMInv_Bought && bBought)))
				{
					if (bBought)
						lvl -= 1;
					ItemObject = CreateObject("Object");
					
					if (WMPRI.bSkillDeluxe[i] == 1)
					{
						ItemObject.SetString("label", WMGRI.skillUpgrades[i].default.upgradeName $ " [Deluxe]");
						ItemObject.SetString("description", WMGRI.skillUpgrades[i].default.upgradeDescription[1]);
						S = "img://"$PathName(WMGRI.skillUpgrades[i].static.GetupgradeIcon(1));
						tempPrice = WMGRI.skillDeluxePrice;
					}
					else
					{
						ItemObject.SetString("label", WMGRI.skillUpgrades[i].default.upgradeName);
						ItemObject.SetString("description", WMGRI.skillUpgrades[i].default.upgradeDescription[0]);
						S = "img://"$PathName(WMGRI.skillUpgrades[i].static.GetupgradeIcon(0));
						tempPrice = WMGRI.skillPrice;
					}
					ItemObject.SetInt("count", tempPrice);
					
					ItemObject.SetString("iconURLSmall", S);
					S = "img://"$PathName(WMGRI.skillUpgrades_Perk[i].static.GetupgradeIcon(0));
					ItemObject.SetString("iconURLLarge", S);
					
					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", false);
					ItemObject.SetBool("recyclable", false);
					ItemObject.SetInt("definition", j);
					if (bBought)
					{
						ItemObject.SetInt("type",1);
						ItemObject.SetBool("active", true);
						ItemObject.SetInt("rarity", 0);
						
					}
					else
					{
						if (KFPRI.Score < tempPrice)
							ItemObject.SetInt("type",1);
						else
							ItemObject.SetInt("type",0);
						ItemObject.SetBool("active", false);
					}

					ItemArray.SetElementObject(j, ItemObject);
					skillUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	skillUPGLength = j - perkUPGLength;
	if (FilterIndex==0) //Weapon Upgrades
	{
		for( i=0;i<WMGRI.weaponUpgrade_Weapon.Length;i+=1)
		{
			if (isWeaponInInventory(WMGRI.weaponUpgrade_Weapon[i]))
			{
				lvl = WMPRI.GetWeaponUpgrade(i);
				if (CurrentBuyType=="weapon" && CurrentBuyIndex==i)
					lvl = CurrentBuyLvl;
				
				maxLevel = WMGRI.weaponMaxLevel;
				
				// Is it fully bought?
				if (lvl >= maxLevel)
					bBought=true;
				else
					bBought=false;
				
				// Create info arch
				if (CurrentWeaponFilter != EWMInv_Hide && ((CurrentWeaponFilter == EWMInv_All) || (CurrentWeaponFilter == EWMInv_Available && !bBought) || (CurrentWeaponFilter == EWMInv_Bought && bBought)))
				{
					if (bBought)
						lvl -= 1;
					ItemObject = CreateObject("Object");
					ItemObject.SetInt("count", WMGRI.weaponUpgrade_Price[i] * (lvl+1));
					
					if (maxLevel > 1)
					{
						if (bBought)
							ItemObject.SetString("label", WMGRI.weaponUpgrade_Upgrade[i].default.upgradeName $ " (" $ maxLevel $ "/" $ maxLevel $ ")");
						else
							ItemObject.SetString("label", WMGRI.weaponUpgrade_Upgrade[i].default.upgradeName $ " (" $ lvl $ "/" $ maxLevel $ ")");
					}
					
					ItemObject.SetString("price", "");
					ItemObject.Setstring("typeRarity", "");
					ItemObject.SetBool("exchangeable", false);
					ItemObject.SetBool("recyclable", false);
					ItemObject.SetInt("definition", j);
					if (bBought)
					{
						ItemObject.SetInt("type",1);
						ItemObject.SetBool("active", true);
						ItemObject.SetInt("rarity", 0);
					}
					else
					{
						if (KFPRI.Score<WMGRI.weaponUpgrade_Price[i] * (lvl+1))
							ItemObject.SetInt("type",1);
						else
							ItemObject.SetInt("type",0);
						ItemObject.SetBool("active", false);
					}
					S = "img://"$PathName(WMGRI.weaponUpgrade_Weapon[i].default.WeaponSelectTexture);
					ItemObject.SetString("description", repl(WMGRI.weaponUpgrade_Upgrade[i].default.upgradeDescription[0], "%x%", WMGRI.weaponUpgrade_Upgrade[i].static.GetBonusValue(lvl + 1)));
					ItemObject.SetString("iconURLSmall", S);
					ItemObject.SetString("iconURLLarge", S);
					ItemArray.SetElementObject(j, ItemObject);
					weaponUPGIndex.AddItem(i);
					++j;
				}
			}
		}
	}
	weaponUPGLength = j - perkUPGLength - skillUPGLength;
	if (FilterIndex==1 && WMPC != none) //Grenades
	{
		for(i=0;i<WMGRI.Grenades.length;i+=1)
		{
			if (WMGRI.Grenades[i] != none)
			{
				ItemObject = CreateObject("Object");
				ItemObject.SetInt("count", 1);
				ItemObject.SetString("label", WMGRI.Grenades[i].static.GetItemName());
				ItemObject.SetString("description", "");
				ItemObject.SetString("iconURLSmall", "img://" $ WMGRI.Grenades[i].static.GetImagePath());
				ItemObject.SetString("iconURLLarge", "img://" $ WMGRI.Grenades[i].static.GetImagePath());
				ItemObject.SetString("price", "");
				ItemObject.Setstring("typeRarity", "");
				ItemObject.SetBool("exchangeable", false);
				ItemObject.SetBool("recyclable", false);
				ItemObject.SetInt("definition", j);
				ItemObject.SetInt("type",0);
				if (WMPC.CurrentPerk.GrenadeWeaponDef == WMGRI.Grenades[i])
					ItemObject.SetBool("active", true);
				else
					ItemObject.SetBool("active", false);
				ItemArray.SetElementObject(j, ItemObject);	
				GrenadeIndex.AddItem(i);
				j++;
			}
		}
	}
	else if (FilterIndex==2 && WMPC != none && WMPerk(WMPC.CurrentPerk) != none) //knives
	{
		WMP = WMPerk(WMPC.CurrentPerk);
		for(i=0;i<WMP.KnivesWeaponDef.length;i+=1)
		{
			ItemObject = CreateObject("Object");
			ItemObject.SetInt("count", 1);
			ItemObject.SetString("label", WMP.KnivesWeaponDef[i].static.GetItemName());
			ItemObject.SetString("description", "");
			ItemObject.SetString("iconURLSmall", "img://" $ WMP.KnivesWeaponDef[i].static.GetImagePath());
			ItemObject.SetString("iconURLLarge", "img://" $ WMP.KnivesWeaponDef[i].static.GetImagePath());
			ItemObject.SetString("price", "");
			ItemObject.Setstring("typeRarity", "");
			ItemObject.SetBool("exchangeable", false);
			ItemObject.SetBool("recyclable", false);
			ItemObject.SetInt("definition", j);
			ItemObject.SetInt("type",0);
			if (i == WMPC.KnifeIndex)
				ItemObject.SetBool("active", true);
			else
				ItemObject.SetBool("active", false);
			if (WMPC.KnifeIndex == i)
				ItemObject.SetInt("type",1);
			else
				ItemObject.SetInt("type",0);
			ItemArray.SetElementObject(j, ItemObject);	
			j++;
		}
	}
	
	SetObject("inventoryList", ItemArray);
}

function string GetUpgradeDescription(int index, int lvl, WMGameReplicationInfo WMGRI, WMPlayerReplicationInfo WMPRI)
{
	local string str, textColor;
	local bool bFirstSkill;
	local int i;
	
	// write list of passive bonuses
	if (WMGRI.perkUpgrades[index].default.upgradeDescription.length == 0)
		return "";
	else
		str = repl(WMGRI.perkUpgrades[index].default.upgradeDescription[0], "%x%", WMGRI.perkUpgrades[index].static.GetBonusValue(0, lvl + 1));

	for (i=1; i<WMGRI.perkUpgrades[index].default.upgradeDescription.length; i+=1)
	{
		str = str $ "\n" $ repl(WMGRI.perkUpgrades[index].default.upgradeDescription[i], "%x%", WMGRI.perkUpgrades[index].static.GetBonusValue(i, lvl + 1));
	}
	
	// write associated skills (and use different colors for locked, unlocked and bought skills)
	bFirstSkill = true;
	str = str $ "\n\n\n\n Buying this upgrade will unlocked one of these skills :\n";
	for (i=0; i<WMGRI.skillUpgrades.length; i+=1)
	{
		if (WMGRI.skillUpgrades_Perk[i] == WMGRI.perkUpgrades[index])
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
				str = str $ "\n   <font color=\"#" $textColor$ "\">" $WMGRI.skillUpgrades[i].default.upgradeName$ "</font>";
				bFirstSkill = false;
			}
			else
				str = str $ ", <font color=\"#" $textColor$ "\">" $WMGRI.skillUpgrades[i].default.upgradeName$ "</font>";
		}
	}
	if (!bFirstSkill)
		str = str $ ".";
	
	return str;

}

// 1) Perk Filter
function Callback_RarityTypeFilterChanged(int NewFilterIndex)
{
	CurrentPerkFilter = EWMINV_Filter(NewFilterIndex);
	if (WMPlayerController(KFPC) != none)
		WMPlayerController(KFPC).UPG_PerkListIndex = NewFilterIndex;
	Refresh();	
}

// 2) Skill Filter
function Callback_PerkTypeFilterChanged(int NewFilterIndex)
{
	CurrentSkillFilter = EWMINV_Filter(NewFilterIndex);
	if (WMPlayerController(KFPC) != none)
		WMPlayerController(KFPC).UPG_SkillListIndex = NewFilterIndex;
	Refresh();
}

// 3) Weapon Filter
function Callback_WeaponTypeFilterChanged(int NewFilterIndex)
{
	CurrentWeaponFilter = EWMINV_Filter(NewFilterIndex);
	if (WMPlayerController(KFPC) != none)
		WMPlayerController(KFPC).UPG_WeaponListIndex = NewFilterIndex;
	Refresh();
}

function bool isWeaponInInventory(class< KFWeapon > weaponClass)
{
	local KFWeapon Weapon;
	
	foreach Owner.InvManager.InventoryActors(class'KFWeapon',Weapon)
	{
		if ( ClassIsChildOf(Weapon.Class, weaponClass) && ClassIsChildOf(weaponClass, Weapon.Class) )
			return true;
		else if ( Weapon.DualClass != none && ClassIsChildOf(Weapon.DualClass, weaponClass) && ClassIsChildOf(weaponClass, Weapon.DualClass) )
			return true;
		else if ( KFWeap_DualBase(Weapon) != none && ClassIsChildOf(KFWeap_DualBase(Weapon).default.SingleClass, weaponClass) && ClassIsChildOf(weaponClass, KFWeap_DualBase(Weapon).default.SingleClass) )
			return true;
	}
	return false;
}

function CallBack_RequestWeaponCraftInfo() // Vote to skip trader
{
	local KFGameReplicationInfo KFGRI;
	
	KFGRI = KFGameReplicationInfo(KFPC.WorldInfo.GRI);
	if (KFPRI != none &&KFGRI != none && KFGRI.bTraderIsOpen)
		KFPRI.RequestSkiptTrader( KFPRI );
	
	//refresh button
	UpdateCraftButtons();
	
	Manager.CloseMenu();
}

function UpdateCraftButtons()
{
	local GFxObject ItemListContainer, CraftWeaponButton;
	
	ItemListContainer = GetObject("inventoryListContainer");
	if(ItemListContainer != none && KFPRI != none)
	{
		CraftWeaponButton = ItemListContainer.GetObject("craftWeaponsButton");
		if(CraftWeaponButton != none)
			CraftWeaponButton.SetBool("enabled", !KFPRI.bVotedToSkipTraderTime);
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
}

function Callback_RequestInitialnventory()
{
	Callback_InventoryFilter(0);
}

function CallBack_ItemDetailsClicked(int ItemDefinition)
{
	local int Index;
	local int lvl;
	local int price;
	local WMGameReplicationInfo WMGRI;
	local WMPlayerReplicationInfo WMPRI;
	
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	Index = ItemDefinition;
	
	if (Owner != none)
		Owner.PlaySoundBase(default.selectSound, true);
	
	//Upgrades
	if (CurrentFilterIndex==0)
	{
		if (Index>=(perkUPGLength+skillUPGLength) && weaponUPGLength>0)
		{
			Index = weaponUPGIndex[Index - perkUPGLength - skillUPGLength];
			lvl = WMPRI.GetWeaponUpgrade(index);
			EquipButton.SetString("label", ""$WMGRI.weaponUpgrade_Price[Index]*(lvl+1)$Chr(163));
		}
		else if (Index>=perkUPGLength)
		{
			Index = skillUPGIndex[Index - perkUPGLength];
			lvl = WMPRI.bSkillUpgrade[Index];
			
			if (WMPRI.bSkillDeluxe[Index] == 1)
				price = WMGRI.skillDeluxePrice;
			else
				price = WMGRI.skillPrice;
			EquipButton.SetString("label", ""$price$Chr(163));
		}
		else
		{
			Index = perkUPGIndex[Index];
			lvl = WMPRI.bPerkUpgrade[Index];
			price = WMGRI.perkPrice[lvl];

			EquipButton.SetString("label", ""$price$Chr(163));
		}
	}
	else if(CurrentFilterIndex==1 || CurrentFilterIndex==2)//Grenades and Knives
	{
		EquipButton.SetString("label", "Equip");
	}
}

function Callback_Equip( int ItemDefinition )
{
	local int Index;
	local int lvl;
	local int price;
	local int maxLevel;
	
	local WMGameReplicationInfo WMGRI;
	local WMPlayerController WMPC;
	local WMPlayerReplicationInfo WMPRI;
	
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	WMPC = WMPlayerController(KFPC);
	
	Index = ItemDefinition;
	
	//upgrades
	if (CurrentFilterIndex==0)
	{
		if (Index>=(perkUPGLength+skillUPGLength) && weaponUPGLength>0)
		{
			Index = weaponUPGIndex[Index - perkUPGLength - skillUPGLength];
			lvl = WMPRI.GetWeaponUpgrade(index);
			price = WMGRI.weaponUpgrade_Price[Index]*(lvl+1);
			if (KFPRI.Score >= price)
			{
				WMPC.BuyWeaponUpgrade(Index,price);
				KFPRI.Score -= price;
				WMPC.UpdateWeaponMagAndCap();
				if (WMPRI.purchase_weaponUpgrade.Find(Index) == -1)
					WMPRI.purchase_weaponUpgrade.AddItem(Index);
				CurrentBuyIndex=Index;
				CurrentBuyType="weapon";
				CurrentBuyLvl=lvl+1;
				if (Owner != none)
					Owner.PlaySoundBase(default.weaponSound, true);
			}
		}
		else if (Index>=perkUPGLength)
		{
			Index = skillUPGIndex[Index - perkUPGLength];
			lvl = WMPRI.bSkillUpgrade[Index];
			
			if (WMPRI.bSkillDeluxe[Index] == 1)
				price = WMGRI.skillDeluxePrice;
			else
				price = WMGRI.skillPrice;
			
			if (KFPRI.Score >= price)
			{
				WMPC.BuySkillUpgrade(Index, GetPerkRelatedIndex(Index), price, WMPRI.bSkillDeluxe[Index] + 1);
				KFPRI.Score -= price;
				if (WMPRI.purchase_skillUpgrade.Find(Index) == -1)
					WMPRI.purchase_skillUpgrade.AddItem(Index);
				CurrentBuyIndex=Index;
				CurrentBuyType="skill";
				CurrentBuyLvl=lvl + WMPRI.bSkillDeluxe[Index] + 1;
				if (Owner != none)
					Owner.PlaySoundBase(default.skillSound, true);
			}
		}
		else
		{
			Index = perkUPGIndex[Index];
			lvl = WMPRI.bPerkUpgrade[Index];
			price = WMGRI.perkPrice[lvl];
			maxLevel = WMGRI.perkMaxLevel;

			if (KFPRI.Score >= price)
			{
				WMPC.BuyPerkUpgrade(Index, price);
				KFPRI.Score -= price;
				if (WMPRI.purchase_perkUpgrade.Find(Index) == -1)
					WMPRI.purchase_perkUpgrade.AddItem(Index);
				CurrentBuyIndex=Index;
				CurrentBuyType="perk";
				CurrentBuyLvl=lvl+1;
				UnlockRandomSkill(WMGRI.perkUpgrades[Index], ((lvl+1) == maxLevel));
				if (Owner != none)
					Owner.PlaySoundBase(default.perkSound, true);
			}
		}
	}
	else if (CurrentFilterIndex==1) //Grenades
	{
		WMPC.ChangeGrenade(GrenadeIndex[Index]);
	}
	else if (CurrentFilterIndex==2) //Knives
	{
		WMPC.ChangeKnife(Index);
	}
	
	Refresh();
}

function int GetPerkRelatedIndex(int SkillIndex)
{
	//return Skill perk related index
	local byte i;
	local WMGameReplicationInfo WMGRI;
	
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	for (i=0; i<WMGRI.skillUpgrades_Perk.length; i+=1)
	{
		if (WMGRI.perkUpgrades[i] == WMGRI.skillUpgrades_Perk[SkillIndex])
			return i;
	}
	
	return 0;
}

function UnlockRandomSkill(Class< WMUpgrade_Perk > perkClass, bool bShouldBeDeluxe)
{
	local array< int > availableIndex;
	local int i, choice;
	local WMGameReplicationInfo WMGRI;
	local WMPlayerReplicationInfo WMPRI;
	
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	
	for (i=0;i<WMGRI.skillUpgrades.length;i+=1)
	{
		if (WMGRI.skillUpgrades_Perk[i] == perkClass && WMPRI.bSkillUnlocked[i] == 0)
			availableIndex.AddItem(i);
	}
	if (availableIndex.length > 0)
	{
		choice = Rand(availableIndex.length);
		WMPRI.bSkillUnlocked[availableIndex[choice]] = 1;
		if (bShouldBeDeluxe)
			WMPRI.bSkillDeluxe[availableIndex[choice]] = 1;
		else
			WMPRI.bSkillDeluxe[availableIndex[choice]] = 0;
		
		skillLastUnlocked = availableIndex[choice]+1;
		Refresh();
	}
}

defaultproperties
{
	selectSound = AkEvent'WW_UI_Menu.Play_TRADER_INVENTORY_ITEM_CLICK'
	weaponSound = AkEvent'WW_UI_Menu.Play_UI_Weapon_Upgrade'
	perkSound = AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Sell'
	skillSound = AkEvent'WW_UI_Menu.Play_UI_Trader_Item_Buy'
	Name="Default__WMUI_UPGMenu"
}
