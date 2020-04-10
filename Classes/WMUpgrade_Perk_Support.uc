Class WMUpgrade_Perk_Support extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);
	
var float Penetration, LZDamage;
var float StoppingPower;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none && MyKFPM.bLargeZed)
		InDamage += Round(float(DefaultDamage) * default.LZDamage * upgLevel);
}

static function ModifyStumblePowerPassive( out float stumblePowerFactor, int upgLevel)
{
	stumblePowerFactor += default.StoppingPower * upgLevel;
}

static function ModifyKnockdownPowerPassive( out float knockdownPowerFactor, int upgLevel)
{
	knockdownPowerFactor += default.StoppingPower * upgLevel;
}

static simulated function ModifyPenetrationPassive( out float penetrationFactor, int upgLevel)
{
	penetrationFactor += default.Penetration * upgLevel;
}


defaultproperties
{
	upgradeName="Support"
	upgradeDescription(0)="+%x%% Stopping Power with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(1)="+%x%% Damage against Large Zeds with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Penetration with <font color=\"#caab05\">Support's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=10, maxValue=-1)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=50, maxValue=-1)
	Penetration=0.500000
	LZDamage=0.050000
	StoppingPower=0.100000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Support_Rank_5'
}