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
	local KFWeapon KFW;
	local WMPawn_Human Player;

	foreach DynamicActors(class'WMPawn_Human', Player)
	{
		if (Player != None && Player.Health > 0 && Player.InvManager != None)
		{
			foreach Player.InvManager.InventoryActors(class'KFWeapon', KFW)
			{
				if (KFWeap_Healer_Syringe(KFW) == None && KFWeap_Welder(KFW) == None)
				{
					if (bAdd)
					{
						KFW.AddAmmo(KFW.GetMaxAmmoAmount(0));
						KFW.AddSecondaryAmmo(KFW.GetMaxAmmoAmount(1));
					}
					else
					{
						KFW.SpareAmmoCount[0] = 0;
						if (KFW.CanRefillSecondaryAmmo())
						{
							KFW.AmmoCount[1] = 0;
							KFW.SpareAmmoCount[1] = 0;
						}
					}
				}
			}

			if (!bAdd)
				Player.ClearAllAmmoClient(False);
		}
	}
}

function UpdatePickup()
{
	local WMGameInfo_Endless WMG;

	foreach DynamicActors(class'ZedternalReborn.WMGameInfo_Endless', WMG)
	{
		WMG.ResetPickups(WMG.AmmoPickups, 1 + WMG.WaveNum / 15);
	}
}

defaultproperties
{
	MeleeDamage=3.0f
	ZedSpawnRateFactor=0.9f
	DoshFactor=0.9f // because we refill all weapons after the wave

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_BackupPlan"

	Name="Default__WMSpecialWave_BackupPlan"
}
