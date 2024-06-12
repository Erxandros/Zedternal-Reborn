class WMGFxScoreBoardWrapper extends WMGFxHudWrapper;

var WMGFxHudScoreBoard ScoreBoard;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	ScoreBoard = spawn(class'WMGFxHudScoreBoard');
}

event PostRender()
{
	super.PostRender();

	if (bShowScores)
		ScoreBoard.Draw(Canvas);
}

exec function SetShowScores(bool show)
{
	super.SetShowScores(false);

	bShowScores = show;	// TWI don't set this
}

exec function ZRDebugScoreBoard()
{
	local IntPoint NativeResolution;
	local float Scaler;

	ScoreBoard.GetNativeResolution(NativeResolution);
	ScoreBoard.PickDefaultFontSize(SizeX, SizeY, Scaler);

	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Font Size:"@ScoreBoard.DefaultFontSize);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Font Scaler:"@Scaler);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("NativeToViewPort Ratio:"@ScoreBoard.NativeToViewportRatio);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("ViewPort X:"@SizeX);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("ViewPort Y:"@SizeY);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Resolution X:"@NativeResolution.X);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Resolution Y:"@NativeResolution.Y);
}

exec function ZRSetScoreBoardSize(int FontSize)
{
	if (FontSize >= 0 && FontSize < 256)
	{
		ScoreBoard.OverrideFontSize = FontSize;
		LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Set score board font size to" @ FontSize);
	}
	else
	{
		LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Font size must be between 0 to 255");
	}
}

exec function ZRClearScoreBoardSize()
{
	ScoreBoard.OverrideFontSize = INDEX_NONE;
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Score board override font size reset back to auto scaling");
}

defaultproperties
{
	Name="Default__WMGFxScoreBoardWrapper"
}
