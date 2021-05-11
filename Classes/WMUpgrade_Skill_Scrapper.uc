class WMUpgrade_Skill_Scrapper extends WMUpgrade_Skill;

var array<float> Probability;

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	if (KFPC != None && KFPC.Pawn != None)
		AddAmmunition(KFPC.Pawn, upgLevel);
}

static function AddAmmunition(Pawn Player, int upgLevel)
{
	local KFWeapon KFW;
	local byte i;
	local int ExtraAmmo;

	if (Player != None && Player.Health > 0 && Player.InvManager != None && FRand() <= default.Probability[upgLevel - 1])
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if (KFW != KFWeapon(Player.Weapon))
			{
				for (i = 0; i < 2; ++i)
				{
					ExtraAmmo = Min(FCeil(float(KFW.GetMaxAmmoAmount(i)) / 50.0f), KFW.GetMaxAmmoAmount(i) - KFW.GetTotalAmmoAmount(i));
					if (ExtraAmmo > 0)
					{
						if (i == 0)
							KFW.AddAmmo(ExtraAmmo);
						else
						{
							KFW.AddSecondaryAmmo(ExtraAmmo);
							KFW.ClientForceSecondaryAmmoUpdate(KFW.AmmoCount[i]);
						}
					}
				}
			}
		}
	}
}

defaultproperties
{
	Probability(0)=0.125f
	Probability(1)=0.25f

	upgradeName="Scrapper"
	upgradeDescription(0)="Generate ammunition for your other weapons while killing ZEDs"
	upgradeDescription(1)="<font color=\"#b346ea\">Greatly</font> generate ammunition for your other weapons while killing ZEDs"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper_Deluxe'

	Name="Default__WMUpgrade_Skill_Scrapper"
}
