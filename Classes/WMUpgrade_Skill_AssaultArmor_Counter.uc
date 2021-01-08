class WMUpgrade_Skill_AssaultArmor_Counter extends Info
	transient;

var KFPawn_Human Player;

replication
{
	if ( bNetOwner )
		Player;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	Player = KFPawn_Human(Owner);
	if (Player == None || Player.Health <= 0)
		Destroy();
}

function GiveArmor(float Armor)
{
	Player.Armor = Min(Player.Armor + Round(Armor * Player.MaxArmor), Player.MaxArmor);
	SetClientArmor(Min(255, Player.Armor));
}

reliable client function SetClientArmor(byte Armor)
{
	Player.Armor = Armor;
}

defaultproperties
{
	Name="Default__WMUpgrade_Skill_AssaultArmor_Counter"
}
