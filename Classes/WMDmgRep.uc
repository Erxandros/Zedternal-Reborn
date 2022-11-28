Class WMDmgRep extends ReplicationInfo
	transient;

var repnotify PlayerController PlayerOwner;
var transient PlayerController LocalOwner;
var transient WMDmgHUD ClientHUD;

replication
{
	if (bNetOwner)
		PlayerOwner;
}

function PostBeginPlay()
{
	InitOwner(PlayerController(Owner));
}

simulated function InitOwner(PlayerController PC)
{
	if (PC == None)
	{
		Destroy();
		return;
	}

	PlayerOwner = PC;
	if (WorldInfo.NetMode == NM_DedicatedServer || (WorldInfo.NetMode != NM_Client && LocalPlayer(PC.Player) == None))
		return;

	LocalOwner = PC;
	ClientHUD = new(PC) class'ZedternalReborn.WMDmgHUD';
	ClientHUD.LocalOwner = PC;
	PC.Interactions.Insert(0, 1);
	PC.Interactions[0] = ClientHUD;
}

simulated function Destroyed()
{
	if (ClientHUD != None)
	{
		LocalOwner.Interactions.RemoveItem(ClientHUD);
		ClientHUD.LocalOwner = None;
		ClientHUD = None;
		LocalOwner = None;
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'PlayerOwner' && PlayerOwner != None)
		InitOwner(PlayerOwner);
}

simulated unreliable client function ClientPopupMessage(int A, vector Pos)
{
	if (ClientHUD != None)
		ClientHUD.AddNumberMsg(A, Pos);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
	bAlwaysRelevant=False

	Name="Default__WMDmgRep"
}
