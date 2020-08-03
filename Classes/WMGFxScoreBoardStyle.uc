Class WMGFxScoreBoardStyle extends WMGFxScoreBoardStyleBase;

var Font DrawFonts[3];

const TOOLTIP_BORDER = 4;

//function InitStyle()
function PostBeginPlay()
{
	local byte i;

	Super.PostBeginPlay();

	DrawFonts[0] = Font(DynamicLoadObject("UI_Canvas_Fonts.Font_General", class'Font'));
	DrawFonts[1] = Font(DynamicLoadObject("EngineFonts.SmallFont", class'Font'));
	DrawFonts[2] = Font(DynamicLoadObject("EngineFonts.TinyFont", class'Font'));
	for (i = 0; i < ArrayCount(DrawFonts); ++i)
	{
		if (DrawFonts[i] == None)
			DrawFonts[i] = class'Engine'.Static.GetMediumFont();
	}
}

function Font PickFont(byte i, out float Scaler)
{
	switch (i)
	{
		case 0:
			Scaler = 1;
			return DrawFonts[2];
		case 1:
			Scaler = 1;
			return DrawFonts[1];
		case 2:
			Scaler = 0.4;
			return DrawFonts[0];
		case 3:
			Scaler = 0.6;
			return DrawFonts[0];
		case 4:
			Scaler = 0.8;
			return DrawFonts[0];
		default:
			Scaler = 1;
			return DrawFonts[0];
	}
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

defaultproperties
{
	MaxFontScale=5
	ObjectArchetype=WMGFxScoreBoardStyleBase'ZedternalReborn.Default__WMGFxScoreBoardStyleBase'
	Name="Default__WMGFxScoreBoardStyle"
}
