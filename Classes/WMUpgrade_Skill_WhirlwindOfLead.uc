Class WMUpgrade_Skill_WhirlwindOfLead extends WMUpgrade_Skill;

var array<float> FireRate, SpecialRate;
var array<name> ZedTimeModifyingStates;

static simulated function bool GetIsUberAmmoActive(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return OwnerPawn.Controller.WorldInfo.TimeDilation < 1.0f;
}

static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW)
{
	local name StateName;

	if(KFW != None)
	{
		StateName = KFW.GetStateName();
		if (default.ZedTimeModifyingStates.Find(StateName) != INDEX_NONE)
		{
			if (KFWeap_MeleeBase(KFW) != None || KFW.default.MagazineCapacity[0] > 4)
				InModifier += default.FireRate[upgLevel - 1];
			else
				InModifier += default.SpecialRate[upgLevel - 1];
		}
	}
}

defaultproperties
{
	FireRate(0)=0.5f
	FireRate(1)=0.9f
	SpecialRate(0)=0.2f
	SpecialRate(1)=0.4f

	ZedTimeModifyingStates(0)="MeleeChainAttacking"
	ZedTimeModifyingStates(1)="MeleeAttackBasic"
	ZedTimeModifyingStates(2)="MeleeHeavyAttacking"
	ZedTimeModifyingStates(3)="MeleeSustained"
	ZedTimeModifyingStates(4)="WeaponFiring"
	ZedTimeModifyingStates(5)="WeaponBurstFiring"
	ZedTimeModifyingStates(6)="WeaponSingleFiring"
	ZedTimeModifyingStates(7)="WeaponSingleFireAndReload"

	upgradeName="Whirlwind of Lead"
	upgradeDescription(0)="During Zed Time, <font color=\"#eaeff7\">your weapon</font> shoots faster and can not run out of ammo"
	upgradeDescription(1)="During Zed Time, <font color=\"#eaeff7\">your weapon</font> shoots <font color=\"#b346ea\">in near real-time</font> and can not run out of ammo"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_WhirlwindOfLead'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_WhirlwindOfLead_Deluxe'

	Name="Default__WMUpgrade_Skill_WhirlwindOfLead"
}
