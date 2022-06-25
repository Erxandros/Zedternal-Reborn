class WMBinaryOps extends Object;

static function int BinarySearch(const out array<object> InArray, string ObjName)
{
	local string MidStr;
	local int Low, Mid, High;

	ObjName = Caps(ObjName);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		MidStr = Caps(PathName(InArray[Mid]));
		if (ObjName < MidStr)
			High = Mid - 1;
		else if (ObjName > MidStr)
			Low = Mid + 1;
		else
			return Mid;
	}

	return INDEX_NONE;
}

static function bool BinarySearchUnique(const out array<object> InArray, string ObjName, out int Low)
{
	local string MidStr;
	local int Mid, High;

	ObjName = Caps(ObjName);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		MidStr = Caps(PathName(InArray[Mid]));
		if (ObjName < MidStr)
			High = Mid - 1;
		else if (ObjName > MidStr)
			Low = Mid + 1;
		else
			return False;
	}

	return True;
}

defaultproperties
{
	Name="Default__WMBinaryOps"
}
