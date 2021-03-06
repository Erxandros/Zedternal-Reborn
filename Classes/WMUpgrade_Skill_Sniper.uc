class WMUpgrade_Skill_Sniper extends WMUpgrade_Skill;

var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageInstigator != None && DamageInstigator.Pawn != None && VSizeSq(DamageInstigator.Pawn.Velocity) <= 0)
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.2f
	Damage(1)=0.5f

	upgradeName="Sniper"
	upgradeDescription(0)="While stationary increase damage by 20% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="While stationary increase damage by <font color=\"#b346ea\">50%</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Sniper'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Sniper_Deluxe'

	Name="Default__WMUpgrade_Skill_Sniper"
}
