class WMUpgrade_Skill_WhirlwindOfLead extends WMUpgrade_Skill;

var array<float> FireRate, SpecialRate;

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
		if (class'ZedternalReborn.WMWeaponStates'.static.IsWeaponAttackState(StateName))
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

	upgradeName="Whirlwind Of Lead"
	upgradeDescription(0)="During ZED Time your weapon shoots faster and has unlimited ammo"
	upgradeDescription(1)="During ZED Time your weapon shoots in <font color=\"#b346ea\">near real-time</font> and has unlimited ammo"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_WhirlwindOfLead'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_WhirlwindOfLead_Deluxe'

	Name="Default__WMUpgrade_Skill_WhirlwindOfLead"
}
