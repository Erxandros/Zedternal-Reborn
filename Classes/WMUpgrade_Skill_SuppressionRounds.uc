class WMUpgrade_Skill_SuppressionRounds extends WMUpgrade_Skill;

var array<float> KnockDown;
var float Snare;

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	if (bIsSprinting)
		InKnockdownPower += DefaultKnockdownPower * default.KnockDown[upgLevel - 1];
}

static function ModifySnarePower(out float InSnarePower, float DefaultSnarePower, int upgLevel, optional class<DamageType> DamageType, optional byte BodyPart)
{
	if (BodyPart != HZI_Head)
		InSnarePower += DefaultSnarePower * default.Snare;
}

defaultproperties
{
	KnockDown(0)=0.3f
	KnockDown(1)=0.75f
	Snare=20.0f

	UpgradeName="Suppression Rounds"
	UpgradeDescription(0)="Landing several body shots slows ZEDs by 30% and when a ZED is sprinting increase knockdown power by 30% with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeDescription(1)="Landing several body shots slows ZEDs by 30% and when a ZED is sprinting increase knockdown power by <font color=\"#b346ea\">75%</font> with <font color=\"#eaeff7\">all weapons</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_SuppressionRounds"
}
