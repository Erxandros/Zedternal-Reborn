Class Zed_Arch_FleshpoundOmega extends ReplicationInfo
	transient;

var repnotify KFCharacterInfo_Monster zedClientArch;
var KFCharacterInfo_Monster zedServerArch;

replication
{
	if (true)
		zedClientArch;
}

simulated static final function Zed_Arch_FleshpoundOmega GetArch( WorldInfo Level )
{
	local Zed_Arch_FleshpoundOmega A;
	
	foreach Level.DynamicActors(class'ZedternalReborn.Zed_Arch_FleshpoundOmega',A)
	{
		if( A.zedClientArch!=None )
			return A;
	}
	if( Level.NetMode!=NM_Client )
	{
		A = Level.Spawn(class'ZedternalReborn.Zed_Arch_FleshpoundOmega');
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
	local WMPawn_ZedFleshpound_Omega A;
	
	foreach WorldInfo.AllPawns(class'WMPawn_ZedFleshpound_Omega',A)
	{
		A.updateArch();
	}
}

defaultproperties
{
   zedServerArch=KFCharacterInfo_Monster'ZedternalReborn_Zeds.ZED_Fleshpound_Omega_Archetype'
   NetUpdateFrequency=4.000000
   Name="Default__Zed_Arch_Base"
}