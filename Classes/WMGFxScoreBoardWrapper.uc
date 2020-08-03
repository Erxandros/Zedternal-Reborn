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
	ObjectArchetype=KFGFxHudWrapper'KFGame.Default__KFGFxHudWrapper'
	Name="Default__WMGFxScoreBoardWrapper"
}
