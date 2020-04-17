Class WMUpgrade_Skill_SuppressionRounds extends WMUpgrade_Skill;
	
var array<float> knockDown, Prob;
var array<byte> BodyParts;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx < 0) return;

	if( MyKFPM != none && MyKFPM.bIsSprinting && FRand() < default.Prob[upgLevel-1] && HitShouldGiveBodyPartDamage( MyKFPM.HitZones[HitZoneIdx].Limb ) && MyKFPM.CanDoSpecialMove( SM_Knockdown ) )
		MyKFPM.Knockdown( MyKFPM.Velocity * 0.5, vect(1,1,1), MyKFPM.Location, 1000, 100 );
}

static function ModifyKnockdownPower( out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false)
{
	if (bIsSprinting)
		InKnockdownPower += DefaultKnockdownPower * default.knockDown[upgLevel-1];
}

static function bool HitShouldGiveBodyPartDamage( byte BodyPart )
{
	return default.BodyParts.Find( BodyPart ) != INDEX_NONE;
}


defaultproperties
{
	upgradeName="Suppression Rounds"
	upgradeDescription(0)="Shooting sprinting ZEDs in the legs and arms increases knockdown power with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Shooting sprinting ZEDs in the legs and arms <font color=\"#b346ea\">massively</font> increases knockdown power with <font color=\"#eaeff7\">all weapons</font>"
	knockDown(0)=1.00000
	knockDown(1)=2.50000
	Prob(0)=0.500000
	Prob(1)=1.000000
	BodyParts(0)=2
    BodyParts(1)=3
    BodyParts(2)=4
    BodyParts(3)=5
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SuppressionRounds_Deluxe'
}