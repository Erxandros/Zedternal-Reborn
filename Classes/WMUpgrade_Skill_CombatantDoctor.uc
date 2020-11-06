Class WMUpgrade_Skill_CombatantDoctor extends WMUpgrade_Skill;

var array<float> HealingProb;
var array<float> VampireProb;

static function HealingDamage(int upgLevel, int HealAmount, KFPawn HealedPawn, KFPawn InstigatorPawn, class<DamageType> DamageType)
{
	if (InstigatorPawn != None)
		AddAmmunition(InstigatorPawn, float(HealAmount) * default.HealingProb[upgLevel - 1]);
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT)
{
	if (KFPC.Pawn != None)
		AddAmmunition(KFPawn(KFPC.Pawn), default.VampireProb[upgLevel - 1]);
}

static function AddAmmunition(KFPawn Player, float Factor)
{
	local KFWeapon W;
	local byte i;
	local int extraAmmo;

	if (Player != None && Player.Health > 0 && Player.InvManager != None)
	{
		foreach Player.InvManager.InventoryActors(class'KFWeapon', W)
		{
			for (i = 0; i < 2; ++i)
			{
				if (W.SpareAmmoCount[i] < W.SpareAmmoCapacity[i] && FRand() <= float(W.SpareAmmoCapacity[i]) * Factor)
				{
					extraAmmo = Max(Round(float(W.SpareAmmoCapacity[i]) * Factor), 1);
					if (i == 0)
						W.AddAmmo(extraAmmo);
					else
					{
						W.AddSecondaryAmmo(extraAmmo);
						W.ClientForceSecondaryAmmoUpdate(W.AmmoCount[i]);
					}
				}
			}
		}
	}
}

defaultproperties
{
	HealingProb(0)=0.0006f
	HealingProb(1)=0.0015f
	VampireProb(0)=0.002f
	VampireProb(1)=0.005f

	upgradeName="Combatant Doctor"
	upgradeDescription(0)="Generate ammunition for yourself while healing"
	upgradeDescription(1)="<font color=\"#b346ea\">Greatly</font> generate ammunition for yourself while healing"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CombatantDoctor'
	upgradeIcon(1)=Texture2D'ZedternalReborn_Resource.Skills.UI_Skill_CombatantDoctor_Deluxe'

	Name="Default__WMUpgrade_Skill_CombatantDoctor"
}
