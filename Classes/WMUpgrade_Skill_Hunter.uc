Class WMUpgrade_Skill_Hunter extends WMUpgrade_Skill;

var array<int> Vampire;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if ((MyKFPM.Health - InDamage) <= 0 && DamageInstigator.Pawn != none && MyKFPM.IsAliveAndWell() && MyKFPM.bLargeZed)
		DamageInstigator.Pawn.HealDamage(default.Vampire[upgLevel-1], DamageInstigator, class'KFDT_Healing');
}

defaultproperties
{
	upgradeName="Hunter"
	upgradeDescription(0)="Heals 15 points of Health for every large ZED killed"
	upgradeDescription(1)="Heals <font color=\"#b346ea\">40</font> points of Health for every large ZED killed"
	Vampire(0)=15
	Vampire(1)=40
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hunter'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Hunter_Deluxe'
}