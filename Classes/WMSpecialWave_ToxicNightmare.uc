class WMSpecialWave_ToxicNightmare extends WMSpecialWave;

var class<KFProj_BloatPukeMine> PukeMineProjectileClass;
var float Delay, Probability;
var int DesiredMines, nbPoint;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(3.0f, False, NameOf(UpdateMines));
}

function UpdateMines()
{
	local KFPathnode KFPN;
	local int Count;
	local rotator rot;

	Count = 0;
	foreach WorldInfo.AllActors(class'KFGame.KFPathnode', KFPN)
	{
		if (nbPoint == -1)
			++Count;
		else if (FRand() < Probability)
		{
			rot = KFPN.Rotation;
			rot.Pitch = 0;
			Spawn(PukeMineProjectileClass, KFPN, , KFPN.Location, rot, , True);
		}
	}

	if (nbPoint == -1)
	{
		nbPoint = Count;
		if (Count > 0)
			Probability = float(default.DesiredMines) / float(Count);
		else
			Probability = 0;

		if (Probability > 0)
			SetTimer(1.0f, False, NameOf(UpdateMines));
	}
	else if (Probability > 0)
	{
		Probability = Probability * 0.5;
		SetTimer(default.Delay, False, NameOf(UpdateMines));
	}
}

defaultproperties
{
	PukeMineProjectileClass=class'kfgamecontent.KFProj_BloatPukeMine'
	Delay=30.0f
	Probability=0.0f
	DesiredMines=65
	nbPoint=-1
	zedSpawnRateFactor=0.85f
	waveValueFactor=0.9f
	doshFactor=1.1f

	Title="Toxic Nightmare"
	Description="Watch for the mines!"

	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedBloat')
	MonsterToAdd(1)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedBloat')
	MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedBloat')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedCrawlerKing')
	MonsterToAdd(4)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedCrawlerKing')
	MonsterToAdd(5)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedBloatKingSubspawn')

	Name="Default__WMSpecialWave_ToxicNightmare"
}
