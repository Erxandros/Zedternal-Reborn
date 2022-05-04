Class WMUpgrade_Perk_Commando extends WMUpgrade_Perk;

var float Damage, ReloadRate;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Commando') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Commando'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static simulated function GetReloadRateScalePassive(out float reloadRateFactor, int upgLevel)
{
	reloadRateFactor = 1.0f / (1.0f / reloadRateFactor + default.ReloadRate * upgLevel);
}

static simulated function GetZedTimeExtension(out float InExtension, float DefaultExtension, int upgLevel)
{
	InExtension += float(Min(upgLevel, 10));
}

defaultproperties
{
	Damage=0.05f
	ReloadRate=0.15f

	UpgradeName="Commando"
	UpgradeDescription(0)="+%x%s. ZED Time Extension with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(1)="+%x%% Reload Speed with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Commando weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=1, maxValue=10)
	PerkBonus(1)=(baseValue=0, incValue=15, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Commando_Rank_5'

	Name="Default__WMUpgrade_Perk_Commando"
}
