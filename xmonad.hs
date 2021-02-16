import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.WindowSwallowing
import XMonad.Layout
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace
import XMonad.ManageHook
import XMonad.Util.EZConfig

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- My terminal of preference.
myTerminal      = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window.
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 3

-- No borders in fullscreen.
myLayoutHook    =  smartBorders $ Mirror (Tall 1 (3/100) (1/2)) ||| Tall 1 (3/100) (1/2) ||| noBorders Full 

-- Set the "Windows/Super Key" as the modifier key.
myModMask       = mod4Mask

-- Number and names of workspaces.
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","0"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#0088FF"
myFocusedBorderColor = "#FF7700"

-- Key bindings.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Launch terminal.
    [ ((modm,               xK_v     ), spawn $ XMonad.terminal conf)

    -- Launch dmenu.
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- Close focused window.
    , ((modm,               xK_q     ), kill)

    -- Quit XMonad.
    , ((modm,               xK_Escape), io (exitWith ExitSuccess))

    -- Restart XMonad.
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; killall xmobar; xmonad --restart")

    -- Open Zathura.
    , ((modm,               xK_r     ), spawn "zathura")

    -- Open Xournal++.
    , ((modm,               xK_x     ), spawn "xournalpp")

    -- Rotate through available layout algorithms.
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- Move focus to the next window.
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to previous window.
    , ((modm,               xK_k     ), windows W.focusUp)

    -- Move focus to master window.
    , ((modm,               xK_m     ), windows W.focusMaster)

    -- Swap focused and master windows.
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Shrink master window area.
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand master window area.
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Force window back into tiling.
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Launch vifm.
    , ((modm,               xK_f    ), spawn "st -e vifm")

    -- Launch Firefox.
    , ((modm,               xK_w     ), spawn "firefox")

    -- Launch Firefox Private Window.
    , ((modm .|. shiftMask, xK_w     ), spawn "firefox --private-window")
    
    -- Launch Reaper.
    , ((modm,               xK_d     ), spawn "reaper")

    -- Launch qt-jack.
    , ((modm,               xK_a     ), spawn "qjackctl")

    -- Launch Thunderbird.
    , ((modm,               xK_e     ), spawn "thunderbird")

    -- Launch Stremio.
    , ((modm .|. shiftMask, xK_e     ), spawn "stremio")

    -- Launch Telegram.
    , ((modm,               xK_i     ), spawn "telegram-desktop")

    -- Launch Steam.
    , ((modm .|. shiftMask, xK_v     ), spawn "steam")

    -- Launch Discord.
    , ((modm .|. shiftMask, xK_i     ), spawn "discord")

    -- Launch Krita.
    , ((modm,               xK_g     ), spawn "krita")

    -- Screenshot a certain area and save to clipboard.
    , ((modm,               xK_Print ), spawn "sleep 0.2; scrot -s -f ~/Pictures/Screenshot_%Y%m%d_%T.png -e 'xclip -selection c -t image/png < $f'")
    
    -- Next Workspace.
    , ((modm,               xK_Up    ), nextWS)

    -- Previous Workspace.
    , ((modm,               xK_Down  ), prevWS)

    ]

    ++

    -- Move and switch to worskpace N.
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-- Window rules.
myManageHook = composeAll
  [ isFullscreen --> doFullFloat
  , className =? "Thunderbird" --> doShift "0"
  , className =? "discord" --> doShift "0"
  , className =? "TelegramDesktop" --> doShift "0"
  , className =? "Transmission-gtk" --> doShift "0"
  , title =? "Media viewer" --> doFloat 
  , title =? " " --> doFloat
  , className =? "Steam" <&&> title =? "Stephen's Sausage Roll" --> doFullFloat
  , title =? "Brawlhalla" --> doFullFloat
  , title =? "Pony Island" --> doFullFloat
  , title =? "Manifold Garden" --> doFloat
  , className =? "zoom" <&&> title=? "Chat" --> doFloat
  , className =? "mpv" --> doFullFloat
  , className =? "firefox" <&&> title =? "Picture-in-Picture" --> doFloat
  ]

-- My status bar of preference.
myBar           = "xmobar"

-- Key binding to toggle the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- PP
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Run xmonad with my settings.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey (ewmh defaults)

-- A structure containing my configuration settings, overriding
-- fields in the default config. Any field not overriden will
-- be taken from the defaults in xmonad/XMonad/Config.hs.
defaults = def {
        terminal            = myTerminal,
        focusFollowsMouse   = myFocusFollowsMouse,
        clickJustFocuses    = myClickJustFocuses,
        borderWidth         = myBorderWidth,
        modMask             = myModMask,
        workspaces          = myWorkspaces,
        normalBorderColor   = myNormalBorderColor,
        focusedBorderColor  = myFocusedBorderColor,
        keys                = myKeys,
        layoutHook          = myLayoutHook,
        manageHook          = myManageHook
    }
