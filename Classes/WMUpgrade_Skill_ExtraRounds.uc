class WMUpgrade_Skill_ExtraRounds extends WMUpgrade_Skill;

var array<int> ExtraAmmo;
var array<float> ExtraAmmoPrct;

static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.ExtraAmmoPrct[upgLevel - 1];
}

static simulated function ModifySpareAmmoAmount(out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=False)
{
	if (IsWeaponOnSpecificPerk(KFW, class'KFPerk_Demolitionist'))
		InSpareAmmo += default.ExtraAmmo[upgLevel - 1];
}

defaultproperties
{
	ExtraAmmo(0)=5
	ExtraAmmo(1)=10
	ExtraAmmoPrct(0)=0.15f
	ExtraAmmoPrct(1)=0.4f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_ExtraRounds"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ExtraRounds'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ExtraRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_ExtraRounds"
}
