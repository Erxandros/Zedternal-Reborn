Class WMUpgrade_Perk_Demolitionist extends WMUpgrade_Perk;

var float Damage, GrenadeDamage, LZDamage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Demolitionist') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Demolitionist'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);

	if (DamageType != None && static.IsGrenadeDT(DamageType))
		InDamage += Round(float(DefaultDamage) * default.GrenadeDamage * upgLevel);

	if (MyKFPM != None && MyKFPM.bLargeZed)
		InDamage += Round(float(DefaultDamage) * default.LZDamage * upgLevel);
}

defaultproperties
{
	Damage=0.05f
	GrenadeDamage=0.1f
	LZDamage=0.05f

	upgradeName="Demolitionist"
	upgradeDescription(0)="+%x%% Grenade Damage with <font color=\"#eaeff7\">any grenade</font>"
	upgradeDescription(1)="+%x%% Damage against Large Zeds with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Demolitionist's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_5'

	Name="Default__WMUpgrade_Perk_Demolitionist"
}
