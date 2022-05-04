class WMUpgrade_Skill_HighImpactRound extends WMUpgrade_Skill;

var array<float> Knockdown;

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Explosive'))
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[upgLevel - 1];
}

defaultproperties
{
	Knockdown(0)=0.4f
	Knockdown(1)=1.0f

	UpgradeName="High Impact Rounds"
	UpgradeDescription(0)="Increase knockdown power of <font color=\"#eaeff7\">all explosives</font> by 40%"
	UpgradeDescription(1)="Increase knockdown power of <font color=\"#eaeff7\">all explosives</font> by <font color=\"#b346ea\">100%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighImpactRound'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighImpactRound_Deluxe'

	Name="Default__WMUpgrade_Skill_HighImpactRound"
}
