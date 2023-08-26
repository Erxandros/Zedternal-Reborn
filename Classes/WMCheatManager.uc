class WMCheatManager extends KFCheatManager;

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

	KFPH = Spawn(class'KFPawn_Human', , , HitLocation);
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

	KFPH.AddDefaultInventory();
}

defaultproperties
{
	Name="Default__WMCheatManager"
}
