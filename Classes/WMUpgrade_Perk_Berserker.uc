Class WMUpgrade_Perk_Berserker extends WMUpgrade_Perk;

var float AttackSpeed, Damage, Defense;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Berserker') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Berserker'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Bludgeon') || ClassIsChildOf(DamageType, class'KFDT_Piercing') || ClassIsChildOf(DamageType, class'KFDT_Slashing'))
		InDamage -= Round(float(DefaultDamage) * FMin(default.Defense * upgLevel, 0.30f));
}

static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel)
{
	durationFactor = 1.0f / (1.0f / durationFactor + default.AttackSpeed * upgLevel);
}

static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.0f / (1.0f / rateOfFireFactor + default.AttackSpeed * upgLevel);
}

defaultproperties
{
	AttackSpeed=0.05f
	Damage=0.05f
	Defense=0.03f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Perk_Berserker"
	LocalizeDescriptionLineCount=3
	PerkBonus(0)=(baseValue=0, incValue=3, maxValue=30)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_5'

	Name="Default__WMUpgrade_Perk_Berserker"
}
