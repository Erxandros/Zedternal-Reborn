class WMGameDifficulty_Endless extends KFGameDifficulty_Survival;

var WMGameReplicationInfo WMGRI;
var float CustomDifficulty;
var bool CustomMode;

function SetDifficultySettings( float GameDifficulty )
{
	`log("ZedternalReborn GameDifficulty: "$GameDifficulty);

	WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);

	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
	{
		CustomMode = true;
		GameDifficulty = `DIFFICULTY_HELLONEARTH;
	}
	super.SetDifficultySettings(GameDifficulty);
}

function GetAIHealthModifier(KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod, optional bool bApplyDifficultyScaling=true)
{
	local byte i;

	if (CustomMode)
	{
		GameDifficulty = CustomDifficulty;
	}

	if ( P != none )
	{
	    HealthMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedHealthMod(GameDifficulty);
		HeadHealthMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedHeadHealthMod(GameDifficulty);
		
		// invalid scaling?
		if (HealthMod <= 0)
			HealthMod = 1.f;
		if (HeadHealthMod <= 0)
            HeadHealthMod = 1.f;

		
		// Zed buff
		if (WMGRI == none)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
		if (WMGRI != none)
		{
			if (P.bLargeZed)
			{
				HealthMod = class'ZedternalReborn.Config_ZedBuff'.static.GetMaxHealthBuff_LargeZed(HealthMod, GameDifficulty, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_ZedBuff'.static.GetMaxHealthBuff_LargeZed(HeadHealthMod, GameDifficulty, WMGRI.WaveNum);
			}
			else
			{
				HealthMod = class'ZedternalReborn.Config_ZedBuff'.static.GetMaxHealthBuff(HealthMod, GameDifficulty, WMGRI.WaveNum);
				HeadHealthMod = class'ZedternalReborn.Config_ZedBuff'.static.GetMaxHealthBuff(HeadHealthMod, GameDifficulty, WMGRI.WaveNum);
			}
			for (i=0;i<WMGRI.zedBuffs.length;i+=1)
			{
				if (WMGRI.bZedBuffs[i]>0)
				{
					WMGRI.zedBuffs[i].static.ModifyZedHealthMod(HealthMod, P, GameDifficulty, NumLivingPlayers);
					WMGRI.zedBuffs[i].static.ModifyZedHeadHealthMod(HeadHealthMod, P, GameDifficulty, NumLivingPlayers);
				}
			}
		}

	    // Add another multiplier based on the number of players and the zeds character info scalers
		if (P.bLargeZed)
		{
			HealthMod += class'ZedternalReborn.Config_Difficulty'.static.GetLargeZedHealthModPerPlayer(GameDifficulty) * (NumLivingPlayers - 1);
			HeadHealthMod += class'ZedternalReborn.Config_Difficulty'.static.GetLargeZedHealthModPerPlayer(GameDifficulty) * (NumLivingPlayers - 1);
		}
	}
}

/** Scales the health this Player (versus mode) Zed has by number of human players */
function GetVersusHealthModifier(KFPawn_Monster P, byte NumLivingPlayers, out float HealthMod, out float HeadHealthMod)
{
	local byte i;

	if ( P != none )
	{
		HealthMod = GetGlobalHealthMod();
		HeadHealthMod = GetGlobalHealthMod();
		
		// invalid scaling?
		if (HealthMod <= 0)
			HealthMod = 1.f;
		if (HeadHealthMod <= 0)
            HeadHealthMod = 1.f;
		
		// Zed buff
		if (WMGRI == none)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
		if (WMGRI != none)
		{
			for (i=0;i<WMGRI.zedBuffs.length;i+=1)
			{
				if (WMGRI.bZedBuffs[i]>0)
				{
					WMGRI.zedBuffs[i].static.ModifyZedHealthMod(HealthMod, P, 1.f, NumLivingPlayers);
					WMGRI.zedBuffs[i].static.ModifyZedHeadHealthMod(HeadHealthMod, P, 1.f, NumLivingPlayers);
				}
			}
		}

	    // Add another multiplier based on the number of players and the zeds character info scalers
		HealthMod *= 1.0 + (GetNumPlayersHealthMod( NumLivingPlayers, P.DifficultySettings.default.NumPlayersScale_BodyHealth_Versus ));
		HeadHealthMod *= 1.0 + (GetNumPlayersHealthMod( NumLivingPlayers, P.DifficultySettings.default.NumPlayersScale_HeadHealth_Versus ));
	}
}

/**	Scales the damage this Zed deals by the difficulty level */
function float GetAIDamageModifier(KFPawn_Monster P, float GameDifficulty, bool bSoloPlay)
{
    local float ZedDamageMod;
	local byte i;

	if (CustomMode)
	{
		GameDifficulty = CustomDifficulty;
	}

    if(bSoloPlay)
        ZedDamageMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedSoloDamageMod(GameDifficulty);
	else
		ZedDamageMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedDamageMod(GameDifficulty);
	
	// invalid scaling?
	if (ZedDamageMod <= 0)
		ZedDamageMod = 0.750000;
	
	// Zed buff
	if (WMGRI != none)
	{
		ZedDamageMod = class'ZedternalReborn.Config_ZedBuff'.static.GetDamageBuff(ZedDamageMod, GameDifficulty, WMGRI.WaveNum);
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyZedDamageMod(ZedDamageMod, P, GameDifficulty);
		}
	}

	return ZedDamageMod;
}

