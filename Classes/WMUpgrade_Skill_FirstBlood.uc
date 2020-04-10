Class WMUpgrade_Skill_FirstBlood extends WMUpgrade_Skill;
	
var array<float> DamageDelta, DamageMax;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;
	local KFPawn KFP;
	
	KFP = KFPawn(DamageInstigator.Pawn);
	if (KFP != none)
	{
		UPG = GetCounter(KFP);
		
		if (class<KFDT_Ballistic>(DamageType) != none && UPG != none && UPG.bActive)
		{
			InDamage += DefaultDamage * FMin(default.DamageMax[upgLevel-1], default.DamageDelta[upgLevel-1] * MyKFW.MagazineCapacity[0]);
			UPG.SetFirstBlood(false);
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;
	
	if (OwnerPawn != none && KFW != none)
	{
		UPG = GetCounter(OwnerPawn);
		UPG.SetFirstBlood(KFW.AmmoCount[0] == KFW.MagazineCapacity[0]);
	}
}

static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;
	
	if (OwnerPawn != none && KFW != none)
	{
		UPG = GetCounter(OwnerPawn);
		UPG.SetFirstBlood(true);
	}
}

static function WMUpgrade_Skill_FirstBlood_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_FirstBlood_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_FirstBlood_Counter',OwnerPawn);
	UPG.Player = KFPawn_Human(OwnerPawn);
	
	return UPG;
}

defaultproperties
{
	upgradeName="First Blood"
	upgradeDescription(0)="The first bullet of <font color=\"#eaeff7\">any magazine</font> deals more damage. Extra damage is proportional to the magazine capacity (5% per bullet, up to 200%)"
	upgradeDescription(1)="The first bullet of <font color=\"#eaeff7\">any magazine</font> deals more damage. Extra damage is proportional to the magazine capacity (<font color=\"#b346ea\">10%</font> per bullet, up to <font color=\"#b346ea\">500%</font>)"
	DamageDelta(0)=0.050000;
	DamageDelta(1)=0.100000;
	DamageMax(0) = 2.000000;
	DamageMax(1) = 5.000000;
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood_Deluxe'
}