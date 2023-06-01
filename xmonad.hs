-- Goes in ~/.xmonad/xmonad.hs

import Data.Ratio
import XMonad
import XMonad.Actions.CycleWS     
import XMonad.Actions.RotSlaves     
import XMonad.Hooks.DynamicLog    
import XMonad.Hooks.EwmhDesktops  
import XMonad.Hooks.ManageHelpers 
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerScreen
import XMonad.Layout.ThreeColumns
import XMonad.Util.NamedScratchpad

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Virtual terminal program
myTerminal      = "st"

-- Whether focus follows the mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels
myBorderWidth   = 3

-- No borders in fullscreen
myLayoutHook    = smartBorders $ ifWider 1920 (Tall 1 (3/100) (1/2)) (Mirror (Tall 1 (3/100) (1/2))) ||| ifWider 1920 (ThreeColMid 1 (1/20) (1/2)) (Tall 1 (3/100) (1/2)) ||| noBorders Full

-- Use "Windows key" as modifier key
myModMask       = mod4Mask

-- Configure number and name of workspaces
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","0"]

-- Border colors for unfocused and focused windows, respectively
myFocusedBorderColor = "#FF7700" -- Orange
myNormalBorderColor  = "#0088FF" -- Blue

-------------------------------------------------------------
------------------ Configure key bindings -------------------
-------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- close focused window
    [ ((modm,               xK_q     ), kill)

    -- move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- move focus to previous window
    , ((modm,               xK_k     ), windows W.focusUp)

    -- move focus to master window
    , ((modm,               xK_m     ), windows W.focusMaster)

    -- swap focused and master windows
    , ((modm,               xK_Return), windows W.swapMaster)

    -- expand master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- shrink master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- change to next layout
    , ((modm,               xK_space ), sendMessage NextLayout)

    -- next Workspace
    , ((modm,               xK_Up    ), nextWS)

    -- previous Workspace
    , ((modm,               xK_Down  ), prevWS)

    -- launch a virtual terminal
    , ((modm,               xK_v     ), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch audacity
    , ((modm,               xK_a     ), spawn "audacity")

    -- launch neomutt
    , ((modm,               xK_n     ), spawn "st -e neomutt")

    -- moc play from the beginning of the playlist
    , ((0,                0x1008FF12 ), spawn "st -e mocp -p")

    -- moc toggle play/pause
    , ((0,                0x1008FF14 ), spawn "st -e mocp -G")

    -- moc stop
    , ((0,                0x1008FF15 ), spawn "st -e mocp -s")

    -- moc previous track
    , ((0,                0x1008FF16 ), spawn "st -e mocp -r")

    -- moc next track
    , ((0,                0x1008FF17 ), spawn "st -e mocp -f")

    -- moc turn up volume
    , ((0,                0x1008FF13 ), spawn "st -e mocp -v +10")

    -- moc lower volume
    , ((0,                0x1008FF11 ), spawn "st -e mocp -v -10")

    -- recompile and restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

    -- rotate slave windows
    , ((modm,               xK_r     ), rotSlavesDown)

    -- open xournal 
    , ((modm,               xK_x     ), spawn "xournalpp")

    -- launch vifm
    , ((modm,               xK_f    ), spawn "st -e vifm")

    -- launch firefox
    , ((modm,               xK_w     ), spawn "librewolf")

    -- launch firefox private window
    , ((modm .|. shiftMask, xK_w     ), spawn "chromium")
    
    -- launch stremio
    , ((modm,               xK_e     ), spawn "stremio")

    -- launch telegram
    , ((modm,               xK_i     ), spawn "telegram-desktop")

    -- launch steam
    , ((modm .|. shiftMask, xK_v     ), spawn "steam")

    -- launch discord
    , ((modm .|. shiftMask, xK_i     ), spawn "discord")

    -- screenshot a certain area and save to clipboard
    , ((modm,               xK_Print ), spawn "sleep 0.2; scrot -s -f ~/Pictures/Screenshot_%Y%m%d_%T.png -e 'xclip -selection c -t image/png < $f'")

    -- kill screenkey
    , ((modm .|. shiftMask, xK_k     ), spawn "pkill -f screenkey")
    
    -- toggle st scratchpad
    , ((modm,               xK_s     ), namedScratchpadAction scratchpads "st")

    -- toggle mocp scratchpad
    , ((modm .|. shiftMask, xK_m     ), namedScratchpadAction scratchpads "mocp")

    ]

    ++

    -- Move and switch to worskpace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-------------------------------------------------------------
--- Mouse bindings: default actions bound to mouse events ---
-------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

       -- set the window to floating mode with left click and move by dragging
       [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                          >> windows W.shiftMaster))

       -- set the window to floating mode with right click and resize by dragging
       , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                          >> windows W.shiftMaster))

       ]

