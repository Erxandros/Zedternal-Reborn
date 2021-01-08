class WMUpgrade_Skill_Zedatif extends WMUpgrade_Skill;

var float Snare;
var array<float> Bonus;

static function ModifySnarePower(out float InSnarePower, float DefaultSnarePower, int upgLevel, optional class<DamageType> DamageType, optional byte BodyPart)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Toxic'))
		InSnarePower += DefaultSnarePower * default.Snare;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Toxic'))
		InDamage += int(float(DefaultDamage) * default.Bonus[upgLevel - 1]);
}

static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Bonus[upgLevel - 1];
}

defaultproperties
{
	Snare=30.0f
	Bonus(0)=0.25f
	Bonus(1)=0.6f

	upgradeName="Zedatif"
	upgradeDescription(0)="Toxic effects slowdown ZEDs. Also increase toxic damage and syringe potency by 25%"
	upgradeDescription(1)="Toxic effects slowdown ZEDs. Also increase toxic damage and syringe potency by <font color=\"#b346ea\">60%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Zedatif'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Zedatif_Deluxe'

	Name="Default__WMUpgrade_Skill_Zedatif"
}
