Class WMUpgrade_Perk_Berserker extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);
	
var float Damage;
var float Defense;
var float Health;
var float MeleeAttackSpeed;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{	
	if (IsWeaponOnSpecificPerk( MyKFW, class'KFgame.KFPerk_Berserker') || IsDamageTypeOnSpecificPerk( DamageType, class'KFgame.KFPerk_Berserker'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (class<KFDT_Bludgeon>(DamageType) != none || class<KFDT_Piercing>(DamageType) != none || class<KFDT_Slashing>(DamageType) != none)
		InDamage -= Round(float(DefaultDamage) * FMin(default.Defense * upgLevel, 0.150000));
}
static simulated function ModifyMeleeAttackSpeedPassive( out float durationFactor, int upgLevel)
{
	durationFactor = 1.f / (1.f/durationFactor + default.MeleeAttackSpeed * upgLevel);
}
static simulated function ModifyRateOfFirePassive( out float rateOfFireFactor, int upgLevel)
{
	rateOfFireFactor = 1.f / (1.f/rateOfFireFactor + default.MeleeAttackSpeed * upgLevel);
}

defaultproperties
{
	upgradeName="Berserker"
	upgradeDescription(0)="+%x%% Melee Damage Resistance"
	upgradeDescription(1)="+%x%% Melee Attack Speed and Rate of Fire with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Berserker's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=5, maxValue=15)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	Damage=0.050000
	Defense=0.050000
	MeleeAttackSpeed=0.050000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Berserker_Rank_5'
}