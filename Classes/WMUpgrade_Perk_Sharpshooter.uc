Class WMUpgrade_Perk_Sharpshooter extends WMUpgrade_Perk
	config(ZedternalReborn_Upgrade);

var float Damage;
var float DamageHead;
var float Recoil;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Sharpshooter') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Sharpshooter'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);

	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.DamageHead * upgLevel);
}

static simulated function ModifyRecoilPassive(out float recoilFactor, int upgLevel)
{
	recoilFactor -= default.Recoil * upgLevel;
}

defaultproperties
{
	Damage=0.05f
	DamageHead=0.05f
	Recoil=0.1f

	upgradeName="Sharpshooter"
	upgradeDescription(0)="-%x%% Recoil with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(1)="+%x%% Headshot Damage with <font color=\"#eaeff7\">any weapon</font>"
	upgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Sharpshooter's weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=10, maxValue=80)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_0'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_1'
	upgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_2'
	upgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_3'
	upgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_4'
	upgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_5'

	Name="Default__WMUpgrade_Perk_Sharpshooter"
}
