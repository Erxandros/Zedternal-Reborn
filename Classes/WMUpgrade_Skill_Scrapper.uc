class WMUpgrade_Skill_Scrapper extends WMUpgrade_Skill;

var float AmmoDivider;
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
					ExtraAmmo = Min(FCeil(float(KFW.GetMaxAmmoAmount(i)) / default.AmmoDivider), KFW.GetMaxAmmoAmount(i) - KFW.GetTotalAmmoAmount(i));
					if (ExtraAmmo > 0)
					{
						if (i == 0)
							KFW.AddAmmo(ExtraAmmo);
						else
							KFW.AddSecondaryAmmo(ExtraAmmo);
					}
				}
			}
		}
	}
}

defaultproperties
{
	AmmoDivider=40.0f
	Probability(0)=0.125f
	Probability(1)=0.25f

	upgradeName="Scrapper"
	upgradeDescription(0)="12.5% chance to generate a chunk of ammo for your unequipped weapons after killing a ZED"
	upgradeDescription(1)="<font color=\"#b346ea\">25%</font> chance to generate a chunk of ammo for your unequipped weapons after killing a ZED"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper_Deluxe'

	Name="Default__WMUpgrade_Skill_Scrapper"
}
