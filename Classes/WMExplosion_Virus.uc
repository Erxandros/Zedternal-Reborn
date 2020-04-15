class WMExplosion_Virus extends KFExplosion_PlayerCrawlerSuicide;

function PostBeginPlay()
{
	local KFGameExplosion KFGExp;
	
	super.PostBeginPlay();
	clientExplode();
	
	KFGExp = class'KFGameContent.KFPawn_ZedHans'.default.NerveGasAttackTemplate;
	KFGExp.MyDamageType = class'Zedternal.WMDT_Explosive_Virus';
	Explode(KFGExp);
}

reliable client function clientExplode()
{
	local KFGameExplosion KFGExp;
	
	KFGExp = class'KFGameContent.KFPawn_ZedHans'.default.NerveGasAttackTemplate;
	KFGExp.MyDamageType = class'Zedternal.WMDT_Explosive_Virus';
	Explode(KFGExp);
}

defaultproperties
{
   interval=1.000000
   maxTime=6.000000
}