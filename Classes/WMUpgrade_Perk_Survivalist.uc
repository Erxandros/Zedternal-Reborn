Class WMUpgrade_Perk_Survivalist extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);

var float SpareAmmo, Damage;

static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel)
{
	damageFactor += default.Damage * upgLevel;
}

static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit, int upgLevel)
{
	InWeightLimit += upgLevel;
}

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.SpareAmmo * upgLevel;
}

defaultproperties
{
	SpareAmmo=0.2f
	Damage=0.03f

	upgradeName="Survivalist"
	upgradeDescription(0)="+%x% Weight Capacity"
	upgradeDescription(1)="+%x%% Spare Ammo with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#eaeff7\">any weapon</font>"
	PerkBonus(0)=(baseValue=0, incValue=1, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=20, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=3, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Survivalist_Rank_5'

	Name="Default__WMUpgrade_Perk_Survivalist"
}