/** Gives the random range of AI speed modification */
function float GetAISpeedMod(KFPawn_Monster P, float GameDifficulty)
{
	local float SpeedMod;
	local byte i;

	if (CustomMode)
	{
		GameDifficulty = CustomDifficulty;
	}

	SpeedMod = class'ZedternalReborn.Config_Difficulty'.static.GetZedSpeedMod(GameDifficulty) * RandRange(0.9f, 1.1f);

	// Zed buff
	if (WMGRI == none)
			WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		SpeedMod = class'ZedternalReborn.Config_ZedBuff'.static.GetSpeedBuff(SpeedMod, GameDifficulty, WMGRI.WaveNum);
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyZedSpeedMod(SpeedMod, P, GameDifficulty);
		}
	}
	
	return FMax(0.1f, SpeedMod);
}

function float GetCharSprintChanceByDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float SprintChanceMod;
	local byte i;
	local KFAIController_Monster KFAI;

	if (CustomMode)
	{
		GameDifficulty = CustomDifficulty;
	}

	// diable teleport ability
	if (!class'ZedternalReborn.Config_Game'.default.Game_bAllowZedTeleport)
	{
		KFAI = KFAIController_Monster(P.Controller);
		if (KFAI != none)
			KFAI.bCanTeleportCloser = false;
	}
	
	if ( GameDifficulty >= 3.0)
	{
		SprintChanceMod =  P.DifficultySettings.default.HellOnEarth.SprintChance;
	}
	else if ( GameDifficulty >= 2.0)
	{
		SprintChanceMod =  P.DifficultySettings.default.Suicidal.SprintChance;
	}
	else if ( GameDifficulty >= 1.0)
	{
		SprintChanceMod =  P.DifficultySettings.default.Hard.SprintChance;
	}
	else
		SprintChanceMod = P.DifficultySettings.default.Normal.SprintChance;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		if (KFPawn_ZedScrake(P) == none && KFPawn_ZedFleshpound(P) == none)
			SprintChanceMod += class'ZedternalReborn.Config_ZedBuff'.static.GetSprintChanceBuff(GameDifficulty, WMGRI.WaveNum);
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyZedSprintChanceMod(SprintChanceMod, P, GameDifficulty);
		}
	}
	
	return FMax(0.f, SprintChanceMod);
}

function float GetCharSprintWhenDamagedChanceByDifficulty( KFPawn_Monster P, float GameDifficulty )
{
	local float SprintChanceMod;
	local byte i;

	if (CustomMode)
	{
		GameDifficulty = CustomDifficulty;
	}

	if ( GameDifficulty >= 3.0)
	{
		SprintChanceMod =  P.DifficultySettings.default.HellOnEarth.DamagedSprintChance;
	}
	else if ( GameDifficulty >= 2.0)
	{
		SprintChanceMod =  P.DifficultySettings.default.Suicidal.DamagedSprintChance;
	}
	else if ( GameDifficulty >= 1.0)
	{
		SprintChanceMod = P.DifficultySettings.default.Hard.DamagedSprintChance;
	}
	else
		SprintChanceMod = P.DifficultySettings.default.Normal.DamagedSprintChance;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyDamagedZedSprintChanceMod(SprintChanceMod, P, GameDifficulty);
		}
	}
	
	return FMax(0.f, SprintChanceMod);
}

/* Get the money value adjusted by difficulty */
function float GetKillCashModifier()
{
	local float DoshMod;
	local byte i;
	
	DoshMod = CurrentSettings.DoshKillMod;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		DoshMod -= class'ZedternalReborn.Config_ZedBuff'.static.GetDoshPenalityBuff(WMGRI.WaveNum);
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyZedDoshMod(DoshMod);
		}
	}
	
	return FMax(0.f, DoshMod);
}

