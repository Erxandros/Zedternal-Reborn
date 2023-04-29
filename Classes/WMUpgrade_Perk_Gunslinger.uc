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
	SwitchSpeed=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Perk_Gunslinger"
	LocalizeDescriptionLineCount=3
	PerkBonus(0)=(baseValue=0, incValue=4, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=25, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Gunslinger_Rank_5'

	Name="Default__WMUpgrade_Perk_Gunslinger"
}
