class WMProj_MedicGrenade extends KFProj_MedicGrenade
	hidedropdown;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	AdjustCanDisintigrate();
}

defaultproperties
{
	Name="Default__WMProj_MedicGrenade"
}
