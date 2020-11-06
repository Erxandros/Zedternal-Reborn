Class WMUpgrade_Skill_ExtraRounds extends WMUpgrade_Skill;

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

	upgradeName="Extra Rounds"
	upgradeDescription(0)="Increase the maximum ammo for <font color=\"#eaeff7\">all weapons</font> by 15%. Also increase the maximum ammo for <font color=\"#caab05\">Demolitionist's weapons</font> by 5 rounds"
	upgradeDescription(1)="Increase the maximum ammo for <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font>. Also increase the maximum ammo for <font color=\"#caab05\">Demolitionist's weapons</font> by <font color=\"#b346ea\">10</font> rounds"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ExtraRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_ExtraRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_ExtraRounds"
}
