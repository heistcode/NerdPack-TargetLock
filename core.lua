-- luacheck: globals NeP
local addonname, TL         = ...
local UnitExists            = UnitExists
local UnitCanAttack         = UnitCanAttack
local UnitIsDeadOrGhost     = UnitIsDeadOrGhost
local UnitAffectingCombat   = UnitAffectingCombat
local FocusUnit             = FocusUnit
local C_Timer               = C_Timer
local SetOverrideBinding    = SetOverrideBinding
local ClearOverrideBindings = ClearOverrideBindings
local NeP                   = NeP

TL.Version                  = 0.11

local config  = {
	key      = "NeP_TargetLock",
	title    = addonname,
	subtitle = "Settings",
	width    = 250,
	height   = 200,
	config   = {
		{
      type    = "checkbox",
      text    = "Use Focus as Target Lock",
      key     = "UseFocus",
      desc    = "In combat your focus target will be used as a target lock leaving you free to" ..
					"tab target without interupting your DPS. Use a focus macro or keybind to change your" ..
					"focus target.",
      default = false
    },
    {
      type    = "checkbox",
      text    = "Rebind Shift-Tab to Focus Target",
      key     = "RefocusShiftTab",
      desc    = "Focus your target using shift-tab. Uses a temporary keybind override so the" ..
					"default keybind is kept in tact when this is unchecked or this addon is not loaded.",
      default = false
    }
	}
}

local GUI = NeP.Interface:BuildGUI(config)
NeP.Interface:Add("Target Lock V:"..TL.Version, function() GUI:Show() end)
GUI:Hide()

local function IsGoodUnit(unit)
  return UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit)
end

local function UseFocus()
  return NeP.Interface:Fetch("NeP_TargetLock", "UseFocus")
end

local function RefocusShiftTab()
  return NeP.Interface:Fetch("NeP_TargetLock", "RefocusShiftTab")
end

local function IsMasterToggled()
  return NeP.DSL:Get('toggle')(nil, 'mastertoggle')
end

NeP.FakeUnits:Add("target", function()
  if NeP.Unlocked and UseFocus() then
    if IsGoodUnit("focus") then
      return "focus"
    elseif IsGoodUnit("target") and IsMasterToggled() and UnitAffectingCombat("player") then
      FocusUnit("target")
      return "focus"
    end
  end
  return "target"
end)

NeP.FakeUnits:Add("actualtarget", function()
  return "target"
end)

local RefocusButton = CreateFrame("BUTTON", "RefocusButton")

C_Timer.NewTicker(1, function()
  if RefocusShiftTab() and NeP.Unlocked then
    if RefocusButton.BindingSet ~= true then
      SetOverrideBinding(RefocusButton, true, "SHIFT-TAB", "FOCUSTARGET")
      RefocusButton.BindingSet = true
    end
  elseif RefocusButton.BindingSet then
    ClearOverrideBindings(RefocusButton)
    RefocusButton.BindingSet = false
  end
end)
