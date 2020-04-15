Class Zed_Arch_ScrakeTiny extends ReplicationInfo
	transient;

var repnotify KFCharacterInfo_Monster zedClientArch;
var KFCharacterInfo_Monster zedServerArch;

replication
{
	if (true)
		zedClientArch;
}

simulated static final function Zed_Arch_ScrakeTiny GetArch( WorldInfo Level )
{
	local Zed_Arch_ScrakeTiny A;
	
	foreach Level.DynamicActors(class'Zedternal.Zed_Arch_ScrakeTiny',A)
	{
		if( A.zedClientArch!=None )
			return A;
	}
	if( Level.NetMode!=NM_Client )
	{
		A = Level.Spawn(class'Zedternal.Zed_Arch_ScrakeTiny');
		return A;
	}
	return None;
}

function PostBeginPlay()
{
	zedClientArch = default.zedServerArch;
	updateZed();
}

simulated function ReplicatedEvent( name VarName )
{
	if( VarName=='zedClientArch' && zedClientArch!=None )
	{
		updateZed();
	}
}

simulated function updateZed()
{
	local WMPawn_ZedScrake_Tiny A;
	
	foreach WorldInfo.AllPawns(class'WMPawn_ZedScrake_Tiny',A)
	{
		A.updateArch();
	}
}

defaultproperties
{
   zedServerArch=KFCharacterInfo_Monster'Zedternal_Resource.ZED_Tiny_Scrake_Archetype'
   NetUpdateFrequency=4.000000
   Name="Default__Zed_Arch_Base"
}