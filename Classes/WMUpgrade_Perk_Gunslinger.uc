Class WMUpgrade_Perk_Gunslinger extends WMUpgrade_Perk
	config(Zedternal_Upgrade);
	
var float Damage;
var float Speed;
var float Switch;

	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFgame.KFPerk_Gunslinger') || IsDamageTypeOnSpecificPerk( DamageType, class'KFgame.KFPerk_Gunslinger'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}
static simulated function ModifySpeedPassive( out float speedFactor, int upgLevel)
{
	speedFactor += default.Speed * upgLevel;
}
static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel)
{
	switchTimeFactor = 1.f / (1.f/switchTimeFactor + default.Switch);
}

defaultproperties
{
	upgradeName="Gunslinger"
	upgradeDescription(0)="+%x%% Movement Speed"
	upgradeDescription(1)="+%x%% Weapon Switch Speed with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Gunslinger's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=4, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=20, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	Damage=0.050000
	Speed=0.040000
	Switch=0.200000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_0'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_1'
	upgradeIcon(2)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_2'
	upgradeIcon(3)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_3'
	upgradeIcon(4)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_4'
	upgradeIcon(5)=Texture2D'Zedternal_Resource.Perks.UI_Perk_Gunslinger_Rank_5'
}