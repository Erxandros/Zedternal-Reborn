Class WMWeaponPrecious_Helper extends Info;

const NAME_MAX_LENGTH = 24;

// Localization

static function string GetItemNameVariant(string defaultName, string customShortName)
{
	local string str;
	
	str = defaultName $ " [Precious]";
	if (Len(str) > NAME_MAX_LENGTH)
		return customShortName $ " [Precious]";
	
	return str;
}

static function SetupDroppedPickup( KFWeapon KFW, out DroppedPickup P, vector StartVelocity, int SkinId )
{
	local WMPreciousDroppedPickup X;

	if (ClassIsChildOf(P.class, class'ZedternalReborn.WMPreciousDroppedPickup'))
	{
		X = WMPreciousDroppedPickup(P);
		X.SetPhysics(PHYS_Falling);
		X.Inventory	= KFW;
		X.InventoryClass = KFW.class;
		X.Velocity = StartVelocity;
		X.Instigator = KFW.Instigator;
		X.PreciousSkinItemId = SkinId;
		X.SetPickupMesh(KFW.DroppedPickupMesh);
		X.SetPickupParticles(KFW.DroppedPickupParticles);
		P = X;
	}
	else
	{
		KFW.SetupDroppedPickup(P, StartVelocity);
	}
}


// Apply skin (we need to by-pass SkinItemId)

static simulated function VariantClientWeaponSet( KFWeapon KFW, int SkinId )
{
	local PlayerController PC;
	local int i;
	
	if ( KFW.Instigator != None && KFW.InvManager != None && KFW.WorldInfo.NetMode != NM_DedicatedServer )
	{
		PC = PlayerController(KFW.Instigator.Controller);
		if( PC != none && PC.myHUD != none )
		{
			KFW.InitFOV( PC.myHUD.SizeX, PC.myHUD.SizeY, PC.DefaultFOV );
		}
		for( i = 0; i < KFW.NumBloodMapMaterials; ++i )
		{
			KFW.WeaponMICs.AddItem( KFW.Mesh.CreateAndSetMaterialInstanceConstant(i) );
		}
		
		// Apply custom skin
		ApplyFirstPersonSkin( KFW.Mesh, SkinId );
		
	}
}

static function VariantSetOriginalValuesFromPickup( KFWeapon KFW, KFWeapon PickedUpWeapon, int SkinId )
{
	local byte i;
	local KFWeapon KFWInv;

	for (i = 0; i < 2; i++)
	{
		KFW.AmmoCount[i] = PickedUpWeapon.AmmoCount[i];
	}

	KFW.SpareAmmoCount[0] = PickedUpWeapon.SpareAmmoCount[0];

	if( KFW.DualClass != none )
	{
		foreach KFInventoryManager(KFW.InvManager).InventoryActors( class'KFWeapon', KFWInv )
		{
			if( KFWInv.Class == KFW.DualClass )
			{
				KFWInv.AmmoCount[0] -= KFW.default.MagazineCapacity[0] - KFW.AmmoCount[0];
				KFWInv.AmmoCount[1] -= KFW.default.MagazineCapacity[1] - KFW.AmmoCount[1];

				KFWInv.SpareAmmoCount[0] -= (KFW.default.InitialSpareMags[0] * KFW.default.MagazineCapacity[0]) - KFW.SpareAmmoCount[0];
				KFWInv.SpareAmmoCount[0] = Min( KFWInv.SpareAmmoCount[0], KFWInv.SpareAmmoCapacity[0] );

				KFWInv.ClientForceAmmoUpdate(KFWInv.AmmoCount[0],KFWInv.SpareAmmoCount[0]);
				KFWInv.ClientForceSecondaryAmmoUpdate(KFWInv.AmmoCount[1]);

				KFWInv.bGivenAtStart = PickedUpWeapon.bGivenAtStart;

				return;
			}
		}
	}
	
	KFW.ClientForceAmmoUpdate( KFW.AmmoCount[0], KFW.SpareAmmoCount[0] );
	KFW.ClientForceSecondaryAmmoUpdate( KFW.AmmoCount[1] );
	KFW.bGivenAtStart = PickedUpWeapon.bGivenAtStart;
	
	// Apply custom skin
	ApplyFirstPersonSkin( KFW.Mesh, SkinId );
}


static simulated function ApplyFirstPersonSkin( MeshComponent WeapMesh, int SkinId )
{
	local int i;
	local array<MaterialInterface> SkinMICs;

	SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(SkinId, WST_FirstPerson);
	for (i=0; i<SkinMICs.length; i++)
	{
		WeapMesh.SetMaterial( i, SkinMICs[i] );
	}
}

	
defaultproperties
{
}