Class WMUpgrade_Perk_Gunslinger extends WMUpgrade_Perk;

var float Damage, MoveSpeed, SwitchSpeed;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Gunslinger') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Gunslinger'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static simulated function ModifySpeedPassive(out float speedFactor, int upgLevel)
{
	speedFactor += default.MoveSpeed * upgLevel;
}

static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel)
{
	switchTimeFactor = 1.0f / (1.0f / switchTimeFactor + default.SwitchSpeed);
}

defaultproperties
{
	Damage=0.05f
	MoveSpeed=0.04f
	SwitchSpeed=0.2f

	upgradeName="Gunslinger"
	upgradeDescription(0)="+%x%% Movement Speed"
	upgradeDescription(1)="+%x%% Weapon Switch Speed with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Gunslinger's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=4, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=20, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_5'

	Name="Default__WMUpgrade_Perk_Gunslinger"
}
