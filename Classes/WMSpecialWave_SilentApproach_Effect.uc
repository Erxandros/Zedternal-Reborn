Class WMSpecialWave_SilentApproach_Effect extends Info
	transient;

var KFGameReplicationInfo KFGRI;
var int CurrentWaveNum;
var array< KFPawn_Monster > ZED_list;
var MaterialInstanceConstant Invisible_Mat;


reliable client function ClientUpdateSpecialWave()
{
	if (KFGRI == none)
		SetTimer(0.5f,true,nameof(UpdateZed));
	
	KFGRI = KFGameReplicationInfo(GetALocalPlayerController().WorldInfo.GRI);
	
	`log("SilentApproach effect created");
	
	if (KFGRI != none)
	{
		CurrentWaveNum = KFGRI.WaveNum;
		SetTimer(0.5f,true,nameof(UpdateZed));
	}
}

simulated function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	`log("Update Silent");
	
	if (KFGRI == none || KFGRI.WaveNum != CurrentWaveNum)
		Destroy();
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (ZED_list.find(KFM) == -1)
		{
			KFM.Mesh.SetMaterial(0, Invisible_Mat);
			ZED_list.AddItem(KFM);
		}
	}
}

defaultproperties
{
   bOnlyRelevantToOwner = true
   Invisible_Mat = MaterialInstanceConstant'ZED_Stalker_MAT.ZED_Stalker_MAT'
}
