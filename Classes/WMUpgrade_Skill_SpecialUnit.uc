Class WMUpgrade_Skill_SpecialUnit extends WMUpgrade_Skill;

var array<float> Damage, Speed;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (KFPawn_Human(DamageInstigator.Pawn) != none && KFPawn_Human(DamageInstigator.Pawn).Armor > 0)
		InDamage += DefaultDamage * default.Damage[upgLevel-1];
}

static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != none && KFPawn_Human(OwnerPawn).Armor <= 0)
		InSpeed += DefaultSpeed*default.Speed[upgLevel-1];
}

defaultproperties
{
	upgradeName="Special Unit"
	upgradeDescription(0)="While you have body armor, increase damage with <font color=\"#eaeff7\">all weapons</font> 15%. Otherwise increase movement speed 10%"
	upgradeDescription(1)="While you have body armor, increase damage with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">40%</font>. Otherwise increase movement speed <font color=\"#b346ea\">20%</font>"
	Damage(0)=0.1500000
	Damage(1)=0.4000000
	Speed(0)=0.100000
	Speed(1)=0.200000
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SpecialUnit'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SpecialUnit_Deluxe'
}