class WMUpgrade_Skill_BoneBreaker extends WMUpgrade_Skill;

var array<float> Stumble, Knockdown;
var const array<byte> BoneBreakerBodyParts;

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	if (BodyPart == HZI_Head && default.BoneBreakerBodyParts.Find(class'KFGame.KFPawn_Monster'.default.HitZones[BodyPart].Limb) != INDEX_NONE)
		InStumblePower += DefaultStumblePower * default.Stumble[upgLevel - 1];
}

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	if (BodyPart == HZI_Head)
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[0 + (upgLevel - 1) * 2];

	if (default.BoneBreakerBodyParts.Find(class'KFGame.KFPawn_Monster'.default.HitZones[BodyPart].Limb) != INDEX_NONE)
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[1 + (upgLevel - 1) * 2];
}

defaultproperties
{
	Stumble(0)=0.3f
	Stumble(1)=0.75f
	Knockdown(0)=0.2f
	Knockdown(1)=0.3f
	Knockdown(2)=0.5f
	Knockdown(3)=0.6f
	BoneBreakerBodyParts(0)=2
	BoneBreakerBodyParts(1)=3
	BoneBreakerBodyParts(2)=4
	BoneBreakerBodyParts(3)=5

	upgradeName="Bone Breaker"
	upgradeDescription(0)="Shooting ZEDs in the arms, legs, and head with <font color=\"#eaeff7\">all weapons</font> increases stumble power by 30% and knockdown power by 30% for limb shots and 20% for headshots"
	upgradeDescription(1)="Shooting ZEDs in the arms, legs, and head with <font color=\"#eaeff7\">all weapons</font> increases stumble power by <font color=\"#b346ea\">75%</font> and knockdown power by <font color=\"#b346ea\">60%</font> for limb shots and <font color=\"#b346ea\">50%</font> for headshots"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BoneBreaker'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_BoneBreaker_Deluxe'

	Name="Default__WMUpgrade_Skill_BoneBreaker"
}
