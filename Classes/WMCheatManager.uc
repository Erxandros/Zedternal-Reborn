class WMCheatManager extends KFCheatManager;

struct S_ZedType
{
	var string SearchName;
	var class<KFPawn_Monster> ZedClass;
};
var const array<S_ZedType> ZedTypes;

function InitCheatManager()
{
	super.InitCheatManager();

	if (WMGameInfo_Endless(WorldInfo.Game) != None)
		WMGameInfo_Endless(WorldInfo.Game).bDisableZedAICheck = True;
}

function class<KFPawn_Monster> LoadMonsterByName(string ZedName, optional bool bIsVersusPawn)
{
	local byte b;
	local class<KFPawn_Monster> SpawnClass;

	if (bIsVersusPawn)
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("Versus ZEDs are not supported in Zedternal Reborn debug spawning");
		return None;
	}

	for (b = 0; b < ZedTypes.Length; ++b)
	{
		if (ZedTypes[b].SearchName ~= ZedName)
		{
			SpawnClass = ZedTypes[b].ZedClass;
			break;
		}
	}

	if (SpawnClass == None)
	{
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("Could not spawn ZED ["$ZedName$"]. Use GetZedNameList command to get a list of valid ZED names.");
		return None;
	}

	return SpawnClass;
}

exec function GetZedNameList()
{
	local byte b;
	local string Info;

	Info = ZedTypes[0].SearchName @ "-" @ ZedTypes[0].ZedClass.static.GetLocalizedName();
	for (b = 1; b < ZedTypes.Length; ++b)
	{
		Info = Info $ "\n" $ ZedTypes[b].SearchName @ "-" @ ZedTypes[b].ZedClass.static.GetLocalizedName();
	}

	LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(Info);
}

exec function GetCharIndexList()
{
	local byte b;
	local string Info;

	Info = "0 -" @ class'KFGame.KFPlayerReplicationInfo'.default.CharacterArchetypes[0].Name;
	for (b = 1; b < class'KFGame.KFPlayerReplicationInfo'.default.CharacterArchetypes.Length; ++b)
	{
		Info = Info $ "\n" $ b @ "-" @ class'KFGame.KFPlayerReplicationInfo'.default.CharacterArchetypes[b].Name;
	}

	LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(Info);
}

exec function SpawnHumanPawn(optional bool bEnemy, optional bool bUseGodMode, optional int CharIndex)
{
	local KFAIController KFBot;
	local KFPlayerReplicationInfo KFPRI;
	local vector CamLoc;
	local rotator CamRot;
	Local KFPawn_Human KFPH;
	local Vector HitLocation, HitNormal;
	local Actor TraceOwner;

	GetPlayerViewPoint(CamLoc, CamRot);

	if (Pawn != None)
		TraceOwner = Pawn;
	else
		TraceOwner = Outer;

	TraceOwner.Trace(HitLocation, HitNormal, CamLoc + Vector(CamRot) * 250000, CamLoc, True, vect(0, 0, 0));

	HitLocation.Z += 100;

	KFPH = KFPawn_Human(Spawn(WorldInfo.Game.default.DefaultPawnClass, , , HitLocation));
	KFPH.SetPhysics(PHYS_Falling);

	// Create a new Controller for this Bot
	KFBot = Spawn(class'KFAIController');

	// Silly name for now
	WorldInfo.Game.ChangeName(KFBot, "Braindead Human", False);

	// Add them to the Team they selected
	if (!bEnemy)
	   KFGameInfo(WorldInfo.Game).SetTeam(KFBot, KFGameInfo(WorldInfo.Game).Teams[0]);

	KFBot.Possess(KFPH, False);

	if (bUseGodMode)
	   KFBot.bGodMode = True;

	KFPRI = KFPlayerReplicationInfo(KFBot.PlayerReplicationInfo);

	// Set perk stuff
	if (KFPRI.CharacterArchetypes.Length > CharIndex)
		KFPH.SetCharacterArch(KFPRI.CharacterArchetypes[CharIndex]);
	else
		LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText("CharIndex" @ CharIndex @ "is out of bounds, defaulting to 0");

	KFPRI.CurrentPerkClass = class'WMPlayerController'.default.PerkList[0].PerkClass;
	KFPRI.NetPerkIndex = 0;

	if (KFPRI != None)
	{
		KFPRI.PLayerHealthPercent = FloatToByte(float(KFPH.Health) / float(KFPH.HealthMax));
		KFPRI.PLayerHealth = KFPH.Health;
	}

	if (KFInventoryManager(KFPH.InvManager) != None)
	{
		KFInventoryManager(KFPH.InvManager).bSuppressPickupMessages = True;
		KFPH.InvManager.CreateInventory(class'KFGameContent.KFWeap_Pistol_9mm');
	}
}

