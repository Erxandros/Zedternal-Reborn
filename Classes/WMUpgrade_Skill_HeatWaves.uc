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

static simulated function RevertUpgradeChanges(Pawn OwnerPawn)
{
	if (OwnerPawn != None && KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo) != None)
		KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo).bSplashActive = False;
}

defaultproperties
{
	Damage(0)=0.8f
	Damage(1)=2.0f
	Stumble=1.5f
	RadiusSQ(0)=90000
	RadiusSQ(1)=360000

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_HeatWaves"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HeatWaves_Deluxe'

	Name="Default__WMUpgrade_Skill_HeatWaves"
}
