class WMUpgrade_Skill_SpecialUnit extends WMUpgrade_Skill;

var array<float> Damage, Speed;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (DamageInstigator != None && KFPawn_Human(DamageInstigator.Pawn) != None && KFPawn_Human(DamageInstigator.Pawn).Armor > 0)
		InDamage += DefaultDamage * default.Damage[upgLevel - 1];
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn)
{
	if (KFPawn_Human(OwnerPawn) != None && KFPawn_Human(OwnerPawn).Armor <= 0)
		InSpeed += DefaultSpeed * default.Speed[upgLevel - 1];
}

defaultproperties
{
	Damage(0)=0.15f
	Damage(1)=0.4f
	Speed(0)=0.1f
	Speed(1)=0.2f

	upgradeName="Special Unit"
	upgradeDescription(0)="While you have body armor, increase damage with <font color=\"#eaeff7\">all weapons</font> by 15%. Otherwise increase movement speed by 10%"
	upgradeDescription(1)="While you have body armor, increase damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">40%</font>. Otherwise increase movement speed by <font color=\"#b346ea\">20%</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SpecialUnit'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_SpecialUnit_Deluxe'

	Name="Default__WMUpgrade_Skill_SpecialUnit"
}
