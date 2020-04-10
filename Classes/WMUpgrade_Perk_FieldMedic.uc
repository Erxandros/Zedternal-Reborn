Class WMUpgrade_Perk_FieldMedic extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);
	
var float Damage;
var float Health;
var float HealRate;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk( MyKFW, class'KFgame.KFPerk_FieldMedic') || IsDamageTypeOnSpecificPerk( DamageType, class'KFgame.KFPerk_FieldMedic'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}
static function ModifyHealth( out int InHealth, int DefaultHealth, int upgLevel)
{
	InHealth += Round(float(DefaultHealth) * FMin(default.Health * upgLevel, 1.f));
}
static simulated function ModifyHealerRechargeTime( out float InRechargeTime, float DefaultRechargeTime, int upgLevel)
{
	InRechargeTime = DefaultRechargeTime / (DefaultRechargeTime/InRechargeTime + default.HealRate * upgLevel);
}

defaultproperties
{
	upgradeName="Medic"
	upgradeDescription(0)="+%x%% Max Health"
	upgradeDescription(1)="+%x%% Syringe and Healing Darts Recharge Rate"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Medic's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=5, maxValue=100)
	PerkBonus(1)=(baseValue=0, incValue=20, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	Damage=0.050000
	Health=0.050000
	HealRate=0.200000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Medic_Rank_5'
}