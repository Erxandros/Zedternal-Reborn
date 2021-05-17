class WMUpgrade_Skill_Hunter extends WMUpgrade_Skill;

var array<int> Vampire;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && MyKFPM.bLargeZed && MyKFPM.IsAliveAndWell() && (MyKFPM.Health - InDamage) <= 0 && DamageInstigator != None && DamageInstigator.Pawn != None)
		DamageInstigator.Pawn.HealDamage(default.Vampire[upgLevel - 1], DamageInstigator, class'KFDT_Healing');
}

defaultproperties
{
	Vampire(0)=15
	Vampire(1)=40

	upgradeName="Hunter"
	upgradeDescription(0)="Heal 15 points of health for every large ZED killed"
	upgradeDescription(1)="Heal <font color=\"#b346ea\">40</font> points of health for every large ZED killed"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hunter'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hunter_Deluxe'

	Name="Default__WMUpgrade_Skill_Hunter"
}
