Class WMUpgrade_Perk_Support extends WMUpgrade_Perk;

var float Damage, Penetration, StoppingPower;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Support') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Support'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static function ModifyStumblePowerPassive(out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.StoppingPower * upgLevel;
}

static function ModifyKnockdownPowerPassive(out float knockdownPowerFactor, int upgLevel)
{
	knockdownPowerFactor += default.StoppingPower * upgLevel;
}

static simulated function ModifyPenetrationPassive(out float penetrationFactor, int upgLevel)
{
	penetrationFactor += default.Penetration * upgLevel;
}

defaultproperties
{
	Damage=0.05f
	Penetration=0.35f
	StoppingPower=0.1f

	UpgradeName="Support"
	UpgradeDescription(0)="+%x%% Stopping Power with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(1)="+%x%% Penetration with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Support weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=35, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_5'

	Name="Default__WMUpgrade_Perk_Support"
}
