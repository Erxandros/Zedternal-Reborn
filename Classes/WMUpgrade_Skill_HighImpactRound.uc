Class WMUpgrade_Skill_HighImpactRound extends WMUpgrade_Skill;

var array<float> Knockdown;

static function ModifyKnockdownPower( out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false)
{
	if (DamageType != none && class<KFDT_Explosive>(DamageType) != none)
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[upgLevel-1];
}	

defaultproperties
{
	upgradeName="High Impact Rounds"
	Knockdown(0) = 2.500000
	Knockdown(1) = 6.000000
	upgradeDescription(0)="Greatly increase knockdown power of <font color=\"#eaeff7\">all explosives</font>"
	upgradeDescription(1)="<font color=\"#b346ea\">Massively</font> increase knockdown power of <font color=\"#eaeff7\">all explosives</font>"
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HighImpactRound'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_HighImpactRound_Deluxe'
}