class WMUpgrade_Skill_FirstBlood extends WMUpgrade_Skill;

var array<float> DamageDelta, DamageMax;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;
	local KFPawn KFP;

	KFP = KFPawn(DamageInstigator.Pawn);
	if (KFP != None)
	{
		UPG = GetCounter(KFP);

		if (ClassIsChildOf(DamageType, class'KFDT_Ballistic') && UPG != None && UPG.bActive)
		{
			InDamage += DefaultDamage * FMin(default.DamageMax[upgLevel - 1], default.DamageDelta[upgLevel - 1] * MyKFW.MagazineCapacity[0]);
			UPG.SetFirstBlood(False);
		}
	}
}

static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;

	if (OwnerPawn != None && KFW != None)
	{
		UPG = GetCounter(OwnerPawn);
		if (UPG != None)
			UPG.SetFirstBlood(KFW.AmmoCount[0] == KFW.MagazineCapacity[0]);
	}
}

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;

	if (OwnerPawn != None)
	{
		UPG = GetCounter(OwnerPawn);
		if (UPG != None)
			UPG.SetFirstBlood(True);
	}
}

static function WMUpgrade_Skill_FirstBlood_Counter GetCounter(KFPawn OwnerPawn)
{
	local WMUpgrade_Skill_FirstBlood_Counter UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_FirstBlood_Counter', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_FirstBlood_Counter', OwnerPawn);
		UPG.Player = KFPawn_Human(OwnerPawn);
	}

	return UPG;
}

defaultproperties
{
	DamageDelta(0)=0.05f
	DamageDelta(1)=0.1f
	DamageMax(0)=2.0f
	DamageMax(1)=5.0f

	upgradeName="First Blood"
	upgradeDescription(0)="The first bullet of <font color=\"#eaeff7\">any magazine</font> deals more damage. Extra damage is proportional to the magazine capacity (5% per bullet, up to 200%)"
	upgradeDescription(1)="The first bullet of <font color=\"#eaeff7\">any magazine</font> deals more damage. Extra damage is proportional to the magazine capacity (<font color=\"#b346ea\">10%</font> per bullet, up to <font color=\"#b346ea\">500%</font>)"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_FirstBlood_Deluxe'

	Name="Default__WMUpgrade_Skill_FirstBlood"
}
