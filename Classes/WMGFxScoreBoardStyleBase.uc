Class WMGFxScoreBoardStyleBase extends Actor
	abstract;

var Texture2D ItemTex; // Perk Icon
var() byte MaxFontScale;
var byte DefaultFontSize; // Default medium font size of current resolution.
var float DefaultHeight; // Default font text size.
var transient Canvas ScoreBoardCanvas; // The ScoreBoardCanvas canvas object

//function InitStyle()
function PostBeginPlay()
{
	ItemTex = Texture2D(DynamicLoadObject("UI_LevelChevrons_TEX.UI_LevelChevron_Icon_02", class'Texture2D'));
	if (ItemTex == None)
		ItemTex = Texture2D'EngineMaterials.DefaultWhiteGrid';
}

function Font PickFont(byte i, out float Scaler);

function PickDefaultFontSize(float YRes)
{
	local int XL, YL;
	local string S;

	DefaultFontSize = 0;
	if (YRes > 800)
		++DefaultFontSize;
	if (YRes > 1000)
		++DefaultFontSize;
	if (YRes > 1300)
		++DefaultFontSize;
	if (YRes > 1500)
		++DefaultFontSize;

	S = "ABC";
	PickFont(DefaultFontSize, YRes).GetStringHeightAndWidth(S, YL, XL);
	DefaultHeight = float(YL) * YRes;
}

final function DrawText(byte Res, string S)
{
	local float Scale;

	ScoreBoardCanvas.Font = PickFont(Res, Scale);
	ScoreBoardCanvas.DrawText(S, , Scale, Scale);
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
	ObjectArchetype=Actor'Engine.Default__Actor'
	Name="Default__WMGFxScoreBoardStyleBase"
}
