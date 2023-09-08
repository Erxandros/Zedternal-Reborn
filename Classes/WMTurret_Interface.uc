interface WMTurret_Interface;

//Used to define a Zedternal Reborn compatible turret for upgrades

simulated function int GetDeployedTurretCount();
simulated function GetAllTurrets(out array<Actor> TurretsList);
simulated function int GetMaxTurrets();
