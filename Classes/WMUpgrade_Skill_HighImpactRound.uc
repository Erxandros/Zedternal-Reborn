Class WMUpgrade_Skill_HighImpactRound extends WMUpgrade_Skill;

var array<float> Knockdown;

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Explosive'))
		InKnockdownPower += DefaultKnockdownPower * default.Knockdown[upgLevel - 1];
}

defaultproperties
{
	Knockdown(0)=2.5f
	Knockdown(1)=6.0f

	upgradeName="High Impact Rounds"
	upgradeDescription(0)="Greatly increase knockdown power of <font color=\"#eaeff7\">all explosives</font>"
	upgradeDescription(1)="<font color=\"#b346ea\">Massively</font> increase knockdown power of <font color=\"#eaeff7\">all explosives</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighImpactRound'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_HighImpactRound_Deluxe'

	Name="Default__WMUpgrade_Skill_HighImpactRound"
}
