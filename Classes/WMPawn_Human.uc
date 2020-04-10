class WMPawn_Human extends KFPawn_Human;

var byte HealingDamageBoost_ZedternalReborn;
var byte HealingShield_ZedternalReborn;

replication
{
	// Replicated to ALL
	if(bNetDirty)
		HealingDamageBoost_ZedternalReborn, HealingShield_ZedternalReborn;
}

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType, optional bool bCanRepairArmor=true, optional bool bMessageHealer=true)
{
	local KFPlayerController InstigatorPC;
	local KFPerk InstigatorPerk;
	local WMPerk WMP;

	InstigatorPC = KFPlayerController(Healer);
	InstigatorPerk = InstigatorPC != None ? InstigatorPC.GetPerk() : None;
	if( InstigatorPerk != None )
	{
		WMP = WMPerk(InstigatorPerk);
		if (WMP != none)
		{
			WMP.HealingDamage(Amount, self, DamageType);

			UpdateHealingDamageBoost_ZedternalReborn(WMP);
			UpdateHealingShield_ZedternalReborn(WMP);
		}
	}
	
	return super.HealDamage(Amount, Healer, DamageType, bCanRepairArmor, bMessageHealer);
}

simulated function float GetHealingDamageBoostModifier()
{
	return 1.f + (float(HealingDamageBoost_ZedternalReborn) / 100);
}

simulated function float GetHealingShieldModifier()
{
	return 1.f - (float(HealingShield_ZedternalReborn) / 100);
}

simulated function UpdateHealingDamageBoost_ZedternalReborn(WMPerk WMP)
{
	HealingDamageBoost_ZedternalReborn = Min( HealingDamageBoost_ZedternalReborn + WMP.GetHealingDamageBoost(), WMP.GetMaxHealingDamageBoost() );
	SetTimer( 5.f,, nameOf(ResetHealingDamageBoost) );
}

simulated function UpdateHealingShield_ZedternalReborn(WMPerk WMP)
{
	HealingShield_ZedternalReborn = Min( HealingShield_ZedternalReborn + WMP.GetHealingShield(), WMP.GetMaxHealingShield() );
	SetTimer( 5.f,, nameOf(ResetHealingShield) );
}

simulated function ResetHealingDamageBoost()
{
	HealingDamageBoost_ZedternalReborn = 0;
	
	super.ResetHealingDamageBoost();
}

simulated function ResetHealingShield()
{
	HealingShield_ZedternalReborn = 0;

	super.ResetHealingShield();
}

function SacrificeExplode()
{
	local KFExplosionActorReplicated ExploActor;
	local GameExplosion	ExplosionTemplate;
	local KFPerk_Demolitionist DemoPerk;
	local WMPerk Perk;

	if ( Role < ROLE_Authority )
	{
		return;
	}

	DemoPerk = KFPerk_Demolitionist(GetPerk());
	Perk = WMPerk(GetPerk());

	// explode using the given template
	ExploActor = Spawn(class'KFExplosionActorReplicated', self,, Location,,, true);
	if( ExploActor != None )
	{
		ExploActor.InstigatorController = Controller;
		ExploActor.Instigator = self;

		ExplosionTemplate = class'KFPerk_Demolitionist'.static.GetSacrificeExplosionTemplate();
		ExplosionTemplate.bIgnoreInstigator = true;
		ExploActor.Explode( ExplosionTemplate );

		if( DemoPerk != none )
		{
			DemoPerk.NotifyPerkSacrificeExploded();
		}
		if( Perk != none )
		{
			Perk.NotifyPerkSacrificeExploded();
		}
	}
}

function ThrowActiveWeapon( optional bool bDestroyWeap )
{
	local KFWeapon TempWeapon;

	// Only throw on server
	if( Role < ROLE_Authority )
	{
		return;
	}

	// If we're dead, always throw all weapons
	if( class'ZedternalReborn.Config_Player'.default.Player_bDropAllWeaponsWhenDead && InvManager != none && Health <= 0 )
	{
		foreach InvManager.InventoryActors( class'KFWeapon', TempWeapon )
		{
			// We only care about weapons we can actually drop
			if(TempWeapon.bDropOnDeath || TempWeapon.CanThrow())
				TossInventory( TempWeapon );
		}
	}
	else
	{
		super.ThrowActiveWeapon( bDestroyWeap );
	}
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local WMPerk MyPerk;
	local KFPawn_Monster KFPM;

	if(!IsZero(Velocity) && Other.GetTeamNum() != GetTeamNum())
	{
		MyPerk = WMPerk(GetPerk());
		KFPM = KFPawn_Monster(Other);
		
		if( KFPM != none && MyPerk != none && MyPerk.CanKnockDownOnBump(KFPM) && Normal(Velocity) dot Vector(Rotation) > 0.7f )
		{
            //First priority is a knockdown if it is allowed
			if( KFPM.CanDoSpecialMove( SM_Knockdown ) )
				KFPM.Knockdown( Velocity * 3, vect(1,1,1), KFPM.Location, 1000, 100 );
            //If they can't be knocked down, but are headless, kill them outright
            else if (KFPM.IsHeadless())
                KFPM.TakeDamage(KFPM.HealthMax, Controller, Location, vect(0, 0, 0), class'KFDT_NPCBump_Large');
            //Last priority is a stumble as a backup
			else if( KFPM.CanDoSpecialMove( SM_Stumble ) )
				KFPM.DoSpecialMove(SM_Stumble,,, class'KFSM_Stumble'.static.PackRandomSMFlags(KFPM));
		}
	}
}

defaultproperties
{
}
