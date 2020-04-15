Class WMUpgrade_Skill_ExtraRounds extends WMUpgrade_Skill;
	
var array<int> extraAmmo, extraAmmoPrct;

static simulated function ModifySpareAmmoAmountPassive( out float spareAmmoFactor, int upgLevel)
{
	spareAmmoFactor += default.extraAmmoPrct[upgLevel-1];
}

static simulated function ModifySpareAmmoAmount( out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=false )
{
	InSpareAmmo += default.extraAmmo[upgLevel-1];
}

defaultproperties
{
	upgradeName="Extra Rounds"
	upgradeDescription(0)="Increase the maximum ammo for <font color=\"#eaeff7\">all weapons</font> by 15%. Also Increase the maximum ammo for <font color=\"#caab05\">Demolitionist's weapons</font> by 5 rounds"
	upgradeDescription(1)="Increase the maximum ammo for <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font>. Also increase the maximum ammo for <font color=\"#caab05\">Demolitionist's weapons</font> by <font color=\"#b346ea\">10</font> rounds"
	extraAmmo(0)=5
	extraAmmo(1)=10
	extraAmmoPrct(0)=0.150000
	extraAmmoPrct(1)=0.400000
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ExtraRounds'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_ExtraRounds_Deluxe'
}