defaultproperties
{
	// Clot
	ZedTypes.Add((SearchName="Cyst",ZedClass=class'KFGameContent.KFPawn_ZedClot_Cyst'))
	ZedTypes.Add((SearchName="Alpha",ZedClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot'))
	ZedTypes.Add((SearchName="Rioter",ZedClass=class'KFGameContent.KFPawn_ZedClot_AlphaKing'))
	ZedTypes.Add((SearchName="Slasher",ZedClass=class'KFGameContent.KFPawn_ZedClot_Slasher'))
	ZedTypes.Add((SearchName="Slasher_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega'))

	// Crawler
	ZedTypes.Add((SearchName="Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite'))
	ZedTypes.Add((SearchName="Elite_Crawler",ZedClass=class'KFGameContent.KFPawn_ZedCrawlerKing'))
	ZedTypes.Add((SearchName="Mini_Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_Mini'))
	ZedTypes.Add((SearchName="Medium_Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_Medium'))
	ZedTypes.Add((SearchName="Big_Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_Big'))
	ZedTypes.Add((SearchName="Huge_Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_Huge'))
	ZedTypes.Add((SearchName="Ultra_Crawler",ZedClass=class'ZedternalReborn.WMPawn_ZedCrawler_Ultra'))

	// Gorefast
	ZedTypes.Add((SearchName="Gorefast",ZedClass=class'ZedternalReborn.WMPawn_ZedGorefast_NoDualBlade'))
	ZedTypes.Add((SearchName="Gorefiend",ZedClass=class'KFGameContent.KFPawn_ZedGorefastDualBlade'))
	ZedTypes.Add((SearchName="Gorefast_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedGorefast_Omega'))

	// Stalker
	ZedTypes.Add((SearchName="Stalker",ZedClass=class'ZedternalReborn.WMPawn_ZedStalker_NoDAR'))
	ZedTypes.Add((SearchName="Stalker_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedStalker_Omega'))

	// Bloat
	ZedTypes.Add((SearchName="Bloat",ZedClass=class'KFGameContent.KFPawn_ZedBloat'))
	ZedTypes.Add((SearchName="Abomination_Spawn",ZedClass=class'KFGameContent.KFPawn_ZedBloatKingSubspawn'))

	// Husk
	ZedTypes.Add((SearchName="Husk",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR'))
	ZedTypes.Add((SearchName="Tiny_Husk",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_Tiny'))
	ZedTypes.Add((SearchName="Tiny_Husk_Green",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Green'))
	ZedTypes.Add((SearchName="Tiny_Husk_Blue",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Blue'))
	ZedTypes.Add((SearchName="Tiny_Husk_Pink",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_Tiny_Pink'))
	ZedTypes.Add((SearchName="Husk_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedHusk_Omega'))

	// Siren
	ZedTypes.Add((SearchName="Siren",ZedClass=class'KFGameContent.KFPawn_ZedSiren'))
	ZedTypes.Add((SearchName="Siren_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedSiren_Omega'))

	// DAR
	ZedTypes.Add((SearchName="Rocket_DAR",ZedClass=class'KFGameContent.KFPawn_ZedDAR_Rocket'))
	ZedTypes.Add((SearchName="Laser_DAR",ZedClass=class'KFGameContent.KFPawn_ZedDAR_Laser'))
	ZedTypes.Add((SearchName="EMP_DAR",ZedClass=class'KFGameContent.KFPawn_ZedDAR_EMP'))

	// Scrake
	ZedTypes.Add((SearchName="Scrake",ZedClass=class'KFGameContent.KFPawn_ZedScrake'))
	ZedTypes.Add((SearchName="Tiny_Scrake",ZedClass=class'ZedternalReborn.WMPawn_ZedScrake_Tiny'))
	ZedTypes.Add((SearchName="Scrake_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedScrake_Omega'))
	ZedTypes.Add((SearchName="Emperor",ZedClass=class'ZedternalReborn.WMPawn_ZedScrake_Emperor'))

	// Fleshpound
	ZedTypes.Add((SearchName="Fleshpound",ZedClass=class'KFGameContent.KFPawn_ZedFleshpound'))
	ZedTypes.Add((SearchName="Mini_Fleshpound",ZedClass=class'KFGameContent.KFPawn_ZedFleshpoundMini'))
	ZedTypes.Add((SearchName="Fleshpound_Omega",ZedClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Omega'))
	ZedTypes.Add((SearchName="Predator",ZedClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Predator'))

	// Bosses
	ZedTypes.Add((SearchName="Abomination",ZedClass=class'ZedternalReborn.WMPawn_ZedBloatKing'))
	ZedTypes.Add((SearchName="King_Fleshpound",ZedClass=class'ZedternalReborn.WMPawn_ZedFleshpoundKing'))
	ZedTypes.Add((SearchName="Hans",ZedClass=class'ZedternalReborn.WMPawn_ZedHans'))
	ZedTypes.Add((SearchName="Matriarch",ZedClass=class'ZedternalReborn.WMPawn_ZedMatriarch'))
	ZedTypes.Add((SearchName="Patriarch",ZedClass=class'ZedternalReborn.WMPawn_ZedPatriarch'))

	Name="Default__WMCheatManager"
}