-------------------------------------------------------------
----------------------- Window rules ------------------------
-------------------------------------------------------------

myManageHook = composeAll
  [ isFullscreen --> doFullFloat
  , className =? "TelegramDesktop" --> doShift "0"
  , title =? "neomutt" --> doShift "0"
  , className =? "discord" --> doShift "0"
  , className =? "Slack" --> doShift "0"
  , className =? "Transmission-gtk" --> doShift "9"
  , className =? "Stremio" --> doShift "9"
  , title =? "Media viewer" --> doFloat 
  , title =? "mocp" --> doFloat
  , title =? " " --> doFloat
  , className =? "Steam" --> doShift "9"
  , title =? "Stephen's Sausage Roll" --> doFullFloat
  , title =? "Brawlhalla" --> doFullFloat
  , title =? "Pony Island" --> doFullFloat
  , title =? "Manifold Garden" --> doFloat
  , title =? "Pummel Party" --> doFloat
  , title =? "Hollow Knight" --> doFloat
  , title =? "UNDERTALE" --> doFloat
  , title =? "Celeste" --> doFloat
  , className =? "zoom" <&&> title=? "Chat" --> doFloat
  , className =? "mpv" --> doFloat
  , className =? "QjackCtl" --> doRectFloat (W.RationalRect (1 % 1) (1 % 1) (4 % 10) (1 % 7))
  , className =? "firefox" <&&> title =? "Picture-in-Picture" --> doFloat
  , className =? "LibreWolf" <&&> title =? "Picture-in-Picture" --> doFloat
  ]

-------------------------------------------------------------
----------------- Command to launch the bar -----------------
-------------------------------------------------------------

myBar = "xmobar"

-- Custom PP for what is being written to the bar

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-------------------------------------------------------------
------------------------ Scratchpads ------------------------
-------------------------------------------------------------

scratchpads :: [NamedScratchpad]
scratchpads = [

    NS "st" "st -n scratchpad" (resource =? "scratchpad")
        (customFloating $ W.RationalRect (1/31) (1/19) (29/31) (17/19)),

    NS "mocp" "st -n mocp -e mocp" (resource =? "mocp")
        (customFloating $ W.RationalRect (1/31) (1/19) (29/31) (17/19))

  ]

-------------------------------------------------------------
------------------------ Run xmonad -------------------------
-------------------------------------------------------------

main = xmonad =<< statusBar myBar myPP toggleStrutsKey (ewmh defaults)

defaults = def {
        terminal            = myTerminal,
        layoutHook          = myLayoutHook,
        focusFollowsMouse   = myFocusFollowsMouse,
        borderWidth         = myBorderWidth,
        modMask             = myModMask,
        workspaces          = myWorkspaces,
        normalBorderColor   = myNormalBorderColor,
        focusedBorderColor  = myFocusedBorderColor,

        -- key bindings
        keys                = myKeys,
        mouseBindings       = myMouseBindings,

        -- hooks, layouts
        manageHook          = myManageHook <+> namedScratchpadManageHook scratchpads,

        logHook             = dynamicLogWithPP . filterOutWsPP [scratchpadWorkspaceTag] $ def

        }
