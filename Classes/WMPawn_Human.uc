class WMPawn_Human extends KFPawn_Human;

var byte HealingDamageBoost_ZedternalReborn;
var byte HealingShield_ZedternalReborn;

var int ZedternalMaxArmor;
var int ZedternalArmor;

replication
{
	// Replicated to ALL
	if (bNetDirty)
		HealingDamageBoost_ZedternalReborn, HealingShield_ZedternalReborn, ZedternalArmor, ZedternalMaxArmor;
}

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType, optional bool bCanRepairArmor=True, optional bool bMessageHealer=True)
{
	local KFPlayerController InstigatorPC;
	local KFPerk InstigatorPerk;
	local WMPerk WMP;

	InstigatorPC = KFPlayerController(Healer);
	InstigatorPerk = InstigatorPC != None ? InstigatorPC.GetPerk() : None;
	if (InstigatorPerk != None)
	{
		WMP = WMPerk(InstigatorPerk);
		if (WMP != None)
		{
			WMP.HealingDamage(Amount, self, DamageType);

			UpdateHealingDamageBoost_ZedternalReborn(WMP);
			UpdateHealingShield_ZedternalReborn(WMP);
		}
	}

	return super.HealDamage(Amount, Healer, DamageType, bCanRepairArmor, bMessageHealer);
}

event bool HealDamageForce(int Amount, Controller Healer, class<DamageType> DamageType, optional bool bCanRepairArmor=True, optional bool bMessageHealer=True)
{
	local int DoshEarned;
	local float UsedHealAmount;
	local KFPlayerReplicationInfo InstigatorPRI;
	local KFPlayerController InstigatorPC, KFPC;
	local KFPerk InstigatorPerk;
	local class<KFDamageType> KFDT;
	local int i;
	local bool bRepairedArmor;
	local int OldHealth;

	OldHealth = Health;

	InstigatorPC = KFPlayerController(Healer);
	InstigatorPerk = InstigatorPC != None ? InstigatorPC.GetPerk() : None;
	if (InstigatorPerk != None)
	{
		// Instigator might be able to repair some armomr
		if (bCanRepairArmor)
			bRepairedArmor = InstigatorPerk.RepairArmor(self);

		if (InstigatorPerk.GetHealingSpeedBoostActive())
			UpdateHealingSpeedBoost();

		if (InstigatorPerk.GetHealingDamageBoostActive())
			UpdateHealingDamageBoost();

		if (InstigatorPerk.GetHealingShieldActive())
			UpdateHealingShield();
	}

	if (Amount > 0 && IsAliveAndWell() && Health < HealthMax)
	{
		// Play any healing effects attached to this damage type
		KFDT = class<KFDamageType>(DamageType);
		if (KFDT != None && KFDT.default.bNoPain)
			PlayHeal(KFDT);
		else
			`warn("No hit effects for damagetype:"@DamageType);

		if (Role == ROLE_Authority)
		{
			if (InstigatorPC == None || InstigatorPC.PlayerReplicationInfo == None)
				return False;

			InstigatorPRI = KFPlayerReplicationInfo(InstigatorPC.PlayerReplicationInfo);
			UsedHealAmount = Amount;
			if (InstigatorPerk != None)
			{
				if (InstigatorPerk.ModifyHealAmount(UsedHealAmount))
				{
					if (Controller != Healer && InstigatorPerk.IsHealingSurgeActive())
					{
						if (InstigatorPC.Pawn != None)
							InstigatorPC.Pawn.HealDamage(InstigatorPC.Pawn.HealthMax * InstigatorPerk.GetSelfHealingSurgePct(), InstigatorPC, class'KFDT_Healing');
					}
				}
			}

			// You can never have a HealthToRegen value that's greater than HealthMax
			if (Health + HealthToRegen + UsedHealAmount > HealthMax)
				UsedHealAmount = HealthMax - (Health + HealthToRegen);

			HealthToRegen += UsedHealAmount;
			SetTimer(HealthRegenRate, True, NameOf(GiveHealthOverTime));

			// Give the healer money/XP for helping a teammate
			if (InstigatorPC.Pawn != None && InstigatorPC.Pawn != self)
			{
				DoshEarned = (UsedHealAmount / float(HealthMax)) * HealerRewardScaler;
				InstigatorPRI.AddDosh(Max(DoshEarned, 0), True);
				if (WMPlayerController(InstigatorPC) != None)
					WMPlayerController(InstigatorPC).AddHealStat(UsedHealAmount);
			}

			if (Healer.bIsPlayer)
			{
				if (Healer != Controller)
				{
					InstigatorPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_HealedPlayer, PlayerReplicationInfo);
					KFPC = KFPlayerController(Controller);
					KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_HealedBy, Healer.PlayerReplicationInfo);

					if (KFPC != None && KFPC.MatchStats != None)
					{
						KFPC.MatchStats.RecordIntStat(5, UsedHealAmount); // MATCH_EVENT_HEAL_RECEIVED
						InstigatorPC.MatchStats.RecordIntStat(4, UsedHealAmount); // MATCH_EVENT_HEAL_GIVEN
					}
				}
				else
				{
					if (bMessageHealer)
						InstigatorPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_HealedSelf, PlayerReplicationInfo);
				}
			}

			// don't play dialog for healing done through perk skills (e.g. berserker vampire skill)
			if (bMessageHealer)
				`DialogManager.PlayHealingDialog(KFPawn(Healer.Pawn), self, float(Health + HealthToRegen) / float(HealthMax));

			// Reduce burn duration and damage in half if you heal while burning
			for (i = 0; i < DamageOverTimeArray.Length; ++i)
			{
				if (DamageOverTimeArray[i].DoT_Type == DOT_Fire)
				{
					DamageOverTimeArray[i].Duration *= 0.5;
					DamageOverTimeArray[i].Damage *= 0.5;
					break;
				}
			}

			if (Health - OldHealth > 0)
				WorldInfo.Game.ScoreHeal(Health - OldHealth, OldHealth, Healer, self, DamageType);

			return True;
		}
	}

	if (Health - OldHealth > 0)
		WorldInfo.Game.ScoreHeal(Health - OldHealth, OldHealth, Healer, self, DamageType);

	return bRepairedArmor;
}

