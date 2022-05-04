Class WMUpgrade_Perk_Sharpshooter extends WMUpgrade_Perk;

var float Damage, DamageHead, Recoil;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (IsWeaponOnSpecificPerk(MyKFW, class'KFGame.KFPerk_Sharpshooter') || IsDamageTypeOnSpecificPerk(DamageType, class'KFGame.KFPerk_Sharpshooter'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);

	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.DamageHead * upgLevel);
}

static simulated function ModifyRecoilPassive(out float recoilFactor, int upgLevel)
{
	recoilFactor -= recoilFactor * FMin(default.Recoil * upgLevel, 0.8f);
}

defaultproperties
{
	Damage=0.05f
	DamageHead=0.05f
	Recoil=0.1f

	UpgradeName="Sharpshooter"
	UpgradeDescription(0)="-%x%% Recoil with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(1)="+%x%% Headshot Damage with <font color=\"#eaeff7\">any weapon</font>"
	UpgradeDescription(2)="+%x%% Damage with <font color=\"#caab05\">Sharpshooter weapons</font>"
	PerkBonus(0)=(baseValue=0, incValue=8, maxValue=80)
	PerkBonus(1)=(baseValue=0, incValue=5, maxValue=-1)
	PerkBonus(2)=(baseValue=0, incValue=5, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_0'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_1'
	UpgradeIcon(2)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_2'
	UpgradeIcon(3)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_3'
	UpgradeIcon(4)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_4'
	UpgradeIcon(5)=Texture2D'ZedternalReborn_Resource.Perks.UI_Perk_Sharpshooter_Rank_5'

	Name="Default__WMUpgrade_Perk_Sharpshooter"
}
