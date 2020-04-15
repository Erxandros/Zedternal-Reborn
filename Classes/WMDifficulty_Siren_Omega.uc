class WMDifficulty_Siren_Omega extends KFDifficulty_Siren
	abstract;

defaultproperties
{
   Normal=(DamagedSprintChance=0.500000,DamageMod=0.250000,SoloDamageMod=0.300000,RallySettings=(bCanRally=False))
   Hard=(DamagedSprintChance=0.800000,SoloDamageMod=0.650000,RallySettings=(bCanRally=False))
   Suicidal=(DamagedSprintChance=0.900000,DamageMod=1.000000,SoloDamageMod=0.650000,RallySettings=(TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   HellOnEarth=(DamagedSprintChance=1.000000,DamageMod=1.000000,SoloDamageMod=0.750000,RallySettings=(bCauseSprint=True,TakenDamageModifier=0.900000,DealtDamageModifier=1.200000))
   RallySettings_Versus=(bCauseSprint=False)
   RallySettings_Player_Versus=(DealtDamageModifier=1.200000)
}
