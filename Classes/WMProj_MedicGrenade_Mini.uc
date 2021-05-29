class WMProj_MedicGrenade_Mini extends KFProj_MedicGrenade_Mini;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	AdjustCanDisintigrate();
}

defaultproperties
{
	Name="Default__WMProj_MedicGrenade_Mini"
}
