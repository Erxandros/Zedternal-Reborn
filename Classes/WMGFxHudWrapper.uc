class WMGFxHudWrapper extends KFGFxHudWrapper;

var Texture2D backgroundIcon;
var int zedBuffIndex;
var float bgFactor;

simulated function PostBeginPlay()
{
	SetTimer(1.5f, true, nameof(UpdateWarningString));

	super.PostBeginPlay();
}

event DrawHUD()
{
	local string buffTitle, spwTitle;
	local Texture2D buffIcon;
	local int i, nb, total;
	local float size;
	local float xl, yl, X, Y;
	local float iconFactor;
	local WMGameReplicationInfo WMGRI;

	super.DrawHUD();

	WMGRI = WMGameReplicationInfo(KFGRI);
	if (WMGRI == none)
		return;

	Canvas.Font = Font(DynamicLoadObject("UI_Canvas_Fonts.Font_General", class'Font'));

	//////////////////////////////////////////////
	//////////// SPECIAL WAVES ///////////////////
	//////////////////////////////////////////////

	if (!WMGRI.bTraderIsOpen && WMGRI.SpecialWaveID[0] != -1 && WMGRI.bDrawSpecialWave)
	{
		size = 0.5;

		//draw warning
		if (WMGRI.SpecialWaveID[1] == -1)
			spwTitle = WMGRI.specialWaves[WMGRI.SpecialWaveID[0]].default.Title;
		else
			spwTitle = WMGRI.specialWaves[WMGRI.SpecialWaveID[0]].default.Title $ " + " $ WMGRI.specialWaves[WMGRI.SpecialWaveID[1]].default.Title;

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
		Canvas.DrawText(spwTitle, true, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(spwTitle, true, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(spwTitle, true, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(spwTitle, true, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(spwTitle, true, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 20, 20, 255);
		Canvas.DrawText(spwTitle, true, size, size);
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

	for (i = 0; i < WMGRI.zedBuffs.length; ++i)
	{
		if (WMGRI.bZedBuffs[i] == 1)
			++total;
	}

	if (bgFactor == 0)
		bgFactor = 0.0474072 * Canvas.SizeX / backgroundIcon.SizeX;

	if (zedBuffIndex == 0)
	{
		size = 0.65;

		//draw warning
		buffTitle = "!!! ZEDS ARE EVOLVING !!!";
		Canvas.StrLen(buffTitle, XL, YL);
		XL *= size;
		YL *= size;
		X = Canvas.SizeX * 0.5f - XL / 2;
		Y = Canvas.SizeY * 0.022f + 0.0474072 * Canvas.SizeX * 1.05f;

		////////////////////////////////////////////////
		////////////////////////////////////////////////
		//draw shadow
		Canvas.SetDrawColor(0, 0, 0, 100);
		Canvas.SetPos(X - 2, Y + 2);
		Canvas.DrawText(buffTitle, true, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(buffTitle, true, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 130, 20, 255);
		Canvas.DrawText(buffTitle, true, size, size);
		////////////////////////////////////////////////
		////////////////////////////////////////////////
	}
	else if (zedBuffIndex != -1)
	{
		size = 0.55;

		buffTitle = WMGRI.zedBuffs[zedBuffIndex - 1].default.buffDescription;
		Canvas.StrLen(buffTitle, XL, YL);
		XL *= size;
		YL *= size;
		X = Canvas.SizeX * 0.5f - XL / 2;
		Y = Canvas.SizeY * 0.022f + 0.0474072 * Canvas.SizeX * 1.05f;
		////////////////////////////////////////////////
		////////////////////////////////////////////////
		//draw shadow
		Canvas.SetDrawColor(0, 0, 0, 100);
		Canvas.SetPos(X - 2, Y + 2);
		Canvas.DrawText(buffTitle, true, size, size);

		//draw outlines
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.SetPos(X - 1, Y - 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X - 1, Y + 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X + 1, Y - 1);
		Canvas.DrawText(buffTitle, true, size, size);
		Canvas.SetPos(X + 1, Y + 1);
		Canvas.DrawText(buffTitle, true, size, size);

		//draw text
		Canvas.SetPos(X, Y);
		Canvas.SetDrawColor(225, 20, 20, 255);
		Canvas.DrawText(buffTitle, true, size, size);
		////////////////////////////////////////////////
		////////////////////////////////////////////////
	}

	for (i = 0; i < WMGRI.zedBuffs.length; ++i)
	{
		if (WMGRI.bZedBuffs[i] == 1)
		{
			buffIcon = WMGRI.zedBuffs[i].default.buffIcon;
			iconFactor = 0.0474072 * Canvas.SizeX / buffIcon.SizeX;

			//draw icon
			Y = Canvas.SizeY * 0.022f;
			X = Canvas.SizeX * 0.5f - (float(buffIcon.SizeX) * iconFactor * (0.5f * float(total) - nb));
			Canvas.SetPos(X, Y);
			Canvas.SetDrawColor(210, 210, 210, 255);
			Canvas.DrawTexture(backgroundIcon, bgFactor);

			if (i == zedBuffIndex-1)
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
			++nb;
		}
	}
}

simulated function ResestWarningMessage()
{
	ClearTimer(nameof(UpdateWarningString));

	zedBuffIndex = 0;

	SetTimer(1.5f, true, nameof(UpdateWarningString));
}

simulated function UpdateWarningString()
{
	local WMGameReplicationInfo WMGRI;
	local int count;

	WMGRI = WMGameReplicationInfo(KFGRI);
	if(WMGRI == none)
		return;

	zedBuffIndex = Max(1, zedBuffIndex + 1);
	count = 0;
	while(zedBuffIndex <= 255 && WMGRI.bZedBuffs[zedBuffIndex - 1] == 0 && count <= 255)
	{
		++zedBuffIndex;
		++count;
		if (zedBuffIndex == 256)
			zedBuffIndex = 1;
	}
	if (count == 256)
		zedBuffIndex = -1;
}

defaultproperties
{
	HUDClass=Class'ZedternalReborn.WMGFxMoviePlayer_HUD'
	backgroundIcon=Texture2D'ZedternalReborn_Resource.ZedBuff_Background'
	zedBuffIndex=-1
	bgFactor=0
	Name="Default__WMGFxHudWrapper"
}
