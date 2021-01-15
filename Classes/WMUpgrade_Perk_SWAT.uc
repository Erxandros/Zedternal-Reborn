Class WMUpgrade_Perk_SWAT extends WMUpgrade_Perk;

var float Damage;
var float Armor;
var float MagSize;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_SWAT') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_SWAT'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static function ModifyArmor(out byte MaxArmor, byte DefaultArmor, int upgLevel)
{
	MaxArmor += Min(Round(float(DefaultArmor) * default.Armor * upgLevel), 150);
}

static simulated function ModifyMagSizeAndNumberPassive(out float magazineCapacityFactor, int upgLevel)
{
	magazineCapacityFactor += default.MagSize * upgLevel;
}

defaultproperties
{
	Damage=0.05f
	Armor=0.1f
	MagSize=0.1f

	upgradeName="SWAT"
	upgradeDescription(0)="+%x%% Max Armor"
	upgradeDescription(1)="+%x%% Mag Size with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">SWAT's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=10, maxValue=100)
	PerkBonus(1)=(baseValue=0, incValue=10, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_SWAT_Rank_5'

	Name="Default__WMUpgrade_Perk_SWAT"
}