simulated function float GetHealingDamageBoostModifier()
{
	return 1.0f + (float(HealingDamageBoost_ZedternalReborn) / 100);
}

simulated function float GetHealingShieldModifier()
{
	return 1.0f - (float(HealingShield_ZedternalReborn) / 100);
}

simulated function UpdateHealingDamageBoost_ZedternalReborn(WMPerk WMP)
{
	HealingDamageBoost_ZedternalReborn = Min(HealingDamageBoost_ZedternalReborn + WMP.GetHealingDamageBoost(), WMP.GetMaxHealingDamageBoost());
	SetTimer(5.0f, False, nameof(ResetHealingDamageBoost));
}

simulated function UpdateHealingShield_ZedternalReborn(WMPerk WMP)
{
	HealingShield_ZedternalReborn = Min(HealingShield_ZedternalReborn + WMP.GetHealingShield(), WMP.GetMaxHealingShield());
	SetTimer(5.0f, False, nameof(ResetHealingShield));
}

simulated function ResetHealingDamageBoost()
{
	HealingDamageBoost_ZedternalReborn = 0;

	super.ResetHealingDamageBoost();
}

simulated function ResetHealingShield()
{
	HealingShield_ZedternalReborn = 0;

	super.ResetHealingShield();
}

function UpdateActiveSkillsPath(string IconPath, int Multiplier, bool Active, float MaxDuration)
{
	if (KFPlayerController(Controller) != None)
		super.UpdateActiveSkillsPath(IconPath, Multiplier, Active, MaxDuration);
}

function SacrificeExplode()
{
	local KFExplosionActorReplicated ExploActor;
	local GameExplosion	ExplosionTemplate;
	local WMPerk Perk;

	if (Role < ROLE_Authority)
	{
		return;
	}

	Perk = WMPerk(GetPerk());

	// explode using the given template
	ExploActor = Spawn(class'KFExplosionActorReplicated', self, , Location, , , True);
	if (ExploActor != None)
	{
		ExploActor.InstigatorController = Controller;
		ExploActor.Instigator = self;

		ExplosionTemplate = class'KFPerk_Demolitionist'.static.GetSacrificeExplosionTemplate();
		ExplosionTemplate.bIgnoreInstigator = True;
		ExploActor.Explode(ExplosionTemplate);

		if (Perk != None)
		{
			Perk.NotifyPerkSacrificeExploded();
		}
	}
}

function ThrowActiveWeapon(optional bool bDestroyWeap)
{
	local KFWeapon TempWeapon;
	local int Difficulty;

	// Only throw on server
	if (Role < ROLE_Authority)
	{
		return;
	}

	if (WMGameInfo_Endless(WorldInfo.Game) != None)
	{
		Difficulty = WMGameInfo_Endless(WorldInfo.Game).GameDifficultyZedternal;
	}

	// If we're dead, always throw all weapons
	if (class'ZedternalReborn.Config_Player'.static.GetDropAllWeaponsWhenDead(Difficulty) && InvManager != None && Health <= 0)
	{
		foreach InvManager.InventoryActors(class'KFWeapon', TempWeapon)
		{
			// We only care about weapons we can actually drop
			if(TempWeapon.bDropOnDeath || TempWeapon.CanThrow())
				TossInventory(TempWeapon);
		}
	}
	else
	{
		super.ThrowActiveWeapon(bDestroyWeap);
	}
}

simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	local WMPerk MyPerk;
	local KFPawn_Monster KFPM;

	if (!IsZero(Velocity) && Other.GetTeamNum() != GetTeamNum())
	{
		MyPerk = WMPerk(GetPerk());
		KFPM = KFPawn_Monster(Other);

		if (KFPM != None && MyPerk != None && MyPerk.CanKnockDownOnBump(KFPM) && Normal(Velocity) dot Vector(Rotation) > 0.7f)
		{
			//First priority is a knockdown if it is allowed
			if (KFPM.CanDoSpecialMove(SM_Knockdown))
				KFPM.Knockdown(Velocity * 3, vect(1, 1, 1), KFPM.Location, 1000, 100);
			//If they can't be knocked down, but are headless, kill them outright
			else if (KFPM.IsHeadless())
				KFPM.TakeDamage(KFPM.HealthMax, Controller, Location, vect(0, 0, 0), class'KFDT_NPCBump_Large');
			//Last priority is a stumble as a backup
			else if (KFPM.CanDoSpecialMove(SM_Stumble))
				KFPM.DoSpecialMove(SM_Stumble, , , class'KFSM_Stumble'.static.PackRandomSMFlags(KFPM));
		}
	}
}

reliable client function ClearAllAmmoClient(bool bClearMagazine)
{
	local KFWeapon KFW;

	if (Health > 0 && InvManager != None)
	{
		foreach InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if (KFWeap_Healer_Syringe(KFW) == None && KFWeap_Welder(KFW) == None)
			{
				if (bClearMagazine)
					KFW.AmmoCount[0] = 0;

				KFW.SpareAmmoCount[0] = 0;

				if (KFW.CanRefillSecondaryAmmo())
				{
					KFW.AmmoCount[1] = 0;
					KFW.SpareAmmoCount[1] = 0;
				}
			}
		}
	}
}

/** Network: Server only */
function GiveHealthOverTime()
{
	local WMPlayerReplicationInfo WMPRI;

	if (HealthToRegen > 0 && Health < HealthMax)
	{
		++Health;
		--HealthToRegen;

		WorldInfo.Game.ScoreHeal(1, Health - 1, Controller, self, None);

		WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
		if (WMPRI != None)
		{
			WMPRI.PlayerHealthInt = Health;
			WMPRI.PlayerHealth = FloatToByte(float(Health) / float(HealthMax));
			WMPRI.PlayerHealthPercent = WMPRI.PlayerHealth;
		}
	}
	else
	{
		HealthToRegen = 0;
		ClearTimer(NameOf(GiveHealthOverTime));
	}
}

simulated function ToggleEquipment()
{
	local WMPerk MyPerk;

	MyPerk = WMPerk(GetPerk());
	if (MyPerk != None)
		MyPerk.ApplyBatteryRechargeRate();

	super.ToggleEquipment();
}

/*********************************************************************************************
* Zedternal Armor
********************************************************************************************* */
function AddArmor(int Amount)
{
	if (Amount > 0)
	{
		ZedternalArmor = Min(ZedternalArmor + Amount, ZedternalMaxArmor);
		AdjustArmorPct();
	}
}

function GiveMaxArmor()
{
	ZedternalArmor = ZedternalMaxArmor;
	AdjustArmorPct();
}

function int GetMaxArmor()
{
	return ZedternalMaxArmor;
}

//This is for GUI percent elements
function AdjustArmorPct()
{
	Armor = FCeil(float(ZedternalArmor) / float(ZedternalMaxArmor) * float(MaxArmor));
}

function ShieldAbsorb(out int InDamage)
{
	local float AbsorbedPct;
	local int AbsorbedDmg;
	local WMPerk MyPerk;

	MyPerk = WMPerk(GetPerk());
	if (MyPerk != None && MyPerk.HasHeavyArmor())
	{
		AbsorbedDmg = Min(InDamage, ZedternalArmor);
		ZedternalArmor -= MyPerk.GetArmorDamageAmount(AbsorbedDmg);
		InDamage -= AbsorbedDmg;
		AdjustArmorPct();
		return;
	}

	// Three levels of armor integrity
	if (ZedternalArmor >= ZedternalMaxArmor * 0.67f)
	{
		AbsorbedPct = ArmorAbsorbModifier_High;
	}
	else if (ZedternalArmor >= ZedternalMaxArmor * 0.33f)
	{
		AbsorbedPct = ArmorAbsorbModifier_Medium;
	}
	else
	{
		AbsorbedPct = ArmorAbsorbModifier_Low;
	}

	AbsorbedDmg = Min(Round(AbsorbedPct * InDamage), ZedternalArmor);
	// reduce damage and armor
	ZedternalArmor -= AbsorbedDmg;
	InDamage -= AbsorbedDmg;
	AdjustArmorPct();
}

defaultproperties
{
	InventoryManagerClass=class'WMInventoryManager'

	Armor=0
	MaxArmor=255
	ZedternalArmor=0
	ZedternalMaxArmor=100

	Name="Default__WMPawn_Human"
}
