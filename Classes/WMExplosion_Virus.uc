class WMExplosion_Virus extends KFExplosion_PlayerCrawlerSuicide;

var const class<DamageType> DamageTypeClass;

function PostBeginPlay()
{
	local KFGameExplosion KFGExp;

	super.PostBeginPlay();
	ClientExplode();

	KFGExp = class'KFGameContent.KFPawn_ZedHans'.default.NerveGasAttackTemplate;
	KFGExp.MyDamageType = default.DamageTypeClass;
	Explode(KFGExp);
}

reliable client function ClientExplode()
{
	local KFGameExplosion KFGExp;

	KFGExp = class'KFGameContent.KFPawn_ZedHans'.default.NerveGasAttackTemplate;
	KFGExp.MyDamageType = default.DamageTypeClass;
	Explode(KFGExp);
}

defaultproperties
{
	DamageTypeClass=class'ZedternalReborn.WMDT_Explosive_Virus'

	interval=1.0f
	maxTime=6.0f

	Name="Default__WMExplosion_Virus"
}
