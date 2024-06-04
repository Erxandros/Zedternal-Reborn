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
	local Vector2D ViewportSize;
	local GFXSettings Settings;

	LocalPlayer(PlayerOwner.Player).ViewportClient.GetViewportSize(ViewportSize);
	class'KFGFxOptionsMenu_Graphics'.static.GetCurrentNativeSettings(Settings);
	ScoreBoard.PickDefaultFontSize(ViewportSize.X, ViewportSize.Y);

	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Font Scale:"@ScoreBoard.DefaultFontSize);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Font Height:"@ScoreBoard.DefaultHeight);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("ViewPort X:"@ViewportSize.X);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("ViewPort Y:"@ViewportSize.Y);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Resolution X:"@Settings.Resolution.ResX);
	LocalPlayer(PlayerOwner.Player).ViewportClient.ViewportConsole.OutputText("Resolution Y:"@Settings.Resolution.ResY);
}

defaultproperties
{
	Name="Default__WMGFxScoreBoardWrapper"
}
