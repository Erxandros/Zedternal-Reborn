class WMBinaryOps extends Object;

function static int BinarySearch(const out array<object> InArray, string ObjName)
{
	local int Low, Mid, High;

	ObjName = Caps(ObjName);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		if (ObjName < Caps(PathName(InArray[Mid])))
			High = Mid - 1;
		else if (ObjName > Caps(PathName(InArray[Mid])))
			Low = Mid + 1;
		else
			return Mid;
	}

	return INDEX_NONE;
}

function static bool BinarySearchUnique(const out array<object> InArray, string ObjName, out int Low)
{
	local int Mid, High;

	ObjName = Caps(ObjName);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		if (ObjName < Caps(PathName(InArray[Mid])))
			High = Mid - 1;
		else if (ObjName > Caps(PathName(InArray[Mid])))
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
