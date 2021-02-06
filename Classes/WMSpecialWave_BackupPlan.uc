class WMSpecialWave_BackupPlan extends WMSpecialWave;

var float MeleeDamage;

function PostBeginPlay()
{
	super.PostBeginPlay();
	UpdateWeapons();
	UpdatePickup();
}

function UpdateWeapons()
{
	// remove ammunition from each player
	ChangeAmmo(False);
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Bludgeon') || ClassIsChildOf(DamageType, class'KFDT_Piercing') || ClassIsChildOf(DamageType, class'KFDT_Slashing'))
		InDamage *= default.MeleeDamage;
}

function WaveEnded()
{
	// give full ammo to all players
	ChangeAmmo(True);
	super.WaveEnded();
}

function ChangeAmmo(bool bAdd)
{
	local KFWeapon W;
	local KFPawn_Human Player;
	local byte i;

	// add line to cycle through all players

	foreach DynamicActors(class'KFPawn_Human', Player)
	{
		if (Player != None && Player.Health > 0 && Player.InvManager != None)
		{
			foreach Player.InvManager.InventoryActors(class'KFWeapon', W)
			{
				for (i = 0; i < 2; ++i)
				{
					if (W.SpareAmmoCapacity[i] != 0)
					{
						if (bAdd)
							W.SpareAmmoCount[i] = W.SpareAmmoCapacity[i];
						else
							W.SpareAmmoCount[i] = 0;

						W.bNetDirty = True;
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
		KFG.ResetPickups(KFG.AmmoPickups, 0);
	}
}

defaultproperties
{
	MeleeDamage=3.0f
	zedSpawnRateFactor=0.9f
	doshFactor=0.9f // because we refill all weapons after the wave

	Title="Backup Plan"
	Description="No more ammo..."

	Name="Default__WMSpecialWave_BackupPlan"
}
