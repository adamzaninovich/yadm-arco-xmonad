import System.IO
import System.Exit

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doFullFloat, doFloatAt, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS

import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import qualified DBus as D
import qualified DBus.Client as D

-- Colors
nordBrightRed     = "#e79397"
nordBrightGreen   = "#c3d9a9"
nordBrightPurple  = "#d5b3d2"
nordBlack         = "#3b4252"
nordBackground    = "#2e3440"
nordForeground    = "#d8dee9"

-- Settings
myTerminal          = "alacritty"
normBord            = nordBackground
focdBord            = nordBrightPurple
fore                = nordForeground
back                = nordBackground
leftEdge            = 0
underBar            = 37/1440
myModMask           = mod4Mask -- Super
myFocusFollowsMouse = True
myBorderWidth       = 3
myWorkspaces        = ["main", "alt", "3","4","5"]
myBaseConfig        = desktopConfig
dmenuCmd            = "dmenu_run -i -l 20 " ++ dmenuFormat
dmenuFormat         = "-nb '" ++ nordBackground   ++ "' "
                   ++ "-nf '" ++ nordBrightPurple ++ "' "
                   ++ "-sb '" ++ nordBackground   ++ "' "
                   ++ "-sf '" ++ nordBrightPurple ++ "' "
                   ++ "-fn 'FiraCode Nerd Font:Bold:pixelsize=20'"

-- Hooks & Layouts
myStartupHook = do
  spawn "$HOME/.xmonad/scripts/autostart.sh"
  setWMName "TachiWM"

myManageHook = composeAll . concat $
  [ [isDialog --> doCenterFloat]
  , [className =? c --> doFloat                     | c <- myFloats]
  , [className =? c --> doCenterFloat               | c <- myCFloats]
  , [title =? t --> doCenterFloat                   | t <- myTFloats]
  , [resource =? r --> doFloat                      | r <- myRFloats]
  , [resource =? r --> doIgnore                     | r <- myIgnores]
  , [className =? c --> doFullFloat                 | c <- myFFloats]
  , [className =? c --> doFloatAt leftEdge underBar | c <- myTLFloats]
  ]
  where
    myFloats    = ["Screen"]
    myCFloats   = ["Arandr", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "feh", "mpv", "Nitrogen"]
    myTFloats   = ["Two-factor authentication", "Downloads", "Save As...", "seahorse", "XMonad Help"]
    myRFloats   = []
    myIgnores   = ["desktop_window"]
    myFFloats   = ["Arcologout.py"]
    myTLFloats  = ["Xfce4-appfinder"]

myLayout = avoidStruts $ mkToggle (NBFULL ?? EOT) $ tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2

-- Bindings
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $ [
  -- mod-button1, Set the window to floating mode and move by dragging
  ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)),
  -- mod-button2, Raise the window to the top of the stack
  ((modMask, 2), (\w -> focus w >> windows W.shiftMaster)),
  -- mod-button3, Set the window to floating mode and resize by dragging
  ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
  ]

