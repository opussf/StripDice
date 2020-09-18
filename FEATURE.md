# Features

## settings report

Report the settings when ever the settings are changed.

## debug levels

Change the LogMsg() function to also take a log level.
Many systems use:

* Critical    (nil)
* Error       (1)
* Warning     (2)
* Info        (3)

A setting of Info also gets all the above.
A setting of Critical only gets the Critical messages.

Setting debug increases the value, increasing the log messages recorded.


## expanded Commands

Commands:
"Set <high|low> <iconName|none> <iconName|none> ..."  will set the icons for lowest, 2nd lowest, 3rd lowest, etc.  Or for highest, 2nd highest, etc...

"Set <rollvalue> <iconName|none>" will set an icon for a specific roll value.

"settings" will report the current setup.

## setOptions

"Set <high|low> <iconName|none>" will set the high or low roll to the icon, or clear setting that icon.
