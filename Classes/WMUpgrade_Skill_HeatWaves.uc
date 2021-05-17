class WMUpgrade_Skill_HeatWaves extends WMUpgrade_Skill;

var array<float> Damage;
var float Stumble;
var array<int> RadiusSQ;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire_Ground'))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	if (OwnerPawn != None && KFP != None && VSizeSQ(OwnerPawn.Location - KFP.Location) <= default.RadiusSQ[upgLevel - 1])
		InStumblePower += DefaultStumblePower * default.Stumble;
}

static simulated function bool IsGroundFireActive(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Damage(0)=0.8f
	Damage(1)=2.0f
	Stumble=1.5f
	RadiusSQ(0)=90000
	RadiusSQ(1)=360000

	upgradeName="Heat Waves"
	upgradeDescription(0)="Increase stumble effect by 150% with <font color=\"#eaeff7\">all weapons</font> when firing at ZEDs within 3 meters of you and set ground fires that do 80% extra damage with <font color=\"#caab05\">Firebug flame weapons</font>"
	upgradeDescription(1)="Increase stumble effect by 150% with <font color=\"#eaeff7\">all weapons</font> when firing at ZEDs within <font color=\"#b346ea\">6</font> meters of you and set ground fires that do <font color=\"#b346ea\">200%</font> extra damage with <font color=\"#caab05\">Firebug flame weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves_Deluxe'

	Name="Default__WMUpgrade_Skill_HeatWaves"
}
