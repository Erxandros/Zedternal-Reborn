class WMRandom extends Object;

const FNVPrime = 0x01000193;
const FNVOffset = 0x811c9dc5;

static function string GenerateSeed()
{
	local byte b;
	local string seed;

	for (b = 0; b < 16; ++b)
	{
		seed $= Chr(Rand(256));
	}

	return seed;
}

//Based off FNV-1a
static function int FNV16A(string Seed, int Position)
{
	local int hval;

	hval = FNVOffset;

	hval = hval ^ byte(Asc(Mid(Seed, 0, 1)) - Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 1, 1)) + Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 2, 1)) * Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 3, 1)) ^ Position);
	hval = hval * FNVPrime;


	hval = hval ^ byte(Asc(Mid(Seed, 4, 1)) + Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 5, 1)) * Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 6, 1)) ^ Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 7, 1)) - Position);
	hval = hval * FNVPrime;


	hval = hval ^ byte(Asc(Mid(Seed, 8, 1)) * Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 9, 1)) ^ Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 10, 1)) - Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 11, 1)) + Position);
	hval = hval * FNVPrime;


	hval = hval ^ byte(Asc(Mid(Seed, 12, 1)) ^ Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 13, 1)) - Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 14, 1)) + Position);
	hval = hval * FNVPrime;

	hval = hval ^ byte(Asc(Mid(Seed, 15, 1)) * Position);
	hval = hval * FNVPrime;

	return hval;
}

static function int SeedRandom(string Seed, int Position, int Mod)
{
	Position = FNV16A(Seed, Position);

	if (Position < 0)
		Position = -Position;

	return Position % Mod;
}

defaultproperties
{
	Name="Default__WMRandom"
}
