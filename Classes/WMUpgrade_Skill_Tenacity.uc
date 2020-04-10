Class WMUpgrade_Skill_Tenacity extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (KFPawn(DamageInstigator.Pawn) != none && MyKFPM != none && (MyKFPM.Health - InDamage) <= 0)
	{
		UPG = GetCounter(KFPawn(DamageInstigator.Pawn));
		UPG.SetActive();
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (OwnerPawn != none)
	{
		UPG = GetCounter(OwnerPawn);
		if (UPG.bActive)
			InDamage -= Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
	}
}

static function WMUpgrade_Skill_Tenacity_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Tenacity_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Tenacity_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Tenacity_Counter',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	
	return UPG;
}

defaultproperties
{
	upgradeName="Tenacity"
	upgradeDescription(0)="Reduces incoming damage 15% during a short time after killing a ZED"
	upgradeDescription(1)="Reduces incoming damage <font color=\"#b346ea\">40%</font> during a short time after killing a ZED"
	Damage(0)=0.150000;
	Damage(1)=0.400000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Tenacity_Deluxe'
}