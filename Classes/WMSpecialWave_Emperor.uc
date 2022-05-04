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
	ZedSpawnRateFactor=0.95f
	WaveValueFactor=0.75f
	DoshFactor=1.4f

	Title="Emperor"
	Description="He is scary..."

	Name="Default__WMSpecialWave_Emperor"
}
