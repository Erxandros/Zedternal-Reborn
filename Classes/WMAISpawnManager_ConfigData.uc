class WMAISpawnManager_ConfigData extends Object;

//Zed
var array<S_ZedWave> ValidZedWaves;
var array< class<KFPawn_Monster> > ZedWaveObjects;

var array<S_ZedSpawnGroup> ValidZedInjects;
var array< class<KFPawn_Monster> > ZedInjectObjects;

var array<S_ZedValue> ValidZedValues;
var array< class<KFPawn_Monster> > ZedValueObjects;

var array<S_ZedVariant> ValidZedVariants;
var array< class<KFPawn_Monster> > ZedVariantObjects;

function InitializeConfigData()
{
	class'ZedternalReborn.Config_Zed'.static.LoadConfigObjects(ValidZedWaves, ZedWaveObjects);
	class'ZedternalReborn.Config_ZedInject'.static.LoadConfigObjects(ValidZedInjects, ZedInjectObjects);
	class'ZedternalReborn.Config_ZedValue'.static.LoadConfigObjects(ValidZedValues, ZedValueObjects);
	class'ZedternalReborn.Config_ZedVariant'.static.LoadConfigObjects(ValidZedVariants, ZedVariantObjects);
}

defaultproperties
{
	Name="Default__WMAISpawnManager_ConfigData"
}
