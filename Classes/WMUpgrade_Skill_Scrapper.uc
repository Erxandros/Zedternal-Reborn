class WMUpgrade_Skill_Scrapper extends WMUpgrade_Skill;

var array<float> Probability;

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	if (KFPC.Pawn != None)
		AddAmmunition(KFPC.Pawn, upgLevel);
}

static function AddAmmunition(Pawn Player, int upgLevel)
{
	local KFWeapon KFW;
	local byte i;
	local int ExtraAmmo;

	if (Player != None && Player.Health > 0 && Player.InvManager != None)
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			for (i = 0; i < 2; ++i)
			{
				if (KFW != KFWeapon(Player.Weapon))
				{
					if (KFW.SpareAmmoCount[i] < KFW.SpareAmmoCapacity[i] && FRand() <= float(KFW.SpareAmmoCapacity[i]) * default.Probability[upgLevel - 1])
					{
						ExtraAmmo = Max(Round(float(KFW.SpareAmmoCapacity[i]) * default.Probability[upgLevel - 1]), 1);
						if (i == 0)
							KFW.AddAmmo(ExtraAmmo);
						else
							KFW.AddSecondaryAmmo(ExtraAmmo);
					}
					else if (i == 1 && KFW.AmmoCount[i] < KFW.MagazineCapacity[i] && FRand() <= float(KFW.MagazineCapacity[i]) * default.Probability[upgLevel - 1])
					{
						ExtraAmmo = Max(Round(float(KFW.MagazineCapacity[i]) * default.Probability[upgLevel - 1]), 1);
						KFW.AddSecondaryAmmo(ExtraAmmo);
					}
				}
			}
		}
	}
}

defaultproperties
{
	Probability(0)=0.01f
	Probability(1)=0.025f

	upgradeName="Scrapper"
	upgradeDescription(0)="Generate ammunition for your other weapons while killing ZEDs"
	upgradeDescription(1)="<font color=\"#b346ea\">Greatly</font> generate ammunition for your other weapons while killing ZEDs"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper_Deluxe'

	Name="Default__WMUpgrade_Skill_Scrapper"
}
