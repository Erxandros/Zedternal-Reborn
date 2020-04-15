Class WMUpgrade_Skill_Parry extends WMUpgrade_Skill;
	
var array<float> Damage, Resistance;

	
static simulated function SuccessfullParry(int upgLevel, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Counter UPG;
	
	if (OwnerPawn != none)
	{
		UPG = GetCounter(OwnerPawn);
		UPG.ActiveEffect();
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Parry_Counter UPG;
	
	if (MyKFW != none && KFPawn(MyKFW.Owner) != none)
	{
		UPG = GetCounter(KFPawn(MyKFW.Owner));
		if (UPG.bOn)
			InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Parry_Counter UPG;
	
	if (OwnerPawn != none)
	{
		UPG = GetCounter(OwnerPawn);
		if (UPG.bOn)
			InDamage -= Round(float(DefaultDamage) * default.Resistance[upgLevel-1]);
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Counter UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Parry_Counter',UPG)
			bFound = true;
		if (!bFound)
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Parry_Counter',OwnerPawn);
	}
}

static function WMUpgrade_Skill_Parry_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_Parry_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Parry_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Parry_Counter',OwnerPawn);
	return UPG;
}

defaultproperties
{
	upgradeName="Parry"
	upgradeDescription(0)="Parrying an attack with a melee weapon reduces incoming damage by 30% and increases damage by 30% with <font color=\"#eaeff7\">any weapon</font> for 10 seconds"
	upgradeDescription(1)="Parrying an attack with a melee weapon reduces incoming damage by <font color=\"#b346ea\">40%</font> and increases damage by <font color=\"#b346ea\">75%</font> with <font color=\"#eaeff7\">any weapon</font> for 10 seconds"
	Damage(0)=0.300000;
	Damage(1)=0.750000;
	Resistance(0)=0.300000;
	Resistance(1)=0.400000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Parry'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_Parry_Deluxe'
}