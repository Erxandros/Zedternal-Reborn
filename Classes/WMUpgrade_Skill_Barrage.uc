class WMUpgrade_Skill_Barrage extends WMUpgrade_Skill;

var array<float> Damage;
var int RadiusSQ;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local WMUpgrade_Skill_Barrage_Helper UPG;

	if (MyKFPM != None && DamageInstigator != None && DamageInstigator.Pawn != None && VSizeSQ(DamageInstigator.Pawn.Location - MyKFPM.Location) <= default.RadiusSQ)
	{
		InDamage += Round(float(DefaultDamage) * default.Damage[upgLevel - 1]);
		if (InDamage > 5)
		{
			UPG = GetHelper(DamageInstigator.Pawn);
			if (UPG != None)
				UPG.CreateEffect();
		}
	}
}

static function WMUpgrade_Skill_Barrage_Helper GetHelper(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Barrage_Helper UPG;

	if (KFPawn_Human(OwnerPawn) != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Barrage_Helper', UPG)
		{
			return UPG;
		}

		//Should have one
		UPG = OwnerPawn.Spawn(class'WMUpgrade_Skill_Barrage_Helper', OwnerPawn);
	}

	return UPG;
}

static simulated function DeleteHelperClass(Pawn OwnerPawn)
{
	local WMUpgrade_Skill_Barrage_Helper UPG;

	if (OwnerPawn != None)
	{
		foreach OwnerPawn.ChildActors(class'WMUpgrade_Skill_Barrage_Helper', UPG)
		{
			UPG.Destroy();
		}
	}
}

defaultproperties
{
	Damage(0)=0.25f;
	Damage(1)=0.6f;
	RadiusSQ=50000;

	UpgradeName="Barrage"
	UpgradeDescription(0)="Increase damage at point blank range with <font color=\"#eaeff7\">all weapons</font> by 25%"
	UpgradeDescription(1)="Increase damage at point blank range with <font color=\"#eaeff7\">all weapons</font> by <font color=\"#b346ea\">60%</font>"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barrage'
	UpgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_Barrage_Deluxe'

	Name="Default__WMUpgrade_Skill_Barrage"
}
