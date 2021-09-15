class WMGameDifficulty_Endless extends KFGameDifficulty_Survival;

var WMGameReplicationInfo WMGRI;
var float GameDifficultyZedternal;

function SetDifficultySettings(float GameDifficulty)
{
	`log("ZedternalReborn GameDifficulty:" @ GameDifficulty);

	WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
	{
		GameDifficultyZedternal = `DIFFICULTY_ZEDTERNALCUSTOM;
		GameDifficulty = `DIFFICULTY_HELLONEARTH;
	}
	else
		GameDifficultyZedternal = GameDifficulty;

	super.SetDifficultySettings(GameDifficulty);
}

function GetAIHealthModifier(KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod, optional bool bApplyDifficultyScaling=True)
{
	local byte i;

	if (P != None)
	{
		if (P.bVersusZed)
		{
			HealthMod = class'ZedternalReborn.Config_DifficultyOmega'.static.GetZedHealthModifier(GameDifficultyZedternal);
			HeadHealthMod = class'ZedternalReborn.Config_DifficultyOmega'.static.GetZedHeadHealthModifier(GameDifficultyZedternal);
		}
		else if (P.bLargeZed)
		{
			HealthMod = class'ZedternalReborn.Config_DifficultyLarge'.static.GetZedHealthModifier(GameDifficultyZedternal);
			HeadHealthMod = class'ZedternalReborn.Config_DifficultyLarge'.static.GetZedHeadHealthModifier(GameDifficultyZedternal);
		}
		else
		{
			HealthMod = class'ZedternalReborn.Config_DifficultyNormal'.static.GetZedHealthModifier(GameDifficultyZedternal);
			HeadHealthMod = class'ZedternalReborn.Config_DifficultyNormal'.static.GetZedHeadHealthModifier(GameDifficultyZedternal);
		}

		if (WMGRI == None)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

		if (WMGRI != None)
		{
			if (P.bVersusZed)
			{
				HealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetOmegaZedHealthModifierOverTime(HealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetOmegaZedHealthModifierOverTime(HeadHealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
			}
			else if (P.bLargeZed)
			{
				HealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetLargeZedHealthModifierOverTime(HealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetLargeZedHealthModifierOverTime(HeadHealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
			}
			else
			{
				HealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetNormalZedHealthModifierOverTime(HealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetNormalZedHealthModifierOverTime(HeadHealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
			}
			for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
			{
				if (WMGRI.bZedBuffs[i] > 0)
				{
					WMGRI.zedBuffs[i].static.ModifyZedHealthMod(HealthMod, P, GameDifficultyZedternal, NumLivingPlayers);
					WMGRI.zedBuffs[i].static.ModifyZedHeadHealthMod(HeadHealthMod, P, GameDifficultyZedternal, NumLivingPlayers);
				}
			}
		}

		// Add another extra multiplier based on the number of players
		if (P.bVersusZed)
		{
			HealthMod += class'ZedternalReborn.Config_DifficultyOmega'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
			HeadHealthMod += class'ZedternalReborn.Config_DifficultyOmega'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
		}
		else if (P.bLargeZed)
		{
			HealthMod += class'ZedternalReborn.Config_DifficultyLarge'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
			HeadHealthMod += class'ZedternalReborn.Config_DifficultyLarge'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
		}
		else
		{
			HealthMod += class'ZedternalReborn.Config_DifficultyNormal'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
			HeadHealthMod += class'ZedternalReborn.Config_DifficultyNormal'.static.GetExtraHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
		}
	}
}

/** Scales the health this Player (versus mode) Zed has by number of human players */
function GetVersusHealthModifier(KFPawn_Monster P, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod)
{
	GetAIHealthModifier(P, GameDifficultyZedternal, NumLivingPlayers, HealthMod, HeadHealthMod);
}

/**	Scales the damage this Zed deals by the difficulty level */
function float GetAIDamageModifier(KFPawn_Monster P, float GameDifficulty, bool bSoloPlay)
{
	local float ZedDamageMod;
	local byte i;

	ZedDamageMod = 1.0f;

	if (P != None)
	{
		if (bSoloPlay)
		{
			if (P.bVersusZed)
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyOmega'.static.GetZedSoloDamageModifier(GameDifficultyZedternal);
			else if (P.bLargeZed)
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyLarge'.static.GetZedSoloDamageModifier(GameDifficultyZedternal);
			else
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyNormal'.static.GetZedSoloDamageModifier(GameDifficultyZedternal);
		}
		else
		{
			if (P.bVersusZed)
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyOmega'.static.GetZedDamageModifier(GameDifficultyZedternal);
			else if (P.bLargeZed)
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyLarge'.static.GetZedDamageModifier(GameDifficultyZedternal);
			else
				ZedDamageMod = class'ZedternalReborn.Config_DifficultyNormal'.static.GetZedDamageModifier(GameDifficultyZedternal);
		}

		if (WMGRI == None)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

		if (WMGRI != None)
		{
			ZedDamageMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetZedDamageModifierOverTime(ZedDamageMod, GameDifficultyZedternal, WMGRI.WaveNum);
			for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
			{
				if (WMGRI.bZedBuffs[i] > 0)
					WMGRI.zedBuffs[i].static.ModifyZedDamageMod(ZedDamageMod, P, GameDifficultyZedternal);
			}
		}
	}

	return FMax(0.05f, ZedDamageMod);
}

/** Gives the random range of AI speed modification */
function float GetAISpeedMod(KFPawn_Monster P, float GameDifficulty)
{
	local float SpeedMod;
	local byte i;

	SpeedMod = 1.0f;

	if (P != None)
	{
		if (P.bVersusZed)
			SpeedMod = class'ZedternalReborn.Config_DifficultyOmega'.static.GetZedSpeedModifier(GameDifficultyZedternal);
		else if (P.bLargeZed)
			SpeedMod = class'ZedternalReborn.Config_DifficultyLarge'.static.GetZedSpeedModifier(GameDifficultyZedternal);
		else
			SpeedMod = class'ZedternalReborn.Config_DifficultyNormal'.static.GetZedSpeedModifier(GameDifficultyZedternal);

		// Randomize speed modifier by +/- 10%
		SpeedMod *= RandRange(0.9f, 1.1f);

		if (WMGRI == None)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

		if (WMGRI != None)
		{
			SpeedMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetZedSpeedModifierOverTime(SpeedMod, GameDifficultyZedternal, WMGRI.WaveNum);
			for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
			{
				if (WMGRI.bZedBuffs[i] > 0)
					WMGRI.zedBuffs[i].static.ModifyZedSpeedMod(SpeedMod, P, GameDifficultyZedternal);
			}
		}
	}

	return FMax(0.05f, SpeedMod);
}

function float GetCharSprintChanceByDifficulty(KFPawn_Monster P, float GameDifficulty)
{
	local float SprintChanceMod;
	local byte i;
	local KFAIController_Monster KFAI;

	// Disable teleport ability
	if (!class'ZedternalReborn.Config_WaveOptions'.static.GetAllowZedTeleport(GameDifficultyZedternal))
	{
		KFAI = KFAIController_Monster(P.Controller);
		if (KFAI != None)
			KFAI.bCanTeleportCloser = False;
	}

	if (GameDifficultyZedternal >= 3.0f)
	{
		SprintChanceMod =  P.DifficultySettings.default.HellOnEarth.SprintChance;
	}
	else if (GameDifficultyZedternal >= 2.0f)
	{
		SprintChanceMod =  P.DifficultySettings.default.Suicidal.SprintChance;
	}
	else if (GameDifficultyZedternal >= 1.0f)
	{
		SprintChanceMod =  P.DifficultySettings.default.Hard.SprintChance;
	}
	else
		SprintChanceMod = P.DifficultySettings.default.Normal.SprintChance;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		if (KFPawn_ZedScrake(P) == None && KFPawn_ZedFleshpound(P) == None)
			SprintChanceMod += class'ZedternalReborn.Config_DiffOverTime'.static.GetZedSprintChanceModifierOverTime(GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyZedSprintChanceMod(SprintChanceMod, P, GameDifficultyZedternal);
		}
	}

	return FMax(0.0f, SprintChanceMod);
}

function float GetCharSprintWhenDamagedChanceByDifficulty(KFPawn_Monster P, float GameDifficulty)
{
	local float SprintChanceMod;
	local byte i;

	if (GameDifficultyZedternal >= 3.0f)
	{
		SprintChanceMod =  P.DifficultySettings.default.HellOnEarth.DamagedSprintChance;
	}
	else if (GameDifficultyZedternal >= 2.0f)
	{
		SprintChanceMod =  P.DifficultySettings.default.Suicidal.DamagedSprintChance;
	}
	else if (GameDifficultyZedternal >= 1.0f)
	{
		SprintChanceMod = P.DifficultySettings.default.Hard.DamagedSprintChance;
	}
	else
		SprintChanceMod = P.DifficultySettings.default.Normal.DamagedSprintChance;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyDamagedZedSprintChanceMod(SprintChanceMod, P, GameDifficultyZedternal);
		}
	}

	return FMax(0.0f, SprintChanceMod);
}

/* Get the money value adjusted by difficulty */
function float GetKillCashModifier()
{
	local float DoshMod;
	local byte i;

	DoshMod = CurrentSettings.DoshKillMod;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		DoshMod -= class'ZedternalReborn.Config_DiffOverTime'.static.GetZedDoshPenaltyModifierOverTime(GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyZedDoshMod(DoshMod);
		}
	}

	return FMax(0.0f, DoshMod);
}

/* Get the modifier for the number of active weapon pickups in a map */
function float GetItemPickupModifier()
{
	local float ItemPickupMod;
	local byte i;

	ItemPickupMod = CurrentSettings.ItemPickupsMod;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyItemPickupMod(ItemPickupMod);
		}
	}

	return FMax(0.0f, ItemPickupMod);
}

/* Get the modifier for the number of active weapon pickups in a map */
function float GetAmmoPickupModifier()
{
	local float AmmoPickupMod;
	local byte i;

	AmmoPickupMod = CurrentSettings.AmmoPickupsMod;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyAmmoPickupMod(AmmoPickupMod);
		}
	}

	return FMax(0.0f, AmmoPickupMod);
}

function float GetWeakAttackChance()
{
	local float WeakAttackChanceMod;
	local byte i;

	WeakAttackChanceMod = CurrentSettings.WeakAttackChance;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyWeakAttackChanceMod(WeakAttackChanceMod);
		}
	}

	return FMax(0.0f, WeakAttackChanceMod);
}

function float GetMediumAttackChance()
{
	local float MediumAttackChanceMod;
	local byte i;

	MediumAttackChanceMod = CurrentSettings.MediumAttackChance;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyMediumAttackChanceMod(MediumAttackChanceMod);
		}
	}

	return FMax(0.0f, MediumAttackChanceMod);
}

function float GetHardAttackChance()
{
	local float HardAttackChanceMod;
	local byte i;

	HardAttackChanceMod = CurrentSettings.HardAttackChance;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		HardAttackChanceMod += class'ZedternalReborn.Config_DiffOverTime'.static.GetZedHardAttackChanceModifierOverTime(GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyHardAttackChanceMod(HardAttackChanceMod);
		}
	}

	return FMax(0.0f, HardAttackChanceMod);
}

function float GetSpawnRateModifier()
{
	local float SpawnRateMod;
	local byte i;

	SpawnRateMod = CurrentSettings.SpawnRateModifier;

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifySpawnRateMod(SpawnRateMod);
		}
	}

	return FMax(0.0005f, SpawnRateMod);
}

/** Return the damage resistance modifier */
function float GetDamageResistanceModifier(byte NumLivingPlayers)
{
	local float DamageResistanceMod;
	local byte i;

	DamageResistanceMod = GetNumPlayersModifier(NumPlayers_ZedDamageResistance, NumLivingPlayers);

	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.Length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyDamageResistanceMod(DamageResistanceMod, NumLivingPlayers);
		}
	}

	return FMax(0.1f, DamageResistanceMod);
}

defaultproperties
{
	Name="Default__WMGameDifficulty_Endless"
}
