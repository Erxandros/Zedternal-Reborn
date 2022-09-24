Class WMGFxScoreBoardStyle extends WMGFxScoreBoardStyleBase;

var Font DrawFont;

const TOOLTIP_BORDER = 4;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	DrawFont = Font(DynamicLoadObject("UI_Canvas_Fonts.Font_Main", class'Font'));
}

function Font PickFont(byte i, out float Scaler)
{
	Scaler = 0.4 + 0.1 * i;
	return DrawFont;
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
	Name="Default__WMGFxScoreBoardStyle"
}
