class Config_LocalPreferences extends Object
	config(ZedternalReborn_LocalData);

var config byte KnifeIndex;
var config string GrenadePath;
var config string SidearmPath;
var config byte ScoreBoardOverrideFontSize;

static function byte GetKnifeIndex()
{
	return default.KnifeIndex;
}

static function SetKnifeIndex(byte Index)
{
	default.KnifeIndex = Index;
	static.StaticSaveConfig();
}

static function string GetGrenadePath()
{
	return default.GrenadePath;
}

static function SetGrenadePath(string Path)
{
	default.GrenadePath = Path;
	static.StaticSaveConfig();
}

static function string GetSidearmPath()
{
	return default.SidearmPath;
}

static function SetSidearmPath(string Path)
{
	default.SidearmPath = Path;
	static.StaticSaveConfig();
}

static function byte GetSBOverrideFontSize()
{
	return default.ScoreBoardOverrideFontSize;
}

static function SetSBOverrideFontSize(byte Size)
{
	default.ScoreBoardOverrideFontSize = Size;
	static.StaticSaveConfig();
}

defaultproperties
{
	Name="Default__Config_LocalPreferences"
}
