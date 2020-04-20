class WMSpecialWave_ToxicNightmare extends WMSpecialWave;

var float Probability, Delay;
var int nbPoint, desiredMines;
var class< KFProj_BloatPukeMine > PukeMineProjectileClass;

function PostBeginPlay()
{
	SetTimer(3.f,false,nameof(UpdateMines));
	super.PostBeginPlay();
}

function UpdateMines()
{
	local KFPathnode KFPN;
	local int count;
	local rotator rot;
	
	count = 0;
	ForEach WorldInfo.AllActors(class'KFGame.KFPathnode',KFPN)
	{
		if (nbPoint == -1)
			count++;
		else if (FRand() < Probability)
		{
			rot = KFPN.Rotation;
			rot.Pitch = 0;
			Spawn( PukeMineProjectileClass, KFPN,, KFPN.Location, rot,, true );
		}
	}
	
	if (nbPoint == -1)
	{
		nbPoint = count;
		if (count > 0)
			Probability = float(default.desiredMines) / float(count);
		else
			Probability = 0;
		
		if (Probability > 0)
			SetTimer(1.f,false,nameof(UpdateMines));
	}
	else if (Probability > 0)
	{
		Probability = Probability * 0.5;
		SetTimer(default.Delay,false,nameof(UpdateMines));
	}
}

defaultproperties
{
   Title="Toxic Nightmare"
   Description="Watch for the mines!"
   zedSpawnRateFactor=0.850000
   waveValueFactor=0.900000
   doshFactor=1.100000
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedBloat')
   MonsterToAdd(1)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedBloat')
   MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=3,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedBloat')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedCrawlerKing')
   MonsterToAdd(4)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedCrawlerKing')
   MonsterToAdd(5)=(MinWave=3,MaxWave=999,MinGr=2,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedBloatKingSubspawn')

   Probability=0.050000
   nbPoint=-1
   desiredMines=65
   Delay=30.000000
   PukeMineProjectileClass=Class'kfgamecontent.KFProj_BloatPukeMine'
   Name="Default__WMSpecialWave_ToxicNightmare"
}