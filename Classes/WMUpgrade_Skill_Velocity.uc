class WMUpgrade_Skill_Velocity extends WMUpgrade_Skill;

var array<float> Damage;
var float MaxRadius;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float RangeFactor;

	if (MyKFPM != None && DamageInstigator != None && DamageInstigator.Pawn != None)
	{
		RangeFactor = FMin(1.0f, VSizeSQ(DamageInstigator.Pawn.Location - MyKFPM.Location) / default.MaxRadius);
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1] * RangeFactor);
	}
}

defaultproperties
{
	Damage(0)=0.25f
	Damage(1)=0.6f
	MaxRadius=50000000.0f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Skill_Velocity"

	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Velocity'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Velocity_Deluxe'

	Name="Default__WMUpgrade_Skill_Velocity"
}
