class WMZedBuff_PukeMine extends WMZedBuff;

var array<rotator> DeathPukeMineRotations;

static function KilledPawn(Pawn entity)
{
	if (KFPawn_ZedBloat(entity) != None)
		KFPawn_ZedBloat(entity).SpawnPukeMine(entity.Location, Normalize(entity.Rotation + default.DeathPukeMineRotations[Rand(default.DeathPukeMineRotations.Length)]));
}

defaultproperties
{
	DeathPukeMineRotations(0)=(Pitch=7000,Yaw=10480,Roll=0)
	DeathPukeMineRotations(1)=(Pitch=7000,Yaw=32767,Roll=0)
	DeathPukeMineRotations(2)=(Pitch=7000,Yaw=-10480,Roll=0)

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_PukeMine"
	BuffIcon=Texture2D'ZED_Bloat_UI.ZED-VS_Icons_Bloat-PukeMine'

	Name="Default__WMZedBuff_PukeMine"
}
