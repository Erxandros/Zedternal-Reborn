Class WMUpgrade_Skill_GunMachine extends WMUpgrade_Skill;
	
var array<float> Damage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_GunMachine_Counter UPG;

	if (KFPawn(DamageInstigator.Pawn) != none && MyKFPM != none)
	{
		UPG = GetCounter(KFPawn(DamageInstigator.Pawn));
		if (UPG.bActive)
			InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel-1]);
		
		if ((MyKFPM.Health - InDamage) <= 0)
			UPG.SetActive();
	}
}

static function WMUpgrade_Skill_GunMachine_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_GunMachine_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_GunMachine_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_GunMachine_Counter',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	
	return UPG;
}

defaultproperties
{
	upgradeName="Machine Gunner"
	upgradeDescription(0)="Killing a ZED increases damage with <font color=\"#eaeff7\">all weapons</font> by 25% for 5 seconds"
	upgradeDescription(1)="Killing a ZED increases damage with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">60%</font> for 5 seconds"
	Damage(0)=0.250000;
	Damage(1)=0.600000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_GunMachine'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_GunMachine_Deluxe'
}