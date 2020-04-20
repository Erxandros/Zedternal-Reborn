class WMSpecialWave_BackupPlan extends WMSpecialWave;

var float meleeDamage;

function PostBeginPlay()
{
	UpdateWeapons();
	UpdatePickup();
	super.PostBeginPlay();
}

function UpdateWeapons()
{
	// remove ammunition for each player
	ChangeAmmo( false );
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (class<KFDT_Bludgeon>(DamageType) != none || class<KFDT_Piercing>(DamageType) != none || class<KFDT_Slashing>(DamageType) != none)
		InDamage *= default.meleeDamage;
}

function WaveEnded()
{
	// give full ammo to all players
	ChangeAmmo( true );
}

function ChangeAmmo(bool bAdd)
{
	local KFWeapon W;
	local KFPawn_Human Player;
	local byte i;
	
	// add line to cycle through all players
	
	foreach DynamicActors(class'KFPawn_Human', Player)
	{
		if( Player!=None && Player.Health>0 && Player.InvManager!=None )
		{
			foreach Player.InvManager.InventoryActors(class'KFWeapon',W)
			{
				for(i=0;i<2;++i)
				{
					if(W.SpareAmmoCapacity[i] != 0)
					{
						if (bAdd)
							W.SpareAmmoCount[i] = W.SpareAmmoCapacity[i];
						else
							W.SpareAmmoCount[i] = 0;
						W.bNetDirty = true;
					}
				}
			}
		}
	}
}

function UpdatePickup()
{
	local KFGameInfo KFG;
	
	foreach DynamicActors(class'KFGame.KFGameInfo', KFG)
	{
		KFG.ResetPickups( KFG.AmmoPickups, 0 );
	}
}

defaultproperties
{
   Title="Backup Plan"
   Description="No more ammo..."
   zedSpawnRateFactor=0.900000
   doshFactor=0.9000000 // because we refill all weapons after the wave
   meleeDamage=3.000000
   Name="Default__WMSpecialWave_BackupPlan"
}