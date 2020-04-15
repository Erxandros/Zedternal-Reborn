Class WMZedBuff_PukeMine extends WMZedBuff;

var array<rotator> DeathPukeMineRotations;


static function KilledPawn(Pawn Pawn)
{
	if (KFPawn_ZedBloat(Pawn) != none)
		KFPawn_ZedBloat(Pawn).SpawnPukeMine( Pawn.Location, Normalize(Pawn.Rotation + default.DeathPukeMineRotations[Rand(default.DeathPukeMineRotations.length)]) );
}


defaultproperties
{
	buffDescription="BLOATS ALWAYS PUKE MINE ON DEATH"
	buffIcon=Texture2D'ZED_Bloat_UI.ZED-VS_Icons_Bloat-PukeMine'
    DeathPukeMineRotations(0)=(Pitch=7000,Yaw=10480,Roll=0)
    DeathPukeMineRotations(1)=(Pitch=7000,Yaw=32767,Roll=0)
    DeathPukeMineRotations(2)=(Pitch=7000,Yaw=-10480,Roll=0)
}