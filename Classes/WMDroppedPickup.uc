class WMDroppedPickup extends KFDroppedPickup;

function GiveTo(Pawn P)
{
	local KFWeapon KFW;
	local class<KFWeapon> KFWInvClass;
	local Inventory NewInventory;
	local KFPerk KFP;
	local WMInventoryManager WMIM;
	local WMGameReplicationInfo WMGRI;
	local class<Inventory> NewInventoryClass;
	local name OwnedSidearmName, WeaponName;
	local int i;

	NewInventoryClass = InventoryClass;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	if (WMGRI != None && WMGRI.bIsEndlessPaused)
		return;

	if (KFPawn(P) != None)
		KFP = KFPawn(P).GetPerk();

	WMIM = WMInventoryManager(P.InvManager);
	if (WMIM != None)
	{
		if (WMIM.Is9mmInInventory())
		{
			if (InventoryClass.Name == 'KFWeap_HRG_93R')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'KFGame.KFWeapDef_9mm'.default.WeaponClassPath, class'Class'));
			else if (InventoryClass.Name == 'KFWeap_HRG_93R_Dual')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'KFGame.KFWeapDef_9mmDual'.default.WeaponClassPath, class'Class'));
		}
		else
		{
			if(InventoryClass.Name == 'KFWeap_Pistol_9mm')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'KFGame.KFWeapDef_HRG_93R'.default.WeaponClassPath, class'Class'));
			else if (InventoryClass.Name == 'KFWeap_Pistol_Dual9mm')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'KFGame.KFWeapDef_HRG_93R_Dual'.default.WeaponClassPath, class'Class'));
		}

		if (WMIM.IsPrecious9mmInInventory())
		{
			if (InventoryClass.Name == 'WMWeap_HRG_93R_Precious')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'ZedternalReborn.WMWeapDef_9mm_Precious'.default.WeaponClassPath, class'Class'));
			else if (InventoryClass.Name == 'WMWeap_HRG_93R_Dual_Precious')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'ZedternalReborn.WMWeapDef_9mmDual_Precious'.default.WeaponClassPath, class'Class'));
		}
		else
		{
			if(InventoryClass.Name == 'WMWeap_Pistol_9mm_Precious')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'ZedternalReborn.WMWeapDef_HRG_93R_Precious'.default.WeaponClassPath, class'Class'));
			else if (InventoryClass.Name == 'WMWeap_Pistol_Dual9mm_Precious')
				NewInventoryClass = class<Weapon>(DynamicLoadObject(class'ZedternalReborn.WMWeapDef_HRG_93R_Dual_Precious'.default.WeaponClassPath, class'Class'));
		}

		KFWInvClass = class<KFWeapon>(NewInventoryClass);
		if (WMGRI != None && KFP != None)
		{
			OwnedSidearmName = Name(Split(KFP.GetSecondaryWeaponClassPath(), ".", True));
			for (i = 0; i < WMGRI.SidearmsList.Length; ++i)
			{
				WeaponName = Name(Split(WMGRI.SidearmsList[i].Sidearm.default.WeaponClassPath, ".", True));
				if (NewInventoryClass.Name == WeaponName)
				{
					if (NewInventoryClass.Name == OwnedSidearmName)
						break;

					return;
				}

				if (KFWInvClass != None && KFWInvClass.default.DualClass.Name == WeaponName)
				{
					if (KFWInvClass.default.DualClass.Name == OwnedSidearmName)
						break;

					return;
				}
			}
		}

		foreach WMIM.InventoryActors(class'KFWeapon', KFW)
		{
			if (KFW.Class == NewInventoryClass)
			{
				if (KFW.DualClass == None)
				{
					PlayerController(P.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_AlreadyCarryingWeapon);
					return;
				}
				break;
			}
			else if (KFWInvClass != None && KFW.Class == KFWInvClass.default.DualClass)
			{
				PlayerController(P.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_AlreadyCarryingWeapon);
				return;
			}
		}

		if (KFWInvClass != None && KFWeapon(Inventory) != None && !WMIM.CanCarryWeapon(KFWInvClass, KFWeapon(Inventory).CurrentWeaponUpgradeIndex))
		{
			PlayerController(P.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_TooMuchWeight);
			return;
		}

		NewInventory = WMIM.CreateInventory(NewInventoryClass, True);
		if (NewInventory != None)
		{
			KFW = KFWeapon(NewInventory);
			if (KFW != None)
			{
				if (PreviousOWner != None)
					KFW.KFPlayer = PreviousOwner;

				KFW.SetOriginalValuesFromPickup(KFWeapon(Inventory));
				KFW = WMIM.CombineWeaponsOnPickup(KFW);
				KFW.NotifyPickedUp();
			}

			Destroy();
		}
	}

	if (Role == ROLE_Authority)
		NotifyHUDofWeapon(P);
}

simulated event SetPickupSkin(int ItemId, bool bFinishedLoading = false)
{
	local array<MaterialInterface> SkinMICs;

	if (ItemId > 0 && WorldInfo.NetMode != NM_DedicatedServer && !bWaitingForWeaponSkinLoad)
	{
		if (bFinishedLoading || !StartLoadPickupSkin(ItemId))
		{
			SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(ItemId, WST_Pickup);
			if (SkinMICs.Length > 0)
				MyMeshComp.SetMaterial(0, SkinMICs[0]);
		}
	}

	if (IsPreciousVariant())
		SetUpgradedMaterial();

	if (bEmptyPickup)
		SetEmptyMaterial();
}

function bool IsPreciousVariant()
{
	if (Len(InventoryClass.Name) >= 8)
		return Right(InventoryClass.Name, 8) ~= "Precious";

	return False;
}

defaultproperties
{
	Name="Default__WMDroppedPickup"
}
