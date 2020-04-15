Class Zed_Arch_GoreFastOmega extends ReplicationInfo
	transient;

var repnotify KFCharacterInfo_Monster zedClientArch;
var KFCharacterInfo_Monster zedServerArch;

replication
{
	if (true)
		zedClientArch;
}

simulated static final function Zed_Arch_GoreFastOmega GetArch( WorldInfo Level )
{
	local Zed_Arch_GoreFastOmega A;
	
	foreach Level.DynamicActors(class'Zedternal.Zed_Arch_GoreFastOmega',A)
	{
		if( A.zedClientArch!=None )
			return A;
		else if( Level.NetMode!=NM_Client )
			A.zedClientArch = default.zedServerArch;
	}
	if( Level.NetMode!=NM_Client )
	{
		A = Level.Spawn(class'Zedternal.Zed_Arch_GoreFastOmega');
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
	if( VarName=='zedClientArch')
	{
		if (zedClientArch!=None)
		{
			updateZed();
		}
	}
}

simulated function updateZed()
{
	local WMPawn_ZedGorefast_Omega A;

	foreach WorldInfo.AllPawns(class'WMPawn_ZedGorefast_Omega',A)
	{
		A.updateArch();
	}
}

defaultproperties
{
   zedServerArch=KFCharacterInfo_Monster'ZED_Omega.ZED_Gorefast_Omega_Archetype'
   NetUpdateFrequency=4.000000
   Name="Default__Zed_Arch_Base"
}