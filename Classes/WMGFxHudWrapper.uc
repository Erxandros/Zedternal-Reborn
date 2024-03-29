class WMGFxHudWrapper extends KFGFxHudWrapper;

var Texture2D backgroundIcon;
var int zedBuffIndex;
var float bgFactor;

var const color SupplierThirdUsableColor;

var localized string ZedBuffEvolvingString;

simulated function PostBeginPlay()
{
	SetTimer(1.5f, True, NameOf(UpdateWarningString));

	super.PostBeginPlay();
}

event DrawHUD()
{
	local string buffTitle, buffStack, spwTitle;
	local Texture2D buffIcon;
	local int i, nb, total;
	local float size;
	local float xl, yl, X, Y;
	local float iconFactor;
	local WMGameReplicationInfo WMGRI;

	super.DrawHUD();

	WMGRI = WMGameReplicationInfo(KFGRI);
	if (WMGRI == None)
		return;

	Canvas.Font = class'KFGameEngine'.Static.GetKFCanvasFont();

	//////////////////////////////////////////////
	//////////// SPECIAL WAVES ///////////////////
	//////////////////////////////////////////////

	if (!WMGRI.bTraderIsOpen && WMGRI.SpecialWaveID[0] != INDEX_NONE && WMGRI.bDrawSpecialWave)
	{
		size = 0.75f;

		//draw warning
		if (WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[0]].SpecialWave.default.bShouldLocalize)
			spwTitle = WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[0]].SpecialWave.static.GetSpecialWaveTitle();
		else
			spwTitle = WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[0]].SpecialWave.default.Title;

		if (WMGRI.SpecialWaveID[1] != INDEX_NONE)
		{
			if (WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[1]].SpecialWave.default.bShouldLocalize)
				spwTitle @= "+" @ WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[1]].SpecialWave.static.GetSpecialWaveTitle();
			else
				spwTitle @= "+" @ WMGRI.SpecialWavesList[WMGRI.SpecialWaveID[1]].SpecialWave.default.Title;
		}

		Canvas.StrLen(spwTitle, XL, YL);
		XL *= size;
		YL *= size;
		X = Canvas.SizeX * 0.5f - XL / 2;
		Y = Canvas.SizeY * 0.02f;

		////////////////////////////////////////////////
		////////////////////////////////////////////////
		//draw shadow
		Canvas.SetDrawColor(0, 0, 0, 100);
		Canvas.SetPos(X - 2, Y + 2);
		Canvas.DrawText(spwTitle, True, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(spwTitle, True, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(spwTitle, True, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(spwTitle, True, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(spwTitle, True, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 20, 20, 255);
		Canvas.DrawText(spwTitle, True, size, size);
		////////////////////////////////////////////////
		////////////////////////////////////////////////
	}

	///////////////////////////////////////////
	//draw ZEDBuff warning during trader time//
	///////////////////////////////////////////

	if(!WMGRI.bTraderIsOpen)
		return;

	nb = 0;
	total = 0;

	for (i = 0; i < WMGRI.ZedBuffsList.Length; ++i)
	{
		if (WMGRI.ActiveZedBuffs[i] > 0)
			++total;
	}

	if (bgFactor == 0)
		bgFactor = 0.0474072f * Canvas.SizeX / backgroundIcon.SizeX;

	if (zedBuffIndex == 0)
	{
		size = 0.975f;

		//draw warning
		buffTitle = default.ZedBuffEvolvingString;
		Canvas.StrLen(buffTitle, XL, YL);
		XL *= size;
		YL *= size;
		X = Canvas.SizeX * 0.5f - XL / 2;
		Y = Canvas.SizeY * 0.022f + 0.0474072f * Canvas.SizeX * 1.05f;

		////////////////////////////////////////////////
		////////////////////////////////////////////////
		//draw shadow
		Canvas.SetDrawColor(0, 0, 0, 100);
		Canvas.SetPos(X - 2, Y + 2);
		Canvas.DrawText(buffTitle, True, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(buffTitle, True, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 130, 20, 255);
		Canvas.DrawText(buffTitle, True, size, size);
		////////////////////////////////////////////////
		////////////////////////////////////////////////
	}
	else if (zedBuffIndex != INDEX_NONE)
	{
		size = 0.825f;

		if (WMGRI.ZedBuffsList[zedBuffIndex - 1].ZedBuff.default.bShouldLocalize)
			buffTitle = WMGRI.ZedBuffsList[zedBuffIndex - 1].ZedBuff.static.GetBuffDescription();
		else
			buffTitle = WMGRI.ZedBuffsList[zedBuffIndex - 1].ZedBuff.default.BuffDescription;

		if (WMGRI.ActiveZedBuffs[zedBuffIndex - 1] > 1)
			buffTitle = buffTitle @ "x" $ WMGRI.ActiveZedBuffs[zedBuffIndex - 1];

		Canvas.StrLen(buffTitle, XL, YL);
		XL *= size;
		YL *= size;
		X = Canvas.SizeX * 0.5f - XL / 2;
		Y = Canvas.SizeY * 0.022f + 0.0474072f * Canvas.SizeX * 1.05f;
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		//draw shadow
		Canvas.SetDrawColor(0, 0, 0, 100);
		Canvas.SetPos(X - 2, Y + 2);
		Canvas.DrawText(buffTitle, True, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(buffTitle, True, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(buffTitle, True, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 20, 20, 255);
		Canvas.DrawText(buffTitle, True, size, size);
		////////////////////////////////////////////////
		////////////////////////////////////////////////
	}

	for (i = 0; i < WMGRI.ZedBuffsList.Length; ++i)
	{
		if (WMGRI.ActiveZedBuffs[i] > 0)
		{
			buffIcon = WMGRI.ZedBuffsList[i].ZedBuff.default.buffIcon;
			iconFactor = 0.0474072f * Canvas.SizeX / buffIcon.SizeX;

			//draw icon
			Y = Canvas.SizeY * 0.022f;
			X = Canvas.SizeX * 0.5f - (float(buffIcon.SizeX) * iconFactor * (0.5f * float(total) - nb));
			Canvas.SetPos(X, Y);
			Canvas.SetDrawColor(210, 210, 210, 255);
			Canvas.DrawTexture(backgroundIcon, bgFactor);

			if (i == zedBuffIndex - 1)
			{
				Canvas.SetPos(X - 3, Y + 4);
				Canvas.SetDrawColor(85, 85, 85, 200);
				Canvas.DrawTexture(buffIcon, iconFactor);
				Canvas.SetPos(X + 1, Y - 1);
				Canvas.SetDrawColor(238, 238, 238, 255);
				Canvas.DrawTexture(buffIcon, iconFactor);
			}
			else
			{
				Canvas.SetPos(X - 2, Y + 3);
				Canvas.SetDrawColor(70, 70, 70, 200);
				Canvas.DrawTexture(buffIcon, iconFactor);
				Canvas.SetPos(X, Y);
				Canvas.SetDrawColor(160, 160, 160, 255);
				Canvas.DrawTexture(buffIcon, iconFactor);
			}

			// Stacked zed buffs
			if (WMGRI.ActiveZedBuffs[i] > 1)
			{
				size = 0.9f;
				buffStack = "x" $ string(WMGRI.ActiveZedBuffs[i]);

				//draw shadow
				Canvas.SetDrawColor(0, 0, 0, 100);
				Canvas.SetPos(X + (buffIcon.SizeX / 5) - 2, Y + 2);
				Canvas.DrawText(buffStack, True, size, size);

				//draw outlines
				Canvas.SetDrawColor(0, 0, 0, 255);
				Canvas.SetPos(X + (buffIcon.SizeX / 5) - 1, Y - 1);
				Canvas.DrawText(buffStack, True, size, size);
				Canvas.SetPos(X + (buffIcon.SizeX / 5) - 1, Y + 1);
				Canvas.DrawText(buffStack, True, size, size);
				Canvas.SetPos(X + (buffIcon.SizeX / 5) + 1, Y - 1);
				Canvas.DrawText(buffStack, True, size, size);
				Canvas.SetPos(X + (buffIcon.SizeX / 5) + 1, Y + 1);
				Canvas.DrawText(buffStack, True, size, size);

				//draw text
				Canvas.SetPos(X + (buffIcon.SizeX / 5), Y);
				Canvas.SetDrawColor(225, 20, 20, 255);
				Canvas.DrawText(buffStack, True, size, size);
			}

			++nb;
		}
	}
}

simulated function ResestWarningMessage()
{
	ClearTimer(NameOf(UpdateWarningString));

	zedBuffIndex = 0;

	SetTimer(1.5f, True, NameOf(UpdateWarningString));
}

simulated function UpdateWarningString()
{
	local WMGameReplicationInfo WMGRI;
	local int count;

	WMGRI = WMGameReplicationInfo(KFGRI);
	if(WMGRI == None)
		return;

	zedBuffIndex = Max(1, zedBuffIndex + 1);
	count = 0;
	while(zedBuffIndex <= 255 && WMGRI.ActiveZedBuffs[zedBuffIndex - 1] == 0 && count <= 255)
	{
		++zedBuffIndex;
		++count;
		if (zedBuffIndex == 256)
			zedBuffIndex = 1;
	}
	if (count == 256)
		zedBuffIndex = INDEX_NONE;
}

simulated function DrawPerkIcons(KFPawn_Human KFPH, float PerkIconSize, float PerkIconPosX, float PerkIconPosY, float SupplyIconPosX, float SupplyIconPosY, bool bDropShadow)
{
	local byte Count, PrestigeLevel;
	local WMPlayerReplicationInfo WMPRI;
	local color TempColor;
	local float ResModifier;

	WMPRI = WMPlayerReplicationInfo(KFPH.PlayerReplicationInfo);

	if (WMPRI == None)
		return;

	PrestigeLevel = WMPRI.GetActivePerkPrestigeLevel();
	ResModifier = WorldInfo.static.GetResolutionBasedHUDScale() * FriendlyHudScale;

	if (WMPRI.CurrentVoiceCommsRequest == VCT_NONE && WMPRI.CurrentPerkClass != None && PrestigeLevel > 0)
	{
		Canvas.SetPos(PerkIconPosX, PerkIconPosY);
		Canvas.DrawTile(WMPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], PerkIconSize, PerkIconSize, 0, 0, 256, 256);
	}

	if (PrestigeLevel > 0)
	{
		Canvas.SetPos(PerkIconPosX + (PerkIconSize * (1 - PrestigeIconScale)) / 2, PerkIconPosY + PerkIconSize * 0.05f);
		Canvas.DrawTile(WMPRI.GetCurrentIconToDisplay(), PerkIconSize * PrestigeIconScale, PerkIconSize * PrestigeIconScale, 0, 0, 256, 256);
	}
	else
	{
		Canvas.SetPos(PerkIconPosX, PerkIconPosY);
		Canvas.DrawTile(WMPRI.GetCurrentIconToDisplay(), PerkIconSize, PerkIconSize, 0, 0, 256, 256);
	}

	if (WMPRI.PerkSupplyLevel > 0 && WMPRI.CurrentPerkClass.static.GetInteractIcon() != None)
	{
		if (!bDropShadow)
		{
			Count = 0;
			if (WMPRI.PerkSupplyLevel == 3)
			{
				if (WMPRI.bPerkPrimarySupplyUsed)
					++Count;
				if (WMPRI.bPerkSecondarySupplyUsed)
					++Count;
				if (WMPRI.bPerkTertiarySupplyUsed)
					++Count;

				if (Count == 3)
				{
					TempColor = SupplierActiveColor;
				}
				else if (Count == 2)
				{
					TempColor = SupplierThirdUsableColor;
				}
				else if (Count == 1)
				{
					TempColor = SupplierHalfUsableColor;
				}
				else
				{
					TempColor = SupplierUsableColor;
				}
			}
			else if (WMPRI.PerkSupplyLevel == 2)
			{
				if (WMPRI.bPerkPrimarySupplyUsed)
					++Count;
				if (WMPRI.bPerkSecondarySupplyUsed)
					++Count;

				if (Count == 2)
				{
					TempColor = SupplierActiveColor;
				}
				else if (Count == 1)
				{
					TempColor = SupplierHalfUsableColor;
				}
				else
				{
					TempColor = SupplierUsableColor;
				}
			}
			else if (WMPRI.PerkSupplyLevel == 1)
			{
				TempColor = WMPRI.bPerkPrimarySupplyUsed ? SupplierActiveColor : SupplierUsableColor;
			}

			Canvas.SetDrawColorStruct(TempColor);
		}

		Canvas.SetPos(SupplyIconPosX, SupplyIconPosY);
		Canvas.DrawTile(WMPRI.CurrentPerkClass.static.GetInteractIcon(), (PlayerStatusIconSize * 0.75) * ResModifier, (PlayerStatusIconSize * 0.75) * ResModifier, 0, 0, 256, 256);
	}
}

defaultproperties
{
	HUDClass=Class'ZedternalReborn.WMGFxMoviePlayer_HUD'
	backgroundIcon=Texture2D'ZedternalReborn_Resource.ZedBuffs.UI_ZedBuff_Background'
	zedBuffIndex=INDEX_NONE
	bgFactor=0

	SupplierThirdUsableColor=(R=192, G=160, B=0, A=192)

	Name="Default__WMGFxHudWrapper"
}