myKeyBindings conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $ [
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS
  ((modMask, xK_f), sendMessage $ Toggle NBFULL),
  ((modMask, xK_a), spawn $ myTerminal ++ " -t 'Activity Monitor | gotop' -e gotop" ),
  ((modMask, xK_h), spawn $ myTerminal ++ " -t 'Activity Manager | htop' -e htop" ),
  ((modMask, xK_slash), spawn $ myTerminal ++ " -t 'XMonad Help' -e bat --style=plain --theme=Nord ~/.config/xmonad/README.md" ),
  ((modMask, xK_p), spawn $ "rofi -show run" ),
  ((modMask, xK_q), kill ),
  ((modMask, xK_t), spawn $ "$HOME/.xmonad/scripts/toggle-stalonebar.sh" ),
  ((modMask, xK_y), spawn $ "polybar-msg cmd toggle" ),
  ((modMask, xK_x), spawn $ "arcolinux-logout" ),
  ((modMask, xK_Escape), spawn $ "xkill" ),
  ((modMask, xK_Return), spawn $ myTerminal ),
  -- SUPER + SHIFT KEYS
  ((modMask .|. shiftMask , xK_Return ), spawn $ "thunar"),
  ((modMask .|. shiftMask , xK_d ), spawn $ dmenuCmd ),
  ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart"),
  ((modMask .|. shiftMask , xK_q ), kill),
  -- CONTROL + ALT KEYS
  ((controlMask .|. mod1Mask , xK_Next ), spawn $ "conky-rotate -n"),
  ((controlMask .|. mod1Mask , xK_Prior ), spawn $ "conky-rotate -p"),
  ((controlMask .|. mod1Mask , xK_b ), spawn $ "google-chrome-stable"),
  ((controlMask .|. mod1Mask , xK_d ), spawn $ "google-chrome-stable https://www.icloud.com/iclouddrive/"),
  ((controlMask .|. mod1Mask , xK_e ), spawn $ "arcolinux-tweak-tool"),
  ((controlMask .|. mod1Mask , xK_i ), spawn $ "nitrogen"),
  ((controlMask .|. mod1Mask , xK_k ), spawn $ "arcolinux-logout"),
  ((controlMask .|. mod1Mask , xK_o ), spawn $ "$HOME/.xmonad/scripts/picom-toggle.sh"),
  ((controlMask .|. mod1Mask , xK_s ), spawn $ "spotify"),
  -- ((controlMask .|. mod1Mask , xK_t ), spawn $ myTerminal),
  ((controlMask .|. mod1Mask , xK_Return ), spawn $ myTerminal),
  -- ALT + ... KEYS
  ((mod1Mask, xK_space), spawn $ "rofi -show run" ),
  ((mod1Mask, xK_e), spawn $ "rofi -show emoji -modi emoji" ),
  ((mod1Mask, xK_c), spawn $ "rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history" ),
  ((mod1Mask, xK_equal), spawn $ "rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history" ),
  ((mod1Mask .|. modMask , xK_c ), spawn $ "CM_LAUNCHER=rofi clipmenu"),
  ((mod1Mask, xK_r), spawn $ "xmonad --restart" ),
  --SCREENSHOTS
  ((0, xK_Print), spawn $ "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'"),
  -- start screenrecord
  ((modMask, xK_Print), spawn $ "ffcast rec \"$HOME/screencast-%s-$(date -Is).mp4\""),
  -- stop screenrecord
  ((modMask .|. controlMask , xK_Print), spawn $ "pkill -fxn '(/\\S+)*ffmpeg\\s.*\\sx11grab\\s.*'"),
  --MULTIMEDIA KEYS
  -- Mute volume
  ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle"),
  -- Decrease volume
  ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-"),
  -- Increase volume
  ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+"),
  -- Increase brightness
  ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 5"),
  -- Decrease brightness
  ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5"),
  -- ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause"),
  -- ((0, xF86XK_AudioNext), spawn $ "playerctl next"),
  -- ((0, xF86XK_AudioPrev), spawn $ "playerctl previous"),
  -- ((0, xF86XK_AudioStop), spawn $ "playerctl stop"),
  --  XMONAD LAYOUT KEYS
  -- Cycle through the available layout algorithms.
  ((modMask, xK_space), sendMessage NextLayout),
  --Focus selected desktop
  ((mod1Mask, xK_Tab), windows W.focusDown),
  --Focus selected desktop
  ((modMask, xK_Tab), nextWS),
  --Focus selected desktop
  ((controlMask .|. mod1Mask , xK_Left ), prevWS),
  --Focus selected desktop
  ((controlMask .|. mod1Mask , xK_Right ), nextWS),
  -- Reset the layouts on the current workspace to default.
  ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
  -- Move focus to the next window.
  ((modMask, xK_j), windows W.focusDown),
  -- Move focus to the previous window.
  ((modMask, xK_k), windows W.focusUp  ),
  -- Move focus to the master window.
  ((modMask .|. shiftMask, xK_m), windows W.focusMaster  ),
  -- Swap the focused window with the next window.
  ((modMask .|. shiftMask, xK_j), windows W.swapDown  ),
  -- Swap the focused window with the next window.
  ((controlMask .|. modMask, xK_Down), windows W.swapDown  ),
  -- Swap the focused window with the previous window.
  ((modMask .|. shiftMask, xK_k), windows W.swapUp    ),
  -- Swap the focused window with the previous window.
  ((controlMask .|. modMask, xK_Up), windows W.swapUp  ),
  -- Shrink the master area.
  ((controlMask .|. shiftMask , xK_h), sendMessage Shrink),
  -- Expand the master area.
  ((controlMask .|. shiftMask , xK_l), sendMessage Expand),
  -- Push window back into tiling.
  ((modMask .|. shiftMask , xK_t), withFocused $ windows . W.sink),
  -- Increment the number of windows in the master area.
  ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1)),
  -- Decrement the number of windows in the master area.
  ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))
  ]
  ++
  -- Select Desktop with Super 1..5
  [((m .|. modMask, k), windows $ f i)
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

-- Main Config
defaults = myBaseConfig {
  -- Settings
  terminal            = myTerminal,
  borderWidth         = myBorderWidth,
  modMask             = myModMask,
  workspaces          = myWorkspaces,
  normalBorderColor   = normBord,
  focusedBorderColor  = focdBord,
  focusFollowsMouse   = myFocusFollowsMouse,
  -- Hooks & Layouts
  layoutHook          = myLayout,
  startupHook         = myStartupHook,
  manageHook          = manageSpawn <+> myManageHook <+> manageHook myBaseConfig,
  handleEventHook     = handleEventHook myBaseConfig <+> fullscreenEventHook,
  -- Bindings
  keys                = myKeyBindings,
  mouseBindings       = myMouseBindings
}

-- Main Function
main :: IO ()
main = do
    dbus <- D.connectSession
    D.requestName dbus (D.busName_ "org.xmonad.Log") [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad . ewmh $ defaults
