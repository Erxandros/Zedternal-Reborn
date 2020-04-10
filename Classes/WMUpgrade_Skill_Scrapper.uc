Class WMUpgrade_Skill_Scrapper extends WMUpgrade_Skill;

var array<float> Prob;

static function AddVampireHealth( out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT )
{
	if (KFPawn(KFPC.Pawn) != none)
		AddAmmunition(KFPawn(KFPC.Pawn), upgLevel);
}

static function AddAmmunition(KFPawn Player, int upgLevel)
{
	local KFWeapon W;
	local byte i;
	local int extraAmmo;
	
	if( Player!=None && Player.Health>0 && Player.InvManager!=None )
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon',W)
		{
			for(i=0;i<2;++i)
			{
				if(W != KFWeapon(Player.Weapon) && W.SpareAmmoCount[i] < W.SpareAmmoCapacity[i] && FRand() <= float(W.SpareAmmoCapacity[i]) * default.Prob[upgLevel-1])
				{
					extraAmmo = Max(Round(float(W.SpareAmmoCapacity[i]) * default.Prob[upgLevel-1]), 1);
					if (i==0)
						W.AddAmmo(extraAmmo);
					else
					{
						W.AddSecondaryAmmo(extraAmmo);
						W.ClientForceSecondaryAmmoUpdate(W.AmmoCount[i]);
					}
				}
			}
		}
	}
}

defaultproperties
{
	upgradeName="Scrapper"
	upgradeDescription(0)="Generate ammunition for your other weapons while killing ZEDs"
	upgradeDescription(1)="<font color=\"#b346ea\">Greatly</font> generate ammunition for your other weapons while killing ZEDs"
	Prob(0)=0.010000
	Prob(1)=0.025000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Scrapper_Deluxe'
}