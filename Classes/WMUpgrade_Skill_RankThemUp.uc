class WMUpgrade_Skill_RankThemUp extends WMUpgrade_Skill;

var array<float> ExtraDamage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;

	if (DamageType != None && MyKFPM != None && DamageInstigator != None && DamageInstigator.Pawn != None && MyKFPM.IsAliveAndWell() && !MyKFPM.bCheckingExtraHeadDamage && HitZoneIdx == HZI_HEAD)
	{
		UPG = GetCounter(DamageInstigator.Pawn);
		if (UPG != None)
		{
			if (UPG.headShot < UPG.maxHeadShot)
				UPG.IncreaseCounter();
			else
			{
				UPG.EndStrike();
				InDamage += Round(float(DefaultDamage) * default.ExtraDamage[upgLevel - 1]);
			}
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;
	local bool bFound;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		bFound = False;
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Counter', UPG)
		{
			if (UPG != None)
			{
				bFound = True;
				break;
			}
		}

		if (!bFound)
		{
			UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Counter', OwnerPawn);
			UPG.Player = KFPawn_Human(OwnerPawn);
		}
	}
}

static function WMUpgrade_Skill_RankThemUp_Counter GetCounter(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_RankThemUp_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_RankThemUp_Counter', UPG)
		{
			if (UPG != None)
				return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_RankThemUp_Counter', OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	ExtraDamage(1)=1.5f
	ExtraDamage(2)=3.75f

	upgradeName="Rank Them Up"
	upgradeDescription(0)="Connect 5 headshots to increase damage on the 6th headshot by 150% with <font color=\"#eaeff7\">all weapons</font>"
	upgradeDescription(1)="Connect 5 headshots to increase damage on the 6th headshot by <font color=\"#b346ea\">375%</font> with <font color=\"#eaeff7\">all weapons</font>"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RankThemUp'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_RankThemUp_Deluxe'

	Name="Default__WMUpgrade_Skill_RankThemUp"
}
