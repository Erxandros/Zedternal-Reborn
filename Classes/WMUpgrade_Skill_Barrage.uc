Class WMUpgrade_Skill_Barrage extends WMUpgrade_Skill;
	
var array<float> Damage;
var int RadiusSQ;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Barrage_Effect UPG;
	
	if (DamageInstigator != none && DamageInstigator.pawn != none && MyKFPM != none && VSizeSQ( DamageInstigator.Pawn.Location - MyKFPM.Location ) <= default.RadiusSQ)
	{
		InDamage += round(float(DefaultDamage) * default.Damage[upgLevel-1]);
		if (InDamage > 5)
		{
			UPG = GetCounter(DamageInstigator.Pawn);
			UPG.CreateEffect();
		}
	}
}

static function WMUpgrade_Skill_Barrage_Effect GetCounter(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Barrage_Effect UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Barrage_Effect',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Barrage_Effect',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	return UPG;
}


defaultproperties
{
	upgradeName="Barrage"
	upgradeDescription(0)="Increase damage at point blank range with <font color=\"#eaeff7\">all weapons</font> 25%"
	upgradeDescription(1)="Increase damage at point blank range with <font color=\"#eaeff7\">all weapons</font> <font color=\"#b346ea\">60%</font>"
	Damage(0)=0.250000;
	Damage(1)=0.600000;
	RadiusSQ=50000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Barrage'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Barrage_Deluxe'
}