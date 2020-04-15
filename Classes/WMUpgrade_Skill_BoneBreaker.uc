Class WMUpgrade_Skill_BoneBreaker extends WMUpgrade_Skill;
	
var array< float > Stumble, Knockdown;
var	const array<byte> BoneBreakerBodyParts;
	
static function ModifyStumblePower( out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	if (BodyPart == HZI_Head)
		InStumblePower += DefaultStumblePower * default.Stumble[0+(upgLevel-1)*2];
	if (default.BoneBreakerBodyParts.Find( class'KFGameContent.KFPawn_ZedClot_Alpha'.default.HitZones[BodyPart].Limb ) != INDEX_NONE)
		InStumblePower += DefaultStumblePower * default.Stumble[1+(upgLevel-1)*2];
}

static function ModifyKnockdownPower( out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false)
{
	if (BodyPart == HZI_Head)
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[0+(upgLevel-1)*2];
	if (default.BoneBreakerBodyParts.Find( class'KFGameContent.KFPawn_ZedClot_Alpha'.default.HitZones[BodyPart].Limb ) != INDEX_NONE)
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[1+(upgLevel-1)*2];
}
defaultproperties
{
	upgradeName="Bone Breaker"
	upgradeDescription(0)="Shooting ZEDs in the arms, legs and heads increases knockdown and stumble powers with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Shooting ZEDs in the arms, legs and heads <font color=\"#b346ea\">Massively</font> increases knockdown and stumble powers with <font color=\"#eaeff7\">all weapons</font>"
	Stumble(0)=3.50000;
	Stumble(1)=4.50000;
	Stumble(2)=8.75000;
	Stumble(3)=11.250000;
	Knockdown(0)=3.500000;
	Knockdown(1)=4.500000;
	Knockdown(2)=8.750000;
	Knockdown(3)=11.250000;
	BoneBreakerBodyParts(0)=2
	BoneBreakerBodyParts(1)=3
	BoneBreakerBodyParts(2)=4
	BoneBreakerBodyParts(3)=5
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_BoneBreaker'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_BoneBreaker_Deluxe'
}