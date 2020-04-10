Class WMUpgrade_Skill_Safeguard extends WMUpgrade_Skill;
	
var array<float> Syringe, Recharge;

static function ModifyHealAmountPassive( out float healAmountFactor, int upgLevel)
{
	healAmountFactor += default.Syringe[upgLevel-1];
}

static simulated function ModifyHealerRechargeTime( out float InRechargeTime, float DefaultRechargeTime, int upgLevel)
{
	InRechargeTime += DefaultRechargeTime * default.Recharge[upgLevel-1];
}

defaultproperties
{
	upgradeName="Safe Guard"
	upgradeDescription(0)="Increase syringe potency and recharge rate by 20%"
	upgradeDescription(1)="Increase syringe potency and recharge rate by <font color=\"#b346ea\">50%</font>"
	Syringe(0)=0.200000;
	Syringe(1)=0.500000;
	Recharge(0)=0.2000000;
	Recharge(1)=0.5000000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Safeguard'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Safeguard_Deluxe'
}