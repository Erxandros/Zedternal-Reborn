class Config_SkillUpgrade extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct SUPG
{
	var string PerkPath;
	var string SkillPath;
};

var config array< SUPG > SkillUpgrade_SkillUpgrades;
var config int SkillUpgrade_Price;
var config int SkillUpgrade_DeluxePrice;
	
static function UpdateConfig()
{
	local byte i;
	local SUPG tempObj;
	
	if (default.MODEVERSION < 2)
	{
		default.SkillUpgrade_SkillUpgrades.length = 90;
		
		// Berserker
		default.SkillUpgrade_SkillUpgrades[0].SkillPath="ZedternalReborn.WMUpgrade_Skill_BerserkerRage";
		default.SkillUpgrade_SkillUpgrades[1].SkillPath="ZedternalReborn.WMUpgrade_Skill_Brawler";
		default.SkillUpgrade_SkillUpgrades[2].SkillPath="ZedternalReborn.WMUpgrade_Skill_Butcher";
		default.SkillUpgrade_SkillUpgrades[3].SkillPath="ZedternalReborn.WMUpgrade_Skill_Dreadnaught";
		default.SkillUpgrade_SkillUpgrades[4].SkillPath="ZedternalReborn.WMUpgrade_Skill_Massacre";
		default.SkillUpgrade_SkillUpgrades[5].SkillPath="ZedternalReborn.WMUpgrade_Skill_Parry";
		default.SkillUpgrade_SkillUpgrades[6].SkillPath="ZedternalReborn.WMUpgrade_Skill_Spartan";
		default.SkillUpgrade_SkillUpgrades[7].SkillPath="ZedternalReborn.WMUpgrade_Skill_Tank";
		default.SkillUpgrade_SkillUpgrades[8].SkillPath="ZedternalReborn.WMUpgrade_Skill_Vampire";
		for (i=0 ; i<=8 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Berserker";
		}
		
		// Commando
		default.SkillUpgrade_SkillUpgrades[9].SkillPath="ZedternalReborn.WMUpgrade_Skill_CallOut";
		default.SkillUpgrade_SkillUpgrades[10].SkillPath="ZedternalReborn.WMUpgrade_Skill_Concentration";
		default.SkillUpgrade_SkillUpgrades[11].SkillPath="ZedternalReborn.WMUpgrade_Skill_Guerrilla";
		default.SkillUpgrade_SkillUpgrades[12].SkillPath="ZedternalReborn.WMUpgrade_Skill_GunMachine";
		default.SkillUpgrade_SkillUpgrades[13].SkillPath="ZedternalReborn.WMUpgrade_Skill_HighCapacityMags";
		default.SkillUpgrade_SkillUpgrades[14].SkillPath="ZedternalReborn.WMUpgrade_Skill_ImpactRounds";
		default.SkillUpgrade_SkillUpgrades[15].SkillPath="ZedternalReborn.WMUpgrade_Skill_Overload";
		default.SkillUpgrade_SkillUpgrades[16].SkillPath="ZedternalReborn.WMUpgrade_Skill_Supplier";
		default.SkillUpgrade_SkillUpgrades[17].SkillPath="ZedternalReborn.WMUpgrade_Skill_TacticalReload";
		for (i=9 ; i<=17 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Commando";
		}

		// Demolitionist
		default.SkillUpgrade_SkillUpgrades[18].SkillPath="ZedternalReborn.WMUpgrade_Skill_Bombardier";
		default.SkillUpgrade_SkillUpgrades[19].SkillPath="ZedternalReborn.WMUpgrade_Skill_DestroyerOfWorlds";
		default.SkillUpgrade_SkillUpgrades[20].SkillPath="ZedternalReborn.WMUpgrade_Skill_ExtraRounds";
		default.SkillUpgrade_SkillUpgrades[21].SkillPath="ZedternalReborn.WMUpgrade_Skill_FrontLine";
		default.SkillUpgrade_SkillUpgrades[22].SkillPath="ZedternalReborn.WMUpgrade_Skill_HighImpactRound";
		default.SkillUpgrade_SkillUpgrades[23].SkillPath="ZedternalReborn.WMUpgrade_Skill_Kamikaze";
		default.SkillUpgrade_SkillUpgrades[24].SkillPath="ZedternalReborn.WMUpgrade_Skill_MadBomber";
		default.SkillUpgrade_SkillUpgrades[25].SkillPath="ZedternalReborn.WMUpgrade_Skill_ShockTropper";
		default.SkillUpgrade_SkillUpgrades[26].SkillPath="ZedternalReborn.WMUpgrade_Skill_SonicResistantRounds";
		for (i=18 ; i<=26 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		}
		
		// FieldMedic
		default.SkillUpgrade_SkillUpgrades[27].SkillPath="ZedternalReborn.WMUpgrade_Skill_AcidicRounds";
		default.SkillUpgrade_SkillUpgrades[28].SkillPath="ZedternalReborn.WMUpgrade_Skill_AirborneAgent";
		default.SkillUpgrade_SkillUpgrades[29].SkillPath="ZedternalReborn.WMUpgrade_Skill_BattleSurgeon";
		default.SkillUpgrade_SkillUpgrades[30].SkillPath="ZedternalReborn.WMUpgrade_Skill_CoagulantBooster";
		default.SkillUpgrade_SkillUpgrades[31].SkillPath="ZedternalReborn.WMUpgrade_Skill_CombatantDoctor";
		default.SkillUpgrade_SkillUpgrades[32].SkillPath="ZedternalReborn.WMUpgrade_Skill_Hemoglobin";
		default.SkillUpgrade_SkillUpgrades[33].SkillPath="ZedternalReborn.WMUpgrade_Skill_Safeguard";
		default.SkillUpgrade_SkillUpgrades[34].SkillPath="ZedternalReborn.WMUpgrade_Skill_SymbioticHealth";
		default.SkillUpgrade_SkillUpgrades[35].SkillPath="ZedternalReborn.WMUpgrade_Skill_Zedatif";
		for (i=27 ; i<=35 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		}
		
		// Firebug
		default.SkillUpgrade_SkillUpgrades[36].SkillPath="ZedternalReborn.WMUpgrade_Skill_Barbecue";
		default.SkillUpgrade_SkillUpgrades[37].SkillPath="ZedternalReborn.WMUpgrade_Skill_BringTheHeat";
		default.SkillUpgrade_SkillUpgrades[38].SkillPath="ZedternalReborn.WMUpgrade_Skill_Combustion";
		default.SkillUpgrade_SkillUpgrades[39].SkillPath="ZedternalReborn.WMUpgrade_Skill_Firestorm";
		default.SkillUpgrade_SkillUpgrades[40].SkillPath="ZedternalReborn.WMUpgrade_Skill_HeatWaves";
		default.SkillUpgrade_SkillUpgrades[41].SkillPath="ZedternalReborn.WMUpgrade_Skill_Napalm";
		default.SkillUpgrade_SkillUpgrades[42].SkillPath="ZedternalReborn.WMUpgrade_Skill_Pyromaniac";
		default.SkillUpgrade_SkillUpgrades[43].SkillPath="ZedternalReborn.WMUpgrade_Skill_Resistance";
		default.SkillUpgrade_SkillUpgrades[44].SkillPath="ZedternalReborn.WMUpgrade_Skill_ZedPlosion";
		for (i=36 ; i<=44 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Firebug";
		}
		
		// Gunslinger
		default.SkillUpgrade_SkillUpgrades[45].SkillPath="ZedternalReborn.WMUpgrade_Skill_BoneBreaker";
		default.SkillUpgrade_SkillUpgrades[46].SkillPath="ZedternalReborn.WMUpgrade_Skill_FirstBlood";
		default.SkillUpgrade_SkillUpgrades[47].SkillPath="ZedternalReborn.WMUpgrade_Skill_MagicBullet";
		default.SkillUpgrade_SkillUpgrades[48].SkillPath="ZedternalReborn.WMUpgrade_Skill_QuickDraw";
		default.SkillUpgrade_SkillUpgrades[49].SkillPath="ZedternalReborn.WMUpgrade_Skill_Ruthless";
		default.SkillUpgrade_SkillUpgrades[50].SkillPath="ZedternalReborn.WMUpgrade_Skill_ShootAndRun";
		default.SkillUpgrade_SkillUpgrades[51].SkillPath="ZedternalReborn.WMUpgrade_Skill_Skirmisher";
		default.SkillUpgrade_SkillUpgrades[52].SkillPath="ZedternalReborn.WMUpgrade_Skill_Speedloader";
		default.SkillUpgrade_SkillUpgrades[53].SkillPath="ZedternalReborn.WMUpgrade_Skill_WhirlwindOfLead";
		for (i=45 ; i<=53 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		}

		// Sharpshooter
		default.SkillUpgrade_SkillUpgrades[54].SkillPath="ZedternalReborn.WMUpgrade_Skill_Assassin";
		default.SkillUpgrade_SkillUpgrades[55].SkillPath="ZedternalReborn.WMUpgrade_Skill_ColdRiposte";
		default.SkillUpgrade_SkillUpgrades[56].SkillPath="ZedternalReborn.WMUpgrade_Skill_DeadEye";
		default.SkillUpgrade_SkillUpgrades[57].SkillPath="ZedternalReborn.WMUpgrade_Skill_FrozenHeadPoper";
		default.SkillUpgrade_SkillUpgrades[58].SkillPath="ZedternalReborn.WMUpgrade_Skill_Marksman";
		default.SkillUpgrade_SkillUpgrades[59].SkillPath="ZedternalReborn.WMUpgrade_Skill_RankThemUp";
		default.SkillUpgrade_SkillUpgrades[60].SkillPath="ZedternalReborn.WMUpgrade_Skill_Sniper";
		default.SkillUpgrade_SkillUpgrades[61].SkillPath="ZedternalReborn.WMUpgrade_Skill_Stability";
		default.SkillUpgrade_SkillUpgrades[62].SkillPath="ZedternalReborn.WMUpgrade_Skill_Velocity";
		for (i=54 ; i<=62 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		}
		
		// Support
		default.SkillUpgrade_SkillUpgrades[63].SkillPath="ZedternalReborn.WMUpgrade_Skill_Barrage";
		default.SkillUpgrade_SkillUpgrades[64].SkillPath="ZedternalReborn.WMUpgrade_Skill_Destruction";
		default.SkillUpgrade_SkillUpgrades[65].SkillPath="ZedternalReborn.WMUpgrade_Skill_DoorTraps";
		default.SkillUpgrade_SkillUpgrades[66].SkillPath="ZedternalReborn.WMUpgrade_Skill_Fortitude";
		default.SkillUpgrade_SkillUpgrades[67].SkillPath="ZedternalReborn.WMUpgrade_Skill_HighCapacityMagsB";
		default.SkillUpgrade_SkillUpgrades[68].SkillPath="ZedternalReborn.WMUpgrade_Skill_Penetrator";
		default.SkillUpgrade_SkillUpgrades[69].SkillPath="ZedternalReborn.WMUpgrade_Skill_Salvo";
		default.SkillUpgrade_SkillUpgrades[70].SkillPath="ZedternalReborn.WMUpgrade_Skill_Tenacity";
		default.SkillUpgrade_SkillUpgrades[71].SkillPath="ZedternalReborn.WMUpgrade_Skill_TightChoke";
		for (i=63 ; i<=71 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Support";
		}
		
		// SWAT
		default.SkillUpgrade_SkillUpgrades[72].SkillPath="ZedternalReborn.WMUpgrade_Skill_Cripple";
		default.SkillUpgrade_SkillUpgrades[73].SkillPath="ZedternalReborn.WMUpgrade_Skill_HeavyArmor";
		default.SkillUpgrade_SkillUpgrades[74].SkillPath="ZedternalReborn.WMUpgrade_Skill_Pressure";
		default.SkillUpgrade_SkillUpgrades[75].SkillPath="ZedternalReborn.WMUpgrade_Skill_Ranger";
		default.SkillUpgrade_SkillUpgrades[76].SkillPath="ZedternalReborn.WMUpgrade_Skill_RapidAssault";
		default.SkillUpgrade_SkillUpgrades[77].SkillPath="ZedternalReborn.WMUpgrade_Skill_RiotShield";
		default.SkillUpgrade_SkillUpgrades[78].SkillPath="ZedternalReborn.WMUpgrade_Skill_SpecialUnit";
		default.SkillUpgrade_SkillUpgrades[79].SkillPath="ZedternalReborn.WMUpgrade_Skill_SuppressionRounds";
		default.SkillUpgrade_SkillUpgrades[80].SkillPath="ZedternalReborn.WMUpgrade_Skill_TacticalMovement";
		for (i=72 ; i<=80 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_SWAT";
		}
		
		// Survivalist
		default.SkillUpgrade_SkillUpgrades[81].SkillPath="ZedternalReborn.WMUpgrade_Skill_AmmoVest";
		default.SkillUpgrade_SkillUpgrades[82].SkillPath="ZedternalReborn.WMUpgrade_Skill_Emergency";
		default.SkillUpgrade_SkillUpgrades[83].SkillPath="ZedternalReborn.WMUpgrade_Skill_Empathy";
		default.SkillUpgrade_SkillUpgrades[84].SkillPath="ZedternalReborn.WMUpgrade_Skill_Fallback";
		default.SkillUpgrade_SkillUpgrades[85].SkillPath="ZedternalReborn.WMUpgrade_Skill_MedicalInjection";
		default.SkillUpgrade_SkillUpgrades[86].SkillPath="ZedternalReborn.WMUpgrade_Skill_Scrapper";
		default.SkillUpgrade_SkillUpgrades[87].SkillPath="ZedternalReborn.WMUpgrade_Skill_Strength";
		default.SkillUpgrade_SkillUpgrades[88].SkillPath="ZedternalReborn.WMUpgrade_Skill_TacticalArmor";
		default.SkillUpgrade_SkillUpgrades[89].SkillPath="ZedternalReborn.WMUpgrade_Skill_Watcher";
		for (i=81 ; i<=89 ; i++)
		{
			default.SkillUpgrade_SkillUpgrades[i].PerkPath="ZedternalReborn.WMUpgrade_Perk_Survivalist";
		}
		
		default.SkillUpgrade_Price = 300;
		default.SkillUpgrade_DeluxePrice = 750;
	}
	
	if (default.MODEVERSION < 8)
	{
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_Tempest";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Berserker";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_Tactician";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Commando";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_QuickFuse";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_FocusInjection";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_AssaultArmor";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_SWAT";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_Steady";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_Hunter";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_ConcussionRounds";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Support";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_HotPepper";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Firebug";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
		
		tempObj.SkillPath="ZedternalReborn.WMUpgrade_Skill_AmmoPickup";
		tempObj.PerkPath="ZedternalReborn.WMUpgrade_Perk_Survivalist";
		default.SkillUpgrade_SkillUpgrades.AddItem(tempObj);
	}
	
	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}

}
	
defaultproperties
{
}