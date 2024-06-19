Class WMGFxScoreBoardStyleBase extends Actor
	abstract;

var byte OverrideFontSize; // A user settable override for the font size

var Texture2D ItemTex;
var Font DrawFont; // The KF2 Canvas Font

var transient byte DefaultFontSize; // Default font size for the current resolution.
var transient float DefaultHeight; // Default font height size for the current resolution.
var transient Canvas ScoreBoardCanvas; // The ScoreBoardCanvas canvas object

function PostBeginPlay()
{
	ScoreBoardCanvas = new class 'Engine.Canvas';
	ItemTex = Texture2D(DynamicLoadObject("UI_LevelChevrons_TEX.UI_LevelChevron_Icon_02", class'Texture2D'));
	if (ItemTex == None)
		ItemTex = Texture2D'EngineMaterials.DefaultWhiteGrid';
	DrawFont = class'KFGameEngine'.Static.GetKFCanvasFont();
}

static function GetNativeResolution(out IntPoint resolution)
{
	local GFXSettings Settings;

	class'KFGFxOptionsMenu_Graphics'.static.GetCurrentNativeSettings(Settings);

	resolution.X = Settings.Resolution.ResX;
	resolution.Y = Settings.Resolution.ResY;
}

function PickDefaultFontSize(int SizeX, out float Scaler)
{
	local IntPoint NativeResolution;
	local int XL, YL;
	local string S;

	GetNativeResolution(NativeResolution);

	if (OverrideFontSize == 0)
		DefaultFontSize = Max(6, Round(Loge(SizeX - 420) ** 1.6f - 8.5f));
	else
		DefaultFontSize = OverrideFontSize;

	Scaler = 0.05f * DefaultFontSize / (float(NativeResolution.X) / float(SizeX));

	S = "ABC";
	DrawFont.GetStringHeightAndWidth(S, YL, XL);
	DefaultHeight = float(YL) * Scaler;
}

function float AdjustPlayerNameScaler(float Scaler, byte NameLength, byte FontType)
{
	local float modifer;

	if (FontType == 0)
		modifer = 0.25;
	else if (FontType == 1)
		modifer = 0.1875;
	else
		modifer = 0.0;

	if (NameLength > 24)
		return Scaler * 0.625 + modifer;
	else if (NameLength > 16)
		return Scaler * 0.75 + modifer;
	else
		return Scaler;
}

final function DrawCornerTexNU(int SizeX, int SizeY, byte Dir) // Draw non-uniform corner.
{
	switch (Dir)
	{
		case 0: // Up-left
			ScoreBoardCanvas.DrawTile(ItemTex, SizeX, SizeY, 77, 15, -66, 58);
			break;
		case 1: // Up-right
			ScoreBoardCanvas.DrawTile(ItemTex, SizeX, SizeY, 11, 15, 66, 58);
			break;
		case 2: // Down-left
			ScoreBoardCanvas.DrawTile(ItemTex, SizeX, SizeY, 77, 73, -66, -58);
			break;
		default: // Down-right
			ScoreBoardCanvas.DrawTile(ItemTex, SizeX, SizeY, 11, 73, 66, -58);
	}
}

final function DrawCornerTex(int Size, byte Dir)
{
	switch (Dir)
	{
		case 0: // Up-left
			ScoreBoardCanvas.DrawTile(ItemTex, Size, Size, 77, 15, -66, 58);
			break;
		case 1: // Up-right
			ScoreBoardCanvas.DrawTile(ItemTex, Size, Size, 11, 15, 66, 58);
			break;
		case 2: // Down-left
			ScoreBoardCanvas.DrawTile(ItemTex, Size, Size, 77, 73, -66, -58);
			break;
		default: // Down-right
			ScoreBoardCanvas.DrawTile(ItemTex, Size, Size, 11, 73, 66, -58);
	}
}

final function DrawWhiteBox(int XS, int YS)
{
	ScoreBoardCanvas.DrawTile(ItemTex, XS, YS, 19, 45, 1, 1);
}

final function DrawRectBox(int X, int Y, int XS, int YS, int Edge, optional byte Extrav)
{
	if (Extrav == 2)
		Edge = Min(FMin(Edge, XS * 0.5), YS);// Verify size.
	else
		Edge = Min(FMin(Edge, XS * 0.5), YS * 0.5);// Verify size.

	// Top left
	ScoreBoardCanvas.SetPos(X, Y);
	DrawCornerTex(Edge, 0);

	if (Extrav <= 1)
	{
		if (Extrav == 0)
		{
			// Top right
			ScoreBoardCanvas.SetPos(X + XS - Edge, Y);
			DrawCornerTex(Edge, 1);

			// Bottom right
			ScoreBoardCanvas.SetPos(X + XS - Edge, Y + YS - Edge);
			DrawCornerTex(Edge, 3);

			// Fill
			ScoreBoardCanvas.SetPos(X + Edge, Y);
			DrawWhiteBox(XS - Edge * 2, YS);
			ScoreBoardCanvas.SetPos(X, Y + Edge);
			DrawWhiteBox(Edge, YS - Edge * 2);
			ScoreBoardCanvas.SetPos(X + XS - Edge, Y + Edge);
			DrawWhiteBox(Edge, YS - Edge * 2);
		}
		else if (Extrav == 1)
		{
			// Top right
			ScoreBoardCanvas.SetPos(X + XS, Y);
			DrawCornerTex(Edge, 3);

			// Bottom right
			ScoreBoardCanvas.SetPos(X + XS, Y + YS - Edge);
			DrawCornerTex(Edge, 1);

			// Fill
			ScoreBoardCanvas.SetPos(X + Edge, Y);
			DrawWhiteBox(XS - Edge, YS);
			ScoreBoardCanvas.SetPos(X, Y + Edge);
			DrawWhiteBox(Edge, YS - Edge * 2);
		}

		// Bottom left
		ScoreBoardCanvas.SetPos(X, Y + YS - Edge);
		DrawCornerTex(Edge, 2);
	}
	else
	{
		// Top right
		ScoreBoardCanvas.SetPos(X + XS - Edge, Y);
		DrawCornerTex(Edge, 1);

		// Bottom right
		ScoreBoardCanvas.SetPos(X + XS - Edge, Y + YS);
		DrawCornerTex(Edge, 2);

		// Bottom left
		ScoreBoardCanvas.SetPos(X, Y + YS);
		DrawCornerTex(Edge, 3);

		// Fill
		ScoreBoardCanvas.SetPos(X, Y + Edge);
		DrawWhiteBox(XS, YS - Edge);
		ScoreBoardCanvas.SetPos(X + Edge, Y);
		DrawWhiteBox(XS - Edge * 2, Edge);
	}
}

defaultproperties
{
	OverrideFontSize=0

	Name="Default__WMGFxScoreBoardStyleBase"
}