/* Get the modifier for the number of active weapon pickups in a map */
function float GetItemPickupModifier()
{
	local float ItemPickupMod;
	local byte i;
	
	ItemPickupMod = CurrentSettings.ItemPickupsMod;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyItemPickupMod(ItemPickupMod);
		}
	}
	
	return FMax(0.f, ItemPickupMod);
}

/* Get the modifier for the number of active weapon pickups in a map */
function float GetAmmoPickupModifier()
{
	local float AmmoPickupMod;
	local byte i;
	
	AmmoPickupMod = CurrentSettings.AmmoPickupsMod;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyAmmoPickupMod(AmmoPickupMod);
		}
	}
	
	return FMax(0.f, AmmoPickupMod);
}

function float GetWeakAttackChance()
{
	local float WeakAttackChanceMod;
	local byte i;
	
	WeakAttackChanceMod = CurrentSettings.WeakAttackChance;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyWeakAttackChanceMod(WeakAttackChanceMod);
		}
	}
	
	return FMax(0.f, WeakAttackChanceMod);
}

function float GetMediumAttackChance()
{
	local float MediumAttackChanceMod;
	local byte i;
	
	MediumAttackChanceMod = CurrentSettings.MediumAttackChance;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyMediumAttackChanceMod(MediumAttackChanceMod);
		}
	}
	
	return FMax(0.f, MediumAttackChanceMod);
}

function float GetHardAttackChance()
{
	local float HardAttackChanceMod;
	local byte i;
	
	HardAttackChanceMod = CurrentSettings.HardAttackChance;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		HardAttackChanceMod += class'ZedternalReborn.Config_ZedBuff'.static.GetHardAttackChanceBuff(WMGRI.WaveNum);
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyHardAttackChanceMod(HardAttackChanceMod);
		}
	}
	
	return FMax(0.f, HardAttackChanceMod);
}

function float GetSpawnRateModifier()
{
	local float SpawnRateMod;
	local byte i;
	
	SpawnRateMod = CurrentSettings.SpawnRateModifier;
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifySpawnRateMod(SpawnRateMod);
		}
	}
	
	return FMax(0.0005, SpawnRateMod);
}

/** Return the damage resistance modifier */
function float GetDamageResistanceModifier( byte NumLivingPlayers )
{
	local float DamageResistanceMod;
	local byte i;
	
	DamageResistanceMod = GetNumPlayersModifier( NumPlayers_ZedDamageResistance, NumLivingPlayers );
	
	// Zed buff
	if (WMGRI == none)
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
	if (WMGRI != none)
	{
		for (i=0;i<WMGRI.zedBuffs.length;i+=1)
		{
			if (WMGRI.bZedBuffs[i]>0)
				WMGRI.zedBuffs[i].static.ModifyDamageResistanceMod(DamageResistanceMod, NumLivingPlayers);
		}
	}
	
	return FMax(0.1f, DamageResistanceMod);
}

defaultproperties
{
	CustomDifficulty = 4.0;
	CustomMode = false;
	Normal = (TraderTime=75,MovementSpeedMod=0.900000,WaveCountMod=0.850000,DoshKillMod=1.200000,StartingDosh=300,AmmoPickupsMod=0.400000,ItemPickupsMod=0.450000,SelfInflictedDamageMod=0.100000,SpawnRateModifier=0.800000);
	Hard = (MovementSpeedMod=0.950000,RespawnDosh=300,AmmoPickupsMod=0.300000,ItemPickupsMod=0.350000,SelfInflictedDamageMod=0.200000,SpawnRateModifier=0.800000);
	Suicidal = (MovementSpeedMod=0.950000,WaveCountMod=1.300000,AmmoPickupsMod=0.400000,ItemPickupsMod=0.250000,MediumAttackChance=1.000000,HardAttackChance=0.500000,SelfInflictedDamageMod=0.200000,SpawnRateModifier=0.700000);
	HellOnEarth = (MovementSpeedMod=0.950000,WaveCountMod=1.700000,DoshKillMod=0.900000,AmmoPickupsMod=0.250000,ItemPickupsMod=0.100000,MediumAttackChance=1.000000,HardAttackChance=1.000000,SelfInflictedDamageMod=0.500000,SpawnRateModifier=0.680000);
	Name = "Default__KFGameDifficulty_Survival";
	ObjectArchetype = KFGameDifficultyInfo'KFGame.Default__KFGameDifficultyInfo';
}