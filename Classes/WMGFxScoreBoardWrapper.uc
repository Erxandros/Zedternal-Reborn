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

defaultproperties
{
	Name="Default__WMGFxScoreBoardWrapper"
}
