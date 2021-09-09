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
		HealthMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedHealthModifier(GameDifficultyZedternal);
		HeadHealthMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedHeadHealthModifier(GameDifficultyZedternal);

		// invalid scaling?
		if (HealthMod <= 0)
			HealthMod = 1.0f;
		if (HeadHealthMod <= 0)
			HeadHealthMod = 1.0f;

		// Zed buff
		if (WMGRI == None)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

		if (WMGRI != None)
		{
			if (P.bLargeZed)
			{
				HealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetLargeZedHealthModifierOverTime(HealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetLargeZedHealthModifierOverTime(HeadHealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
			}
			else
			{
				HealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetNormalZedHealthModifierOverTime(HealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetNormalZedHealthModifierOverTime(HeadHealthMod, GameDifficultyZedternal, WMGRI.WaveNum);
			}
			for (i = 0; i < WMGRI.zedBuffs.length; ++i)
			{
				if (WMGRI.bZedBuffs[i] > 0)
				{
					WMGRI.zedBuffs[i].static.ModifyZedHealthMod(HealthMod, P, GameDifficultyZedternal, NumLivingPlayers);
					WMGRI.zedBuffs[i].static.ModifyZedHeadHealthMod(HeadHealthMod, P, GameDifficultyZedternal, NumLivingPlayers);
				}
			}
		}

		// Add another multiplier based on the number of players and the zeds character info scalers
		if (P.bLargeZed)
		{
			HealthMod += class'ZedternalReborn.Config_Difficulty'.static.GetLargeZedHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
			HeadHealthMod += class'ZedternalReborn.Config_Difficulty'.static.GetLargeZedHealthModifierPerPlayer(GameDifficultyZedternal) * (NumLivingPlayers - 1);
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

	if (bSoloPlay)
		ZedDamageMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedSoloDamageModifier(GameDifficultyZedternal);
	else
		ZedDamageMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedDamageModifier(GameDifficultyZedternal);

	// invalid scaling?
	if (ZedDamageMod <= 0)
		ZedDamageMod = 0.75f;

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		ZedDamageMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetZedDamageModifierOverTime(ZedDamageMod, GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyZedDamageMod(ZedDamageMod, P, GameDifficultyZedternal);
		}
	}

	return ZedDamageMod;
}

/** Gives the random range of AI speed modification */
function float GetAISpeedMod(KFPawn_Monster P, float GameDifficulty)
{
	local float SpeedMod;
	local byte i;

	SpeedMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedSpeedModifier(GameDifficultyZedternal) * RandRange(0.9f, 1.1f);

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		SpeedMod = class'ZedternalReborn.Config_DiffOverTime'.static.GetZedSpeedModifierOverTime(SpeedMod, GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
		{
			if (WMGRI.bZedBuffs[i] > 0)
				WMGRI.zedBuffs[i].static.ModifyZedSpeedMod(SpeedMod, P, GameDifficultyZedternal);
		}
	}

	return FMax(0.1f, SpeedMod);
}

function float GetCharSprintChanceByDifficulty(KFPawn_Monster P, float GameDifficulty)
{
	local float SprintChanceMod;
	local byte i;
	local KFAIController_Monster KFAI;

	// diable teleport ability
	if (!class'ZedternalReborn.Config_WaveOptions'.default.Wave_bAllowZedTeleport)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		if (KFPawn_ZedScrake(P) == None && KFPawn_ZedFleshpound(P) == None)
			SprintChanceMod += class'ZedternalReborn.Config_DiffOverTime'.static.GetZedSprintChanceModifierOverTime(GameDifficultyZedternal, WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		DoshMod -= class'ZedternalReborn.Config_DiffOverTime'.static.GetZedDoshPenaltyModifierOverTime(WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		HardAttackChanceMod += class'ZedternalReborn.Config_DiffOverTime'.static.GetZedHardAttackChanceModifierOverTime(WMGRI.WaveNum);
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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

	// Zed buff
	if (WMGRI == None)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (WMGRI != None)
	{
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
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
