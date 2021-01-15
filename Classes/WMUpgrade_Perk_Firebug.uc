Class WMUpgrade_Perk_Firebug extends WMUpgrade_Perk;

var float Ammo, Damage, Defense;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Firebug') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Firebug'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire') || ClassIsChildOf(DamageType, class'KFDT_Explosive') || ClassIsChildOf(DamageType, class'KFDT_Toxic') || ClassIsChildOf(DamageType, class'KFDT_Sonic'))
		InDamage -= Round(float(DefaultDamage) * FMin(default.Defense * upgLevel, 0.4f));
}

static function WaveEnd(int upgLevel, KFPlayerController KFPC)
{
	local KFWeapon W;
	local KFPawn Player;
	local byte i;
	local int extraAmmo;

	Player = KFPawn(KFPC.Pawn);

	if (Player != None && Player.Health > 0 && Player.InvManager != None)
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon', W)
		{
			for(i = 0; i < 2; ++i)
			{
				if(W.SpareAmmoCount[i] < W.SpareAmmoCapacity[i])
				{
					extraAmmo = Round(float(W.SpareAmmoCapacity[i]) * FMin(default.Ammo * upgLevel, 0.4f));
					if (i == 0)
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
	Ammo=0.1f
	Damage=0.05f
	Defense=0.05f

	upgradeName="FireBug"
	upgradeDescription(0)="+%x%% Fire, Explosive, Bloat Bile and Siren Sonic Damage Resistance"
	upgradeDescription(1)="+%x%% Ammo Refill after completing a wave with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Firebug's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=5, maxValue=40)
	PerkBonus(1)=(baseValue=0, incValue=10, maxValue=40)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Firebug_Rank_5'

	Name="Default__WMUpgrade_Perk_Firebug"
}
