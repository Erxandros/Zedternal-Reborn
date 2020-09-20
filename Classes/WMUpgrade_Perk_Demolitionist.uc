Class WMUpgrade_Perk_Demolitionist extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);

var float Damage, GrenadeDamage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFgame.KFPerk_Demolitionist') || IsDamageTypeOnSpecificPerk(DamageType, class'KFgame.KFPerk_Demolitionist'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
	if (DamageType != none && isGrenadeDT(DamageType))
		InDamage += Round(float(DefaultDamage) * default.GrenadeDamage * upgLevel);
}

static simulated function ModifySpareGrenadeAmount(out int SpareGrenade, int DefaultSpareGrenade, int upgLevel)
{
	SpareGrenade += Min(upgLevel, 4);
}

static function bool isGrenadeDT(class<KFDamageType> DamageType)
{
	if (class< KFDT_Explosive_DynamiteGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Explosive_FlashBangGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_EMP_EMPGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Explosive_FragGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Explosive_HEGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Healing_MedicGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Fire_MolotovGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Freeze_FreezeGrenade >(DamageType) != none)
		return true;
	if (class< KFDT_Explosive_NailBombGrenade >(DamageType) != none)
		return true;
	return false;
}

defaultproperties
{
	upgradeName="Demolitionist"
	upgradeDescription(0)="+%x% Spare Grenades"
	upgradeDescription(1)="+%x%% Grenade Damage with <font color=\"#eaeff7\">any grenade</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Demolitionist's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=1, maxValue=4)
	PerkBonus(1)=(baseValue=0, incValue=10, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	Damage=0.050000
	GrenadeDamage=0.100000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_5'
}
