class WMUpgrade_Skill_Watcher extends WMUpgrade_Skill;

var float CriticalHealth;
var array<float> Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && MyKFPM.Health <= int(float(MyKFPM.HealthMax) * default.CriticalHealth))
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
}

static simulated function bool CanSeeEnemyHealth(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	CriticalHealth=0.25f
	Damage(0)=0.25f
	Damage(1)=0.6f

	upgradeName="Watcher"
	upgradeDescription(0)="Allows you to see ZED health and increases damage you deal to greatly injured ZEDs with <font color=\"#eaeff7\">all weapons</font> by 25%"
	upgradeDescription(1)="Allows you to see ZED health and increases damage you deal to greatly injured ZEDs with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">60%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Watcher'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Watcher_Deluxe'

	Name="Default__WMUpgrade_Skill_Watcher"
}
