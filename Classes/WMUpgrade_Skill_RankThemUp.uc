Class WMUpgrade_Skill_RankThemUp extends WMUpgrade_Skill;
	
var array<float> ExtraDamage;
	
static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;
	
	if (DamageType != none && KFPawn(DamageInstigator.Pawn) != none && MyKFPM.IsAliveAndWell() && !MyKFPM.bCheckingExtraHeadDamage && HitZoneIdx == HZI_HEAD)
	{
		UPG = GetCounter(KFPawn(DamageInstigator.Pawn));
		if (UPG.headShot < UPG.maxHeadShot)
		{
			UPG.IncreaseCounter();
		}
		else
		{
			UPG.EndStrike();
			InDamage += Round(float(DefaultDamage) * default.ExtraDamage[upgLevel-1]);
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;
	local bool bFound;
	
	if (KFPawn_Human(OwnerPawn)!=none)
	{
		bFound = false;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Counter',UPG)
			bFound = true;
		
		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Counter',OwnerPawn);
			UPG.Player = KFPawn_Human(OwnerPawn);
		}
	}
}

static function WMUpgrade_Skill_RankThemUp_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;

	if (KFPawn_Human(OwnerPawn)!=none)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Counter',UPG)
			return UPG;
	}
	// should have one
	UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Counter',OwnerPawn);
	return UPG;
}

defaultproperties
{
	upgradeName="Rank Them Up"
	upgradeDescription(0)="Connect 5 headshots to massively increase damage on the 6th headshot with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Connect 5 headshots to <font color=\"#b346ea\">massively</font> increase damage on the 6th headshot with <font color=\"#eaeff7\">all weapons</font>"
	ExtraDamage(1)=1.500000;
	ExtraDamage(2)=3.750000;
	upgradeIcon(0)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RankThemUp'
	upgradeIcon(1)=Texture2D'Zedternal_Resource.Skills.UI_Skill_RankThemUp_Deluxe'
}