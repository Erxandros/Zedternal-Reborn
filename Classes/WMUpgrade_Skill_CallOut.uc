class WMUpgrade_Skill_CallOut extends WMUpgrade_Skill;

var array<float> Damage;

static simulated function bool IsCallOutActive(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

defaultproperties
{
	Damage(0)=0.1f
	Damage(1)=0.25f

	upgradeName="Call Out"
	upgradeDescription(0)="Allow you to see cloaked ZEDs. Increase damage you deal with <font color=\"#eaeff7\">all weapons</font> by 10%"
	upgradeDescription(1)="Allow you to see cloaked ZEDs. Increase damage you deal with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">25%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CallOut'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CallOut_Deluxe'

	Name="Default__WMUpgrade_Skill_CallOut"
}
