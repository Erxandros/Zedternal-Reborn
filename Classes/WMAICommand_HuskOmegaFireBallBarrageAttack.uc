class WMAICommand_HuskOmegaFireBallBarrageAttack extends AICommand_RangedAttack
	within WMAIController_ZedHusk_Omega;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool FireBallBarrageAttack(WMAIController_ZedHusk_Omega AI)
{
	local WMAICommand_HuskOmegaFireBallBarrageAttack Cmd;

	if (AI != None)
	{
		Cmd = new(AI) default.class;
		if (Cmd != None)
		{
			AI.PushCommand(Cmd);
			return true;
		}
	}

	return false;
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Custom1;
	}
}

function Pushed()
{
	Super.Pushed();

	`AILog("Beginning fireball barrage" $ Enemy, 'Command_FireBall_Barrage');
	AIActionStatus = "Starting fireball barrage AICommand";
}

function Popped()
{
	AIActionStatus = "Finished fireball barrage AICommand";
	LastFireBallBarrageTime = WorldInfo.TimeSeconds;
	Super.Popped();
}

defaultproperties
{
	SpecialMoveClass=class'ZedternalReborn.WMSM_Husk_Omega_FireBallBarrageAttack'

	Name="Default__WMAICommand_HuskOmegaFireBallBarrageAttack"
}
