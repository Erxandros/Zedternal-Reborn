Class WMUpgrade_Skill_SuppressionRounds extends WMUpgrade_Skill;

var array<float> KnockDown, Prob;
var array<byte> BodyParts;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx < 0)
		return;

	if (MyKFPM != None && MyKFPM.bIsSprinting && FRand() < default.Prob[upgLevel - 1] && default.BodyParts.Find(MyKFPM.HitZones[HitZoneIdx].Limb) != INDEX_NONE && MyKFPM.CanDoSpecialMove(SM_Knockdown))
		MyKFPM.Knockdown(MyKFPM.Velocity * 0.5f, vect(1,1,1), MyKFPM.Location, 1000, 100);
}

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	if (bIsSprinting)
		InKnockdownPower += DefaultKnockdownPower * default.KnockDown[upgLevel - 1];
}

defaultproperties
{
	KnockDown(0)=1.0f
	KnockDown(1)=2.5f
	Prob(0)=0.5f
	Prob(1)=1.0f
	BodyParts(0)=2
	BodyParts(1)=3
	BodyParts(2)=4
	BodyParts(3)=5

	upgradeName="Suppression Rounds"
	upgradeDescription(0)="Shooting sprinting ZEDs in the legs and arms increases knockdown power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Shooting sprinting ZEDs in the legs and arms <font color=\"#b346ea\">massively</font> increases knockdown power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds_Deluxe'

	Name="Default__WMUpgrade_Skill_SuppressionRounds"
}
