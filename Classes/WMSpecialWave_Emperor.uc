class WMSpecialWave_Emperor extends WMSpecialWave;

var class<KFPawn_Monster> EmperorClass;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(6.0f, False, NameOf(SpawnEmperor));
}

function SpawnEmperor()
{
	local array< class<KFPawn_Monster> > Emperor;

	Emperor.AddItem(default.EmperorClass);

	AddNewZedGroupToSpawnList(0, Emperor);
}

defaultproperties
{
	EmperorClass=class'ZedternalReborn.WMPawn_ZedScrake_Emperor'
	zedSpawnRateFactor=0.95f
	waveValueFactor=0.75f
	doshFactor=1.4f

	Title="Emperor"
	Description="He is scary..."

	Name="Default__WMSpecialWave_Emperor"
}
