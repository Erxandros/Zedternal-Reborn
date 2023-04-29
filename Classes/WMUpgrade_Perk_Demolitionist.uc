Class WMUpgrade_Perk_Demolitionist extends WMUpgrade_Perk;

var float Damage, GrenadeDamage, LZDamage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Demolitionist') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Demolitionist'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);

	if (DamageType != None && static.IsGrenadeDTAdvance(DamageType, DamageInstigator))
		InDamage += Round(float(DefaultDamage) * default.GrenadeDamage * upgLevel);

	if (MyKFPM != None && (MyKFPM.static.IsLargeZed() || MyKFPM.static.IsABoss()))
		InDamage += Round(float(DefaultDamage) * default.LZDamage * upgLevel);
}

defaultproperties
{
	Damage=0.05f
	GrenadeDamage=0.15f
	LZDamage=0.05f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Perk_Demolitionist"
	LocalizeDescriptionLineCount=3
	PerkBonus(0)=(baseValue=0, incValue=15, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Demolition_Rank_5'

	Name="Default__WMUpgrade_Perk_Demolitionist"
}
