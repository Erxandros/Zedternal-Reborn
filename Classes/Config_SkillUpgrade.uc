class Config_SkillUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

struct S_SkillUpgrade
{
	var string PerkPath;
	var string SkillPath;
};

var config array<S_SkillUpgrade> SkillUpgrade_Upgrade;

static function UpdateConfig()
{
	local int i;

	if (default.MODEVERSION < 1)
	{
		default.SkillUpgrade_Upgrade.Length = 100;

		// Berserker
		default.SkillUpgrade_Upgrade[0].SkillPath = "ZedternalReborn.WMUpgrade_Skill_BerserkerRage";
		default.SkillUpgrade_Upgrade[1].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Brawler";
		default.SkillUpgrade_Upgrade[2].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Butcher";
		default.SkillUpgrade_Upgrade[3].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Dreadnaught";
		default.SkillUpgrade_Upgrade[4].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Massacre";
		default.SkillUpgrade_Upgrade[5].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Parry";
		default.SkillUpgrade_Upgrade[6].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Spartan";
		default.SkillUpgrade_Upgrade[7].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Tank";
		default.SkillUpgrade_Upgrade[8].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Vampire";
		default.SkillUpgrade_Upgrade[9].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Tempest";
		for (i = 0; i <= 9; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Berserker";
		}

		// Commando
		default.SkillUpgrade_Upgrade[10].SkillPath = "ZedternalReborn.WMUpgrade_Skill_CallOut";
		default.SkillUpgrade_Upgrade[11].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Concentration";
		default.SkillUpgrade_Upgrade[12].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Guerrilla";
		default.SkillUpgrade_Upgrade[13].SkillPath = "ZedternalReborn.WMUpgrade_Skill_GunMachine";
		default.SkillUpgrade_Upgrade[14].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HighCapacityMags";
		default.SkillUpgrade_Upgrade[15].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ImpactRounds";
		default.SkillUpgrade_Upgrade[16].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Overload";
		default.SkillUpgrade_Upgrade[17].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Supplier";
		default.SkillUpgrade_Upgrade[18].SkillPath = "ZedternalReborn.WMUpgrade_Skill_TacticalReload";
		default.SkillUpgrade_Upgrade[19].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Tactician";
		for (i = 10; i <= 19; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Commando";
		}

		// Demolitionist
		default.SkillUpgrade_Upgrade[20].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Bombardier";
		default.SkillUpgrade_Upgrade[21].SkillPath = "ZedternalReborn.WMUpgrade_Skill_DestroyerOfWorlds";
		default.SkillUpgrade_Upgrade[22].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ExtraRounds";
		default.SkillUpgrade_Upgrade[23].SkillPath = "ZedternalReborn.WMUpgrade_Skill_FrontLine";
		default.SkillUpgrade_Upgrade[24].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HighImpactRound";
		default.SkillUpgrade_Upgrade[25].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Kamikaze";
		default.SkillUpgrade_Upgrade[26].SkillPath = "ZedternalReborn.WMUpgrade_Skill_MadBomber";
		default.SkillUpgrade_Upgrade[27].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ShockTrooper";
		default.SkillUpgrade_Upgrade[28].SkillPath = "ZedternalReborn.WMUpgrade_Skill_SonicResistantRounds";
		default.SkillUpgrade_Upgrade[29].SkillPath = "ZedternalReborn.WMUpgrade_Skill_QuickFuse";
		for (i = 20; i <= 29; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		}

		// FieldMedic
		default.SkillUpgrade_Upgrade[30].SkillPath = "ZedternalReborn.WMUpgrade_Skill_AcidicRounds";
		default.SkillUpgrade_Upgrade[31].SkillPath = "ZedternalReborn.WMUpgrade_Skill_AirborneAgent";
		default.SkillUpgrade_Upgrade[32].SkillPath = "ZedternalReborn.WMUpgrade_Skill_BattleSurgeon";
		default.SkillUpgrade_Upgrade[33].SkillPath = "ZedternalReborn.WMUpgrade_Skill_CoagulantBooster";
		default.SkillUpgrade_Upgrade[34].SkillPath = "ZedternalReborn.WMUpgrade_Skill_CombatantDoctor";
		default.SkillUpgrade_Upgrade[35].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Hemoglobin";
		default.SkillUpgrade_Upgrade[36].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Safeguard";
		default.SkillUpgrade_Upgrade[37].SkillPath = "ZedternalReborn.WMUpgrade_Skill_SymbioticHealth";
		default.SkillUpgrade_Upgrade[38].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Zedatif";
		default.SkillUpgrade_Upgrade[39].SkillPath = "ZedternalReborn.WMUpgrade_Skill_FocusInjection";
		for (i = 30; i <= 39; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		}

		// Firebug
		default.SkillUpgrade_Upgrade[40].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Barbecue";
		default.SkillUpgrade_Upgrade[41].SkillPath = "ZedternalReborn.WMUpgrade_Skill_BringTheHeat";
		default.SkillUpgrade_Upgrade[42].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Combustion";
		default.SkillUpgrade_Upgrade[43].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Firestorm";
		default.SkillUpgrade_Upgrade[44].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HeatWaves";
		default.SkillUpgrade_Upgrade[45].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Napalm";
		default.SkillUpgrade_Upgrade[46].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Pyromaniac";
		default.SkillUpgrade_Upgrade[47].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Resistance";
		default.SkillUpgrade_Upgrade[48].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ZedPlosion";
		default.SkillUpgrade_Upgrade[49].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HotPepper";
		for (i = 40; i <= 49; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Firebug";
		}

		// Gunslinger
		default.SkillUpgrade_Upgrade[50].SkillPath = "ZedternalReborn.WMUpgrade_Skill_BoneBreaker";
		default.SkillUpgrade_Upgrade[51].SkillPath = "ZedternalReborn.WMUpgrade_Skill_FirstBlood";
		default.SkillUpgrade_Upgrade[52].SkillPath = "ZedternalReborn.WMUpgrade_Skill_MagicBullet";
		default.SkillUpgrade_Upgrade[53].SkillPath = "ZedternalReborn.WMUpgrade_Skill_QuickDraw";
		default.SkillUpgrade_Upgrade[54].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Ruthless";
		default.SkillUpgrade_Upgrade[55].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ShootAndRun";
		default.SkillUpgrade_Upgrade[56].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Skirmisher";
		default.SkillUpgrade_Upgrade[57].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Speedloader";
		default.SkillUpgrade_Upgrade[58].SkillPath = "ZedternalReborn.WMUpgrade_Skill_WhirlwindOfLead";
		default.SkillUpgrade_Upgrade[59].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Steady";
		for (i = 50; i <= 59; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		}

		// Sharpshooter
		default.SkillUpgrade_Upgrade[60].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Assassin";
		default.SkillUpgrade_Upgrade[61].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ColdRiposte";
		default.SkillUpgrade_Upgrade[62].SkillPath = "ZedternalReborn.WMUpgrade_Skill_DeadEye";
		default.SkillUpgrade_Upgrade[63].SkillPath = "ZedternalReborn.WMUpgrade_Skill_FrozenHeadPopper";
		default.SkillUpgrade_Upgrade[64].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Marksman";
		default.SkillUpgrade_Upgrade[65].SkillPath = "ZedternalReborn.WMUpgrade_Skill_RankThemUp";
		default.SkillUpgrade_Upgrade[66].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Sniper";
		default.SkillUpgrade_Upgrade[67].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Stability";
		default.SkillUpgrade_Upgrade[68].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Velocity";
		default.SkillUpgrade_Upgrade[69].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Hunter";
		for (i = 60; i <= 69; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		}

		// Support
		default.SkillUpgrade_Upgrade[70].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Barrage";
		default.SkillUpgrade_Upgrade[71].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Destruction";
		default.SkillUpgrade_Upgrade[72].SkillPath = "ZedternalReborn.WMUpgrade_Skill_DoorTraps";
		default.SkillUpgrade_Upgrade[73].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Fortitude";
		default.SkillUpgrade_Upgrade[74].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HighCapacityMagsB";
		default.SkillUpgrade_Upgrade[75].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Penetrator";
		default.SkillUpgrade_Upgrade[76].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Salvo";
		default.SkillUpgrade_Upgrade[77].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Tenacity";
		default.SkillUpgrade_Upgrade[78].SkillPath = "ZedternalReborn.WMUpgrade_Skill_TightChoke";
		default.SkillUpgrade_Upgrade[79].SkillPath = "ZedternalReborn.WMUpgrade_Skill_ConcussionRounds";
		for (i = 70; i <= 79; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Support";
		}

		// SWAT
		default.SkillUpgrade_Upgrade[80].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Cripple";
		default.SkillUpgrade_Upgrade[81].SkillPath = "ZedternalReborn.WMUpgrade_Skill_HeavyArmor";
		default.SkillUpgrade_Upgrade[82].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Pressure";
		default.SkillUpgrade_Upgrade[83].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Ranger";
		default.SkillUpgrade_Upgrade[84].SkillPath = "ZedternalReborn.WMUpgrade_Skill_RapidAssault";
		default.SkillUpgrade_Upgrade[85].SkillPath = "ZedternalReborn.WMUpgrade_Skill_RiotShield";
		default.SkillUpgrade_Upgrade[86].SkillPath = "ZedternalReborn.WMUpgrade_Skill_SpecialUnit";
		default.SkillUpgrade_Upgrade[87].SkillPath = "ZedternalReborn.WMUpgrade_Skill_SuppressionRounds";
		default.SkillUpgrade_Upgrade[88].SkillPath = "ZedternalReborn.WMUpgrade_Skill_TacticalMovement";
		default.SkillUpgrade_Upgrade[89].SkillPath = "ZedternalReborn.WMUpgrade_Skill_AssaultArmor";
		for (i = 80; i <= 89; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_SWAT";
		}

		// Survivalist
		default.SkillUpgrade_Upgrade[90].SkillPath = "ZedternalReborn.WMUpgrade_Skill_AmmoVest";
		default.SkillUpgrade_Upgrade[91].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Emergency";
		default.SkillUpgrade_Upgrade[92].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Empathy";
		default.SkillUpgrade_Upgrade[93].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Fallback";
		default.SkillUpgrade_Upgrade[94].SkillPath = "ZedternalReborn.WMUpgrade_Skill_MedicalInjection";
		default.SkillUpgrade_Upgrade[95].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Scrapper";
		default.SkillUpgrade_Upgrade[96].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Strength";
		default.SkillUpgrade_Upgrade[97].SkillPath = "ZedternalReborn.WMUpgrade_Skill_TacticalArmor";
		default.SkillUpgrade_Upgrade[98].SkillPath = "ZedternalReborn.WMUpgrade_Skill_Watcher";
		default.SkillUpgrade_Upgrade[99].SkillPath = "ZedternalReborn.WMUpgrade_Skill_AmmoPickup";
		for (i = 90; i <= 99; ++i)
		{
			default.SkillUpgrade_Upgrade[i].PerkPath = "ZedternalReborn.WMUpgrade_Perk_Survivalist";
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int s, p;
	local bool PerkExist;

	for (s = 0; s < default.SkillUpgrade_Upgrade.Length; ++s)
	{
		PerkExist = False;
		for (p = 0; p < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Upgrade.Length; ++p)
		{
			if (default.SkillUpgrade_Upgrade[s].PerkPath ~= class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Upgrade[p])
			{
				PerkExist = True;
				break;
			}
		}

		if (!PerkExist)
		{
			`log("ZR Config: Skill upgrade" @ default.SkillUpgrade_Upgrade[s].SkillPath @ "is not paired with a valid Perk upgrade"
				@default.SkillUpgrade_Upgrade[s].PerkPath $ ". Skip adding the Skill upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
			default.SkillUpgrade_Upgrade.Remove(s, 1);
			--s;
		}
	}
}

static function LoadConfigObjects(out array<S_SkillUpgrade> ValidUpgrades, out array< class<WMUpgrade_Skill> > UpgradeObjects)
{
	local int i;
	local class<WMUpgrade_Skill> Obj;

	ValidUpgrades.Length = 0;
	UpgradeObjects.Length = 0;

	for (i = 0; i < default.SkillUpgrade_Upgrade.Length; ++i)
	{
		Obj = class<WMUpgrade_Skill>(DynamicLoadObject(default.SkillUpgrade_Upgrade[i].SkillPath, class'Class', True));
		if (Obj == None)
		{
			`log("ZR Config: Skill upgrade" @ default.SkillUpgrade_Upgrade[i].SkillPath @ "failed to load. Skip adding the Skill upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
		}
		else
		{
			ValidUpgrades.AddItem(default.SkillUpgrade_Upgrade[i]);
			UpgradeObjects.AddItem(Obj);
		}
	}
}

defaultproperties
{
	Name="Default__Config_SkillUpgrade"
}
