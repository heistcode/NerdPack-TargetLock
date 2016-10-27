# NerdPack-TargetLock
Plugin for NerdPack

Uses your focus unit as a target lock leaving you free to tab through other enemy targets. Use a macro or keybind to focus your target in essence 'locking on'. Does not require support in the combat routine.

Use the ingame config to enable the main functionality as it is disabled by default.

Secondary functionality is temporarily rebinding SHIFT-TAB to FOCUSTARGET. This is disabled by default as well.

Plugin also adds a fakeunit "actualtarget" if you want your CR to act on your actual target by passing the target lock.

Example:

{"Living Bomb", "conditions", "actualtarget"}, {"Living Bomb", "conditions", "target"}

Lines using "actualtarget" as a unit will be ignored if this plugin is disabled so you don't need to require this plugin for your CR.
