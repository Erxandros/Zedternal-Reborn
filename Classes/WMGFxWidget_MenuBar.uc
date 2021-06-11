class WMGFxWidget_MenuBar extends KFGFxWidget_MenuBar;

function HandleButtonSpecialCase(byte ButtonIndex, out GFxObject GfxButton)
{
	super.HandleButtonSpecialCase(ButtonIndex, GfxButton);

	if (ButtonIndex == 1) //PERK
		GfxButton.SetBool("enabled", False);
}

defaultproperties
{
	Name="Default__WMGFxWidget_MenuBar"
}
