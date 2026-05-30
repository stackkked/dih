--[[
    MIDNIGHT UI Library v6.4.0 в†’ v7.1.0

    v7.1 Changelog:
    - FEAT: Config system вЂ” MIDNIGHT:SetupConfig(key) / SaveConfig() / LoadConfig() / ResetConfig()
    - FEAT: Per-widget Flag= parameter for Toggle, Slider, Dropdown, InlineDropdown, TextBox, ColorPicker, Keybind, Table
    - FEAT: MakeWindow now accepts Width=, Height=, Resizable=, MinWidth=, MinHeight= config fields
    - FEAT: wd:SetSize(w, h) вЂ” programmatic animated window resize
    - FEAT: Resizable windows get a bottom-right grip handle (3 diagonal stripes)
    - FEAT: td:AddTable(config) вЂ” DataGrid widget with sortable columns, search, alternating rows, auto-width columns
    - FEAT: AddTable supports :SetRows(), :AddRow(), :RemoveRow(), :GetRows(), :Clear(), :SetColumnWidth()
    - FEAT: AddTable has Searchable= option for live text filter
    - FEAT: Config serializer handles toggle/slider/dropdown/multiselect/textbox/color/keybind types
    - FEAT: Config falls back to ScreenGui attribute storage when writefile/readfile unavailable
    - FIX:  Intro animation Position now computed from actual winW/winH
    - FIX:  Minimize restores to actual winW/winH instead of hardcoded 600Г—440

    v7.0 Changelog:
    - FEAT: AddDropdown now supports Multi=true for multiselect mode
    - FEAT: AddInlineDropdown now supports Multi=true for multiselect mode
    - FEAT: Multiselect shows checkboxes per option, Apply button to confirm, live label "Item1 +N"
    - ANIM: Intro animation on MakeWindow вЂ” slide-up + fade-in (Back easing) + border accent pulse
    - ANIM: Menu open/close uses Quint easing (smoother than Quad)
    - ANIM: Tab switch detects direction (left/right) and slides content accordingly
    - ANIM: Tab indicator: shrinks to 0 then springs out with Back easing on activation
    - ANIM: Toggle knob squash/stretch вЂ” knob compresses horizontally during slide, springs back
    - ANIM: Slider knob scales up (18px) on grab, springs back to 14px on release
    - ANIM: Dropdown open: Back easing instead of Quad, slight fade-in
    - ANIM: Dropdown close: fade + collapse simultaneously
    - ANIM: Dropdown options have ripple flash on click (AccentDark в†’ normal)
    - ANIM: InlineDropdown chevron rotates 180В° on expand (Back easing), has separator fade
    - ANIM: Button hover: accent left stripe appears + text color shifts to TextAccent
    - ANIM: Button click: AccentDark flash + border pulse, recovers with Quint
    - ANIM: Notification dismiss: slide-out + fade simultaneously (Quint In)
    - ANIM: Notification reposition: Back easing instead of Quad
    Styled after the MIDNIGHT CS2 Cheat
    For Roblox Executors

    v6.9 Changelog:
    - FIX: _MenuOpen now starts as false вЂ” menu opens on first keypress (was requiring two presses)
    - FIX: _MenuOpen in Reset() was incorrectly set to true вЂ” now false (menu starts closed after reset)
    - FIX: _MenuOpen syncs with MakeWindow вЂ” set to true after creation since window IS visible
    - FIX: KeyCodeToName gsub order вЂ” ^Left/^Right now runs before Returnв†’Enter, preventing "LEnter"
    - FIX: CreateWatermark now calls _UpdateWatermark() at end, so SetWatermarkText called before CreateWatermark works immediately
    - FIX: KeybindSettings key listener (conn2) now disconnected when panel closes without key selection
    - FIX: task.cancel now checks typeof(th)=="thread" before calling (executor compat)
    - FIX: Close button also uses typeof thread check for task.cancel
    - FIX: Menu open animation no longer resets Size to 0 вЂ” just fade in with BackgroundTransparency (prevents ClipsDescendants clipping content)
    - FIX: MakeWindow creation animation simplified to fade-in only (no Size=0 reset that clips all child content)
    - FIX: Menu close animation also uses fade-out only вЂ” no Size tween to 0 (prevents stuck 0x0 size on next open)
    - FIX: Window frame (wf) and TitleBar (tb) now have Active=true вЂ” Frames receive input, child buttons work
    - FIX: TitleBar ClipsDescendants=false вЂ” drag input works properly on empty title bar areas
    - FIX: Close button handler now cancels pending close threads before resetting _MenuCloseThreads (prevents orphaned threads)
    - FIX: MakeWindow sets BackgroundTransparency=0 explicitly before tween (executor safety net for unreliable TweenService)

    v6.8 Changelog:
    - FIX: _global_wait nil check in delay fallback вЂ” no crash if global wait unavailable
    - FIX: ThemeCallbacks cbIdx replaced with reference-based removal (prevents wrong callback deletion)
    - FIX: _RepositionNotifications passes real notification index instead of hardcoded 1
    - FIX: AddToggle OnModeChange now updates local bindMode variable
    - FIX: Menu double-tap race condition вЂ” pending close-delay threads are cancelled on reopen
    - FIX: Close button also tracks close-delay threads for proper cancellation

    v6.7 Changelog:
    - FIX: task.wait fallback вЂ” local `task` was nil during table init, causing no-op wait
    - FIX: AddInlineColorPicker вЂ” `data` declared after preset closures, caused nil error on preset click
    - FIX: _ShowKeybindSettings ThemeCallbacks accumulated on every open вЂ” now tracked and removed on close
    - FIX: AddKeybind modeLbl.Text not updating when mode changes externally (kd._Mode)
    - FIX: Notify dismiss could fire twice (timer + close button) вЂ” added dismissed guard flag
    - FIX: MakeDraggable handle.InputBegan/InputChanged now registered via RegConn for cleanup
    - FIX: Slider callback no longer fires on Set() when value hasn't changed

    v6.6 Changelog:
    - FIX: Dropdown _Value now correctly updates on selection (was stuck at default)
    - FIX: InlineDropdown _Value now correctly updates on selection
    - FIX: ColorPicker now has _Value field and it updates on selection and Set()
    - FIX: InlineColorPicker _Value now updates on Set() and on preset selection
    - FIX: Scrollbar auto-hide no longer crashes (task.cancel was called with boolean)
    - FIX: Watermark position change no longer causes visual jump (AnchorPoint+Position set atomically)
    - FIX: Lagspike blink loop now properly stops when lagspike ends (added _lagspikeBlinkStop)
    - FIX: Reset lagL.TextTransparency to 0 when hiding lagspike label
    - FIX: AddInput (legacy alias) now forwards Default parameter
    - FIX: Recursive wait fallback replaced with safe task.wait reference
    - FIX: MakeDraggable UserInputService.InputChanged now registered via RegConn for cleanup
    - FIX: AddKeybind and KeybindSettings temp listeners registered via RegConn + Destroying cleanup
    - FIX: AddTextBox no longer creates duplicate UIStroke on focus/blur (reuses single stroke)
    - FIX: Watermark updateSize loop uses self._WatermarkFrame instead of local (survives Reset)
    - FIX: Removed dead visualLeft calculation in SetWatermarkPosition
    - CLEANUP: Removed unused _lagspikeBlinkConn module-level variable

    v6.4 Changelog:
    - CRITICAL: Added MIDNIGHT:Destroy() with full connection cleanup
    - CRITICAL: All InputBegan connections stored in _Connections table, disconnected on Destroy()
    - CRITICAL: Removed pcall(Instance.new, ...) вЂ” errors are visible now
    - ARCH: ZIndex constants table (ZIndex = { WINDOW, POPUP, OVERLAY, ... })
    - ARCH: Added MIDNIGHT:Reset() вЂ” full state reset without recreating GUI
    - ARCH: Added MIDNIGHT.Version = "6.4.0"
    - WIDGETS: AddTextBox вЂ” new widget
    - WIDGETS: AddButton вЂ” proper standalone widget
    - WIDGETS: AddDropdown inline (no popup) вЂ” for simple cases
    - WIDGETS: AddColorPicker inline in tab
    - WIDGETS: AddSeparator вЂ” visual separator with gradient fade
    - UX: Icon cache вЂ” icons loaded once, reused
    - UX: tab:SetVisible(bool) вЂ” hide/show tabs dynamically
    - UX: MIDNIGHT:SetWatermarkText(text) вЂ” custom watermark text
    - UX: Notifications вЂ” close (вњ•) button on each notification
    - MISC: ParseKeyCode / KeyCodeToName moved to top-level module (KeyUtils)
    - MISC: MIDNIGHT.Version for version checking
    - SLIDER: Manual value input on label click в†’ TextBox
    - UI: Gradient accent line (darker edges в†’ bright center)
    - UI: Hover left border (2px) on items
    - UI: Active tab вЂ” UIStroke glow
    - UI: Scrollbar auto-hide (appears on scroll, fades after 1.5s)
    - UI: Toggle flash animation on knob
    - UI: Slider knob tooltip on drag
    - UI: Notification icon scale 0в†’1 with Back easing
    - UI: Separator with gradient fade
    - TYPO: TextSecondary labels 12px (was 11px)
    - TYPO: Slider value right-aligned, fixed width
    - TYPO: Section name letter-spacing (spaces between chars)
    - TYPO: Keybind badge вЂ” InputBg bg, rounded corners
    - ANIM: Window open вЂ” BackgroundTransparency 1в†’0 simultaneously
    - ANIM: Popup close 0.1s (was 0.15s)
    - ANIM: Tab switch вЂ” slide content
    - ANIM: Watermark lagspike blink tween
    - STRUCT: Sidebar tab grouping separator if tabs > 6
    - STRUCT: Sidebar footer: version + ping/fps
    - STRUCT: Empty tab placeholder text "No items"
]]

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// SERVICES
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local TextService      = game:GetService("TextService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local Stats            = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

--// TASK LIBRARY COMPATIBILITY
local _global_wait = typeof(wait) == "function" and wait or nil
local task = task or {
    delay = typeof(delay) == "function" and delay or function(t, f) coroutine.wrap(function() if _global_wait then _global_wait(t or 0) end; f() end)() end,
    defer  = function(f) coroutine.wrap(f)() end,
    spawn  = typeof(spawn) == "function" and spawn or function(f) coroutine.wrap(f)() end,
    wait   = _global_wait or function(t) return 0 end,
}

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// Z-INDEX CONSTANTS
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local ZIndex = {
    WINDOW   = 10,
    CONTENT  = 15,
    POPUP    = 50,
    DROPDOWN = 55,
    OVERLAY  = 90,
    TOOLTIP  = 120,
    NOTIFY   = 150,
    TOP      = 200,
}

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// THEME
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local Theme = {
    WindowBg       = Color3.fromRGB(15, 17, 20),
    SidebarBg      = Color3.fromRGB(16, 18, 21),
    ContentBg      = Color3.fromRGB(18, 20, 24),
    TabBg          = Color3.fromRGB(20, 22, 26),
    TabHoverBg     = Color3.fromRGB(24, 27, 32),
    TabActiveBg    = Color3.fromRGB(28, 31, 37),
    ItemBg         = Color3.fromRGB(20, 22, 26),
    ItemHoverBg    = Color3.fromRGB(24, 27, 32),
    InputBg        = Color3.fromRGB(23, 26, 31),
    DropdownBg     = Color3.fromRGB(18, 20, 24),
    TitleBarBg     = Color3.fromRGB(15, 17, 20),
    Accent         = Color3.fromRGB(96, 190, 255),
    AccentHover    = Color3.fromRGB(128, 205, 255),
    AccentDark     = Color3.fromRGB(58, 143, 204),
    TextPrimary    = Color3.fromRGB(234, 238, 242),
    TextSecondary  = Color3.fromRGB(154, 162, 174),
    TextMuted      = Color3.fromRGB(92, 101, 114),
    TextAccent     = Color3.fromRGB(128, 205, 255),
    Border         = Color3.fromRGB(33, 37, 43),
    BorderLight    = Color3.fromRGB(43, 48, 56),
    BorderAccent   = Color3.fromRGB(51, 90, 120),
    ToggleOn       = Color3.fromRGB(96, 190, 255),
    ToggleOff      = Color3.fromRGB(40, 44, 52),
    ToggleKnob     = Color3.fromRGB(255, 255, 255),
    SliderTrack    = Color3.fromRGB(34, 38, 45),
    SliderFill     = Color3.fromRGB(96, 190, 255),
    SliderKnob     = Color3.fromRGB(255, 255, 255),
    Success        = Color3.fromRGB(74, 222, 128),
    Warning        = Color3.fromRGB(250, 204, 21),
    Error          = Color3.fromRGB(248, 113, 113),
    Info           = Color3.fromRGB(96, 190, 255),
    WatermarkBg    = Color3.fromRGB(15, 17, 20),
    KeybindBg      = Color3.fromRGB(15, 17, 20),
    CloseNormal    = Color3.fromRGB(40, 44, 52),
    CloseHover     = Color3.fromRGB(168, 62, 62),
    MinNormal      = Color3.fromRGB(40, 44, 52),
    MinHover       = Color3.fromRGB(47, 60, 76),
    ScrollBarColor = Color3.fromRGB(62, 74, 90),
    ScrollBarBg    = Color3.fromRGB(26, 29, 34),
    Shadow         = Color3.fromRGB(0, 0, 0),
    SeparatorBg    = Color3.fromRGB(33, 37, 43),
    InputHoverBg   = Color3.fromRGB(27, 31, 37),
    OverlayBg      = Color3.fromRGB(14, 16, 20),
    OverlayCard    = Color3.fromRGB(18, 21, 26),
    OverlayStroke  = Color3.fromRGB(45, 54, 66),
    BorderSoft     = Color3.fromRGB(29, 33, 39),
    BorderStrong   = Color3.fromRGB(52, 59, 70),
    AccentSoft     = Color3.fromRGB(118, 202, 255),
    AccentMuted    = Color3.fromRGB(72, 130, 166),
    AccentFaint    = Color3.fromRGB(34, 55, 68),
    UtilityBg      = Color3.fromRGB(13, 15, 18),
    UtilityHeader  = Color3.fromRGB(17, 19, 23),
    UtilityAccent  = Color3.fromRGB(87, 179, 238),
    Surface0       = Color3.fromRGB(13, 15, 18),
    Surface1       = Color3.fromRGB(16, 18, 21),
    Surface2       = Color3.fromRGB(20, 22, 26),
    Surface3       = Color3.fromRGB(24, 27, 32),
}

local Font        = Enum.Font.GothamSemibold
local FontBold    = Enum.Font.GothamBold
local FontRegular = Enum.Font.Gotham

local CompactStyle = {
    WindowRadius = 8,
    HeaderRadius = 8,
    WidgetRadius = 5,
    InputRadius = 4,
    BadgeRadius = 4,
    WindowWidth = 580,
    WindowHeight = 420,
    TitleBarHeight = 36,
    CollapsedWindowHeight = 36,
    SidebarWidth = 122,
    SidebarFooterHeight = 24,
    TabHeight = 28,
    SidebarPadding = 6,
    TabIconSize = 14,
    TabTextSize = 11,
    SectionHeight = 24,
    SectionTextSize = 10,
    SectionGap = 4,
    RowHeight = 34,
    TallRowHeight = 48,
    FieldHeight = 20,
    FieldTextSize = 10,
    BodyTextSize = 11,
    MetaTextSize = 10,
    UtilityTextSize = 10,
    UtilityMetaSize = 9,
    OverlayRadius = 8,
    OverlayPadding = 8,
    OverlayHeaderHeight = 30,
    FloatingTitleSize = 11,
    FloatingLineSize = 10,
    NotificationWidth = 316,
    NotificationCompactWidth = 304,
    NotificationCompact = true,
}

local DensityStyles = {
    Compact = {
        WindowWidth = 580,
        WindowHeight = 420,
        TitleBarHeight = 36,
        CollapsedWindowHeight = 36,
        SidebarWidth = 122,
        SidebarFooterHeight = 24,
        TabHeight = 28,
        SidebarPadding = 6,
        TabIconSize = 14,
        TabTextSize = 11,
        SectionHeight = 24,
        SectionTextSize = 10,
        SectionGap = 4,
        RowHeight = 34,
        TallRowHeight = 48,
        FieldHeight = 20,
        FieldTextSize = 10,
        BodyTextSize = 11,
        MetaTextSize = 10,
        UtilityTextSize = 10,
        UtilityMetaSize = 9,
        OverlayRadius = 8,
        OverlayPadding = 8,
        OverlayHeaderHeight = 30,
        FloatingTitleSize = 11,
        FloatingLineSize = 10,
        NotificationWidth = 316,
        NotificationCompactWidth = 304,
        NotificationCompact = true,
    },
    Readable = {
        WindowWidth = 620,
        WindowHeight = 450,
        TitleBarHeight = 38,
        CollapsedWindowHeight = 38,
        SidebarWidth = 134,
        SidebarFooterHeight = 26,
        TabHeight = 31,
        SidebarPadding = 7,
        TabIconSize = 15,
        TabTextSize = 12,
        SectionHeight = 26,
        SectionTextSize = 11,
        SectionGap = 5,
        RowHeight = 38,
        TallRowHeight = 54,
        FieldHeight = 22,
        FieldTextSize = 11,
        BodyTextSize = 12,
        MetaTextSize = 11,
        UtilityTextSize = 11,
        UtilityMetaSize = 10,
        OverlayRadius = 8,
        OverlayPadding = 10,
        OverlayHeaderHeight = 32,
        FloatingTitleSize = 12,
        FloatingLineSize = 11,
        NotificationWidth = 340,
        NotificationCompactWidth = 326,
        NotificationCompact = false,
    },
    Streamer = {
        WindowWidth = 660,
        WindowHeight = 470,
        TitleBarHeight = 40,
        CollapsedWindowHeight = 40,
        SidebarWidth = 142,
        SidebarFooterHeight = 28,
        TabHeight = 34,
        SidebarPadding = 8,
        TabIconSize = 16,
        TabTextSize = 13,
        SectionHeight = 28,
        SectionTextSize = 12,
        SectionGap = 6,
        RowHeight = 40,
        TallRowHeight = 58,
        FieldHeight = 24,
        FieldTextSize = 12,
        BodyTextSize = 13,
        MetaTextSize = 11,
        UtilityTextSize = 12,
        UtilityMetaSize = 11,
        OverlayRadius = 8,
        OverlayPadding = 12,
        OverlayHeaderHeight = 34,
        FloatingTitleSize = 13,
        FloatingLineSize = 12,
        NotificationWidth = 360,
        NotificationCompactWidth = 344,
        NotificationCompact = false,
    },
}

local Motion = {
    Micro = {Duration = 0.12, Style = Enum.EasingStyle.Quad, Direction = Enum.EasingDirection.Out},
    Soft = {Duration = 0.16, Style = Enum.EasingStyle.Quad, Direction = Enum.EasingDirection.Out},
    Panel = {Duration = 0.22, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out},
    OverlayIn = {Duration = 0.24, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out},
    OverlayOut = {Duration = 0.18, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.In},
    Intro = {Duration = 0.34, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out},
    Loading = {Duration = 1.35, Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out},
}

local CurrentDensityMode = "Compact"
local function ApplyDensityTokens(mode)
    local preset = DensityStyles[mode] or DensityStyles.Compact
    CurrentDensityMode = DensityStyles[mode] and mode or "Compact"
    for k, v in pairs(preset) do
        CompactStyle[k] = v
    end
end

ApplyDensityTokens(CurrentDensityMode)

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// KEY UTILS MODULE
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local KeyUtils = {}

local _KeyMap = {
    leftshift=Enum.KeyCode.LeftShift, rightshift=Enum.KeyCode.RightShift,
    leftcontrol=Enum.KeyCode.LeftControl, rightcontrol=Enum.KeyCode.RightControl,
    leftalt=Enum.KeyCode.LeftAlt, rightalt=Enum.KeyCode.RightAlt,
    tab=Enum.KeyCode.Tab, capslock=Enum.KeyCode.CapsLock, space=Enum.KeyCode.Space,
    enter=Enum.KeyCode.Return, escape=Enum.KeyCode.Escape, backspace=Enum.KeyCode.Backspace,
    insert=Enum.KeyCode.Insert, delete=Enum.KeyCode.Delete, home=Enum.KeyCode.Home,
    ["end"]=Enum.KeyCode.End, pageup=Enum.KeyCode.PageUp, pagedown=Enum.KeyCode.PageDown,
    f1=Enum.KeyCode.F1, f2=Enum.KeyCode.F2, f3=Enum.KeyCode.F3, f4=Enum.KeyCode.F4,
    f5=Enum.KeyCode.F5, f6=Enum.KeyCode.F6, f7=Enum.KeyCode.F7, f8=Enum.KeyCode.F8,
    f9=Enum.KeyCode.F9, f10=Enum.KeyCode.F10, f11=Enum.KeyCode.F11, f12=Enum.KeyCode.F12,
    a=Enum.KeyCode.A, b=Enum.KeyCode.B, c=Enum.KeyCode.C, d=Enum.KeyCode.D, e=Enum.KeyCode.E,
    f=Enum.KeyCode.F, g=Enum.KeyCode.G, h=Enum.KeyCode.H, i=Enum.KeyCode.I, j=Enum.KeyCode.J,
    k=Enum.KeyCode.K, l=Enum.KeyCode.L, m=Enum.KeyCode.M, n=Enum.KeyCode.N, o=Enum.KeyCode.O,
    p=Enum.KeyCode.P, q=Enum.KeyCode.Q, r=Enum.KeyCode.R, s=Enum.KeyCode.S, t=Enum.KeyCode.T,
    u=Enum.KeyCode.U, v=Enum.KeyCode.V, w=Enum.KeyCode.W, x=Enum.KeyCode.X, y=Enum.KeyCode.Y,
    z=Enum.KeyCode.Z,
    ["0"]=Enum.KeyCode.Zero, ["1"]=Enum.KeyCode.One, ["2"]=Enum.KeyCode.Two,
    ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four, ["5"]=Enum.KeyCode.Five,
    ["6"]=Enum.KeyCode.Six, ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight,
    ["9"]=Enum.KeyCode.Nine,
    rshift=Enum.KeyCode.RightShift, lshift=Enum.KeyCode.LeftShift,
    rctrl=Enum.KeyCode.RightControl, lctrl=Enum.KeyCode.LeftControl,
}

function KeyUtils.ParseKeyCode(keyStr)
    if not keyStr then return Enum.KeyCode.Unknown end
    if typeof(keyStr) == "EnumItem" then return keyStr end
    return _KeyMap[string.lower(tostring(keyStr))] or Enum.KeyCode.Unknown
end

function KeyUtils.KeyCodeToName(keyCode)
    if typeof(keyCode) == "EnumItem" then
        return keyCode.Name
            :gsub("Control","Ctrl")
            :gsub("^Left","L"):gsub("^Right","R")
            :gsub("Return","Enter")
    end
    return tostring(keyCode)
end

-- Convenience aliases at module level for backwards compat
local ParseKeyCode  = KeyUtils.ParseKeyCode
local KeyCodeToName = KeyUtils.KeyCodeToName

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// UTILITY FUNCTIONS
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

-- Set to true during development to surface property errors in Create()
local DEBUG_MODE = false

local function Create(className, props, children)
    local inst = Instance.new(className)
    local parent = nil
    if props then
        parent = props.Parent
        props.Parent = nil
        if DEBUG_MODE then
            for k, v in pairs(props) do
                if type(k) == "string" then
                    local ok, err = pcall(function() inst[k] = v end)
                    if not ok then warn("[MIDNIGHT] Property '" .. tostring(k) .. "' on " .. className .. ": " .. tostring(err)) end
                end
            end
        else
            for k, v in pairs(props) do
                if type(k) == "string" then
                    inst[k] = v
                end
            end
        end
        props.Parent = parent
    end
    if children then
        for _, child in ipairs(children) do
            if child then child.Parent = inst end
        end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function ApplyCorner(parent, radius)
    if not parent then return nil end
    local r = radius or 4
    if r >= 12 then
        r = 8
    elseif r >= 10 then
        r = 7
    elseif r >= 8 then
        r = 6
    elseif r >= 6 then
        r = 5
    end
    return Create("UICorner", {CornerRadius = UDim.new(0, r), Parent = parent})
end

local function ApplyCircleCorner(parent)
    if not parent then return nil end
    return Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = parent})
end

local function ApplyStroke(parent, color, thickness, transparency)
    if not parent then return nil end
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency == nil and 0.22 or transparency,
        Parent = parent
    })
end

local function ApplyPadding(parent, top, bottom, left, right)
    if not parent then return nil end
    local function normalizePadding(value, defaultValue)
        local n = value
        if n == nil then return defaultValue end
        if n >= 10 then
            return n - 2
        elseif n >= 8 then
            return n - 1
        elseif n == 6 then
            return 5
        end
        return n
    end
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, normalizePadding(top, 4)),
        PaddingBottom = UDim.new(0, normalizePadding(bottom, 4)),
        PaddingLeft   = UDim.new(0, normalizePadding(left, 4)),
        PaddingRight  = UDim.new(0, normalizePadding(right, 4)),
        Parent = parent
    })
end

-- #2 OPT: cancel only overlapping property tweens on the same instance
-- so background/text/scale can animate together without fighting each other
local _ActiveTweens = setmetatable({}, {__mode="k"})  -- weak keys: dead instances are GC'd
local _TweenInfoCache = {}
local function GetTweenInfo(duration, style, dir)
    local d = duration or 0.3
    local s = (style or Enum.EasingStyle.Quad).Value
    local r = (dir   or Enum.EasingDirection.Out).Value
    -- Numeric key: avoid string alloc on every call
    -- d packed to int (ms), s and r are small ints from .Value
    local key = math.floor(d * 1000) * 10000 + s * 100 + r
    local ti = _TweenInfoCache[key]
    if not ti then
        ti = TweenInfo.new(d, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
        _TweenInfoCache[key] = ti
    end
    return ti
end

local function CleanupTweenEntry(inst, tweenEntry)
    local instTweens = _ActiveTweens[inst]
    if not instTweens or not tweenEntry then return end
    for prop in pairs(tweenEntry._Props or {}) do
        if instTweens[prop] == tweenEntry then
            instTweens[prop] = nil
        end
    end
    if next(instTweens) == nil then
        _ActiveTweens[inst] = nil
    end
end

local function TweenObject(inst, props, duration, style, dir)
    if not inst or not inst.Parent then return nil end
    if not props or next(props) == nil then return nil end
    local tweenProps = {}
    local needsTween = false
    for prop, targetValue in pairs(props) do
        local ok, currentValue = pcall(function()
            return inst[prop]
        end)
        if ok and currentValue ~= targetValue then
            tweenProps[prop] = targetValue
            needsTween = true
        end
    end
    if not needsTween then return nil end
    local instTweens = _ActiveTweens[inst]
    if not instTweens then
        instTweens = {}
        _ActiveTweens[inst] = instTweens
    end
    local canceled = {}
    for prop in pairs(tweenProps) do
        local prev = instTweens[prop]
        if prev and prev._Tween and not canceled[prev] then
            canceled[prev] = true
            prev._Tween:Cancel()
            CleanupTweenEntry(inst, prev)
        end
    end
    local t = TweenService:Create(inst, GetTweenInfo(duration, style, dir), tweenProps)
    if t then
        local tweenEntry = {_Tween = t, _Props = {}}
        for prop in pairs(tweenProps) do
            tweenEntry._Props[prop] = true
            instTweens[prop] = tweenEntry
        end
        t:Play()
        if t.Completed.Once then
            t.Completed:Once(function()
                CleanupTweenEntry(inst, tweenEntry)
            end)
        else
            local _c
            _c = t.Completed:Connect(function()
                CleanupTweenEntry(inst, tweenEntry)
                _c:Disconnect()
            end)
        end
        return t
    end
    return nil
end

-- Gradient accent line (dark edges в†’ bright center)
local function CreateAccentLine(parent, radius, color)
    if not parent then return nil end
    local inset = math.min(radius or 6, 6)
    local _pzOk, _pzVal = pcall(function() return parent.ZIndex end)
    local parentZ = (_pzOk and type(_pzVal) == "number") and _pzVal or ZIndex.CONTENT
    local accent = color or Theme.Accent
    local edge = Color3.fromRGB(
        math.floor(Theme.Border.R * 255 * 0.82 + accent.R * 255 * 0.18),
        math.floor(Theme.Border.G * 255 * 0.82 + accent.G * 255 * 0.18),
        math.floor(Theme.Border.B * 255 * 0.82 + accent.B * 255 * 0.18)
    )
    local center = Color3.fromRGB(
        math.floor(Theme.Border.R * 255 * 0.4 + accent.R * 255 * 0.6),
        math.floor(Theme.Border.G * 255 * 0.4 + accent.G * 255 * 0.6),
        math.floor(Theme.Border.B * 255 * 0.4 + accent.B * 255 * 0.6)
    )
    local line = Create("Frame", {
        Size     = UDim2.new(1, -(inset * 2), 0, 1),
        Position = UDim2.new(0, inset, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.34,
        BorderSizePixel  = 0,
        ZIndex = parentZ + 2,
        Parent = parent,
    })
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   edge),
            ColorSequenceKeypoint.new(0.5, center),
            ColorSequenceKeypoint.new(1,   edge),
        }),
        Rotation = 0,
        Parent = line,
    })
    return line
end

-- Separator with gradient fade on edges
local function CreateGradientSeparator(parent, layoutOrder)
    local sf = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder or 0,
        Parent = parent,
    })
    local line = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = sf,
    })
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.2, Theme.Border),
            ColorSequenceKeypoint.new(0.8, Theme.Border),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   1),
            NumberSequenceKeypoint.new(0.15,0),
            NumberSequenceKeypoint.new(0.85,0),
            NumberSequenceKeypoint.new(1,   1),
        }),
        Rotation = 0,
        Parent = line,
    })
    return sf
end

local RegConn -- forward declaration, defined after MIDNIGHT table

local function MakeDraggable(frame, handle, onDragStart)
    if not frame then return end
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos, dragEndConn
    RegConn(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if dragEndConn then
                dragEndConn:Disconnect()
                dragEndConn = nil
            end
            dragging = true; dragStart = input.Position; startPos = frame.Position
            if onDragStart then onDragStart() end
            dragEndConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
                if input.UserInputState == Enum.UserInputState.End and dragEndConn then
                    dragEndConn:Disconnect()
                    dragEndConn = nil
                end
            end)
        end
    end))
    RegConn(handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    RegConn(UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
end

-- Hover: subtle left border + bg change
local function ResolveStateValue(value, frame)
    if type(value) == "function" then
        local ok, resolved = pcall(value, frame)
        if ok then return resolved end
        return nil
    end
    return value
end

local function ApplyHoverEffect(frame, normalBg, hoverBg, withBorder, opts)
    if not frame then return end
    opts = type(opts) == "table" and opts or nil
    local borderLine
    if withBorder then
        borderLine = Create("Frame", {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = frame.ZIndex + 1,
            Parent = frame,
        })
        ApplyCorner(borderLine, 1)
    end
    local function getNormalBg()
        return ResolveStateValue(opts and opts.GetNormalBg or normalBg, frame)
    end
    local function getHoverBg()
        return ResolveStateValue(opts and opts.GetHoverBg or hoverBg, frame)
    end
    local function getBorderTransparency(isHover)
        if opts and opts.GetBorderTransparency then
            local value = opts.GetBorderTransparency(isHover, frame)
            if type(value) == "number" then
                return math.clamp(value, 0, 1)
            end
        end
        return isHover and 0.42 or 1
    end
    local enterDur = opts and opts.EnterDuration or 0.18
    local leaveDur = opts and opts.LeaveDuration or 0.18
    RegConn(frame.MouseEnter:Connect(function()
        local bg = getHoverBg()
        if bg then
            TweenObject(frame, {BackgroundColor3 = bg}, enterDur)
        end
        if borderLine then
            TweenObject(borderLine, {BackgroundTransparency = getBorderTransparency(true)}, enterDur)
        end
        if opts and opts.OnEnter then
            opts.OnEnter(frame, borderLine)
        end
    end))
    RegConn(frame.MouseLeave:Connect(function()
        local bg = getNormalBg()
        if bg then
            TweenObject(frame, {BackgroundColor3 = bg}, leaveDur)
        end
        if borderLine then
            TweenObject(borderLine, {BackgroundTransparency = getBorderTransparency(false)}, leaveDur)
        end
        if opts and opts.OnLeave then
            opts.OnLeave(frame, borderLine)
        end
    end))
end

-- #7 OPT: single helper instead of repeating math.floor(c.R*255) everywhere
local function ColorToRGB(color)
    return math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
end

local function LightenColor(color, amount)
    amount = amount or 28
    local r, g, b = ColorToRGB(color)
    return Color3.fromRGB(math.min(255, r + amount), math.min(255, g + amount), math.min(255, b + amount))
end

local function DarkenColor(color, amount)
    amount = amount or 30
    local r, g, b = ColorToRGB(color)
    return Color3.fromRGB(math.max(0, r - amount), math.max(0, g - amount), math.max(0, b - amount))
end

local function AccentTint(color, factor)
    -- BUG-F FIX: pure multiplication (r * 0.15 = 20) produces near-black because the colors
    -- are already dark (R=139, G=92, B=246 в†’ tint bg R=20). Instead, blend between
    -- WindowBg and the color вЂ” this gives a subtle but still colored background.
    factor = factor or 0.15
    local r, g, b = ColorToRGB(color)
    local bg = Theme and Theme.WindowBg or Color3.fromRGB(18,18,23)
    local br = math.floor(bg.R * 255)
    local bgg = math.floor(bg.G * 255)
    local bb = math.floor(bg.B * 255)
    return Color3.fromRGB(
        math.floor(br + (r - br) * factor),
        math.floor(bgg + (g - bgg) * factor),
        math.floor(bb + (b - bb) * factor)
    )
end

local function TweenMotion(inst, props, motion)
    local spec = Motion[motion] or Motion.Micro
    return TweenObject(inst, props, spec.Duration, spec.Style, spec.Direction)
end

local function _CollectRevealTargets(root, opts)
    local targets = {}
    local function add(inst)
        if not inst then return end
        if opts and opts.Ignore and opts.Ignore(inst) then return end
        if inst ~= root and inst:IsA("GuiObject") and inst.Visible == false then
            return
        end

        local props = {}
        if inst:IsA("GuiObject") then
            if inst.BackgroundTransparency < 1 then
                props.BackgroundTransparency = inst.BackgroundTransparency
            end
        end
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            props.TextTransparency = inst.TextTransparency
        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
            props.ImageTransparency = inst.ImageTransparency
        end
        if inst:IsA("UIStroke") then
            props.Transparency = inst.Transparency
        end

        if next(props) then
            targets[#targets + 1] = { Inst = inst, Props = props }
        end
    end

    add(root)
    for _, inst in ipairs(root:GetDescendants()) do
        add(inst)
    end
    return targets
end

local function _HideRevealTargets(targets)
    for _, entry in ipairs(targets) do
        local inst = entry.Inst
        if inst and inst.Parent then
            if entry.Props.BackgroundTransparency ~= nil then
                inst.BackgroundTransparency = 1
            end
            if entry.Props.TextTransparency ~= nil then
                inst.TextTransparency = 1
            end
            if entry.Props.ImageTransparency ~= nil then
                inst.ImageTransparency = 1
            end
            if entry.Props.Transparency ~= nil then
                inst.Transparency = 1
            end
        end
    end
end

local function AnimateReveal(root, opts)
    if not root or not root.Parent then
        return nil
    end

    opts = opts or {}
    if root:IsA("GuiObject") then
        root.Visible = true
    end
    local targets = _CollectRevealTargets(root, opts)
    _HideRevealTargets(targets)

    local scale = opts.ScaleObject or root:FindFirstChildWhichIsA("UIScale")
    local createdScale = false
    if scale == nil and opts.UseScale ~= false then
        scale = Create("UIScale", {
            Scale = opts.StartScale or 0.96,
            Parent = root,
        })
        createdScale = true
    elseif scale then
        scale.Scale = opts.StartScale or 0.96
    end

    local duration = opts.Duration or Motion.Intro.Duration
    local style = opts.Style or Motion.Intro.Style
    local direction = opts.Direction or Motion.Intro.Direction
    local stagger = opts.Stagger or 0

    if scale then
        TweenObject(scale, {
            Scale = 1,
        }, opts.ScaleDuration or duration + 0.04, opts.ScaleStyle or Enum.EasingStyle.Back, opts.ScaleDirection or Enum.EasingDirection.Out)
    end

    for index, entry in ipairs(targets) do
        local inst = entry.Inst
        local delayTime = stagger * (index - 1)
        task.delay(delayTime, function()
            if inst and inst.Parent and root and root.Parent then
                TweenObject(inst, entry.Props, duration, style, direction)
            end
        end)
    end

    if createdScale then
        return function()
            if scale and scale.Parent then
                pcall(function() scale:Destroy() end)
            end
        end
    end
end

local function ShiftUDim2(pos, dx, dy)
    dx = dx or 0
    dy = dy or 0
    return UDim2.new(pos.X.Scale, pos.X.Offset + dx, pos.Y.Scale, pos.Y.Offset + dy)
end

local function StartSpinnerLoop(spinner, duration)
    if not spinner then
        return function() end
    end

    local active = true
    local spinDuration = math.max(0.5, duration or 0.85)

    task.spawn(function()
        while active and spinner and spinner.Parent do
            local startRotation = spinner.Rotation
            local tween = TweenObject(spinner, {
                Rotation = startRotation + 360,
            }, spinDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
            if tween then
                pcall(function()
                    tween.Completed:Wait()
                end)
            else
                task.wait(spinDuration)
            end
        end
    end)

    return function()
        active = false
    end
end

local function _PlayLoadingIntroImpl(self, config)
    config = config or {}
    local parent = config.Parent or self._ScreenGui
    if not parent then
        return 0
    end

    if self._LoadingOverlayFrame and self._LoadingOverlayFrame.Parent then
        pcall(function()
            self._LoadingOverlayFrame:Destroy()
        end)
    end
    if self._LoadingOverlayStop then
        pcall(self._LoadingOverlayStop)
        self._LoadingOverlayStop = nil
    end

    local titleText = tostring(config.Title or "MIDNIGHT")
    local subtitleText = tostring(config.Subtitle or "Preparing interface...")
    local doneText = tostring(config.DoneText or "Ready")
    local holdTime = math.max(1.45, tonumber(config.HoldTime) or 1.55)
    local outTime = math.max(0.3, tonumber(config.OutTime) or 0.34)

    local overlay = Create("Frame", {
        Name = ("LoadingOverlay_%d_%d"):format(
            math.floor(os.clock() * 1000000),
            math.random(100000, 999999)
        ),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.OverlayBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP,
        Parent = parent,
    })
    self._LoadingOverlayFrame = overlay

    local scrim = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.OverlayBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP,
        Parent = overlay,
    })

    local card = Create("Frame", {
        Size = UDim2.new(0, 340, 0, 192),
        Position = UDim2.new(0.5, -170, 0.5, -96),
        BackgroundColor3 = Theme.UtilityBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 1,
        Parent = overlay,
    })
    ApplyCorner(card, 14)
    local cardStroke = ApplyStroke(card, Theme.BorderSoft, 1, 1)
    local cardScale = Create("UIScale", {Scale = 0.8, Parent = card})
    local topLine = CreateAccentLine(card, 14, Theme.Accent)
    if topLine then
        topLine.BackgroundTransparency = 1
    end

    local spinnerHolder = Create("Frame", {
        Size = UDim2.new(0, 76, 0, 76),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 13),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 2,
        Parent = card,
    })
    local spinnerHalo = Create("Frame", {
        Size = UDim2.new(0, 62, 0, 62),
        Position = UDim2.new(0.5, -31, 0.5, -31),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 1,
        Parent = spinnerHolder,
    })
    ApplyCircleCorner(spinnerHalo)
    local spinnerHaloScale = Create("UIScale", {Scale = 0.78, Parent = spinnerHalo})
    local spinner = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 2,
        Parent = spinnerHolder,
    })

    for index = 1, 12 do
        local angle = math.rad((index - 1) * 30)
        local radius = 22
        local dotTransparency = index == 1 and 0.04 or 0.2
        local dot = Create("Frame", {
            Size = UDim2.new(0, 7, 0, 7),
            Position = UDim2.new(0.5, math.cos(angle) * radius - 3.5, 0.5, math.sin(angle) * radius - 3.5),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = dotTransparency,
            BorderSizePixel = 0,
            ZIndex = ZIndex.TOP + 3,
            Parent = spinner,
        })
        ApplyCorner(dot, 3)
    end

    local spinnerStop = StartSpinnerLoop(spinner, Motion.Loading.Duration)

    local readyBubble = Create("Frame", {
        Size = UDim2.new(0, 76, 0, 76),
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 13),
        BackgroundColor3 = Theme.Success,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = ZIndex.TOP + 2,
        Parent = card,
    })
    ApplyCircleCorner(readyBubble)
    local readyScale = Create("UIScale", {Scale = 0.16, Parent = readyBubble})
    local readyStroke = ApplyStroke(readyBubble, Color3.fromRGB(255, 255, 255), 1, 0.72)
    local readyText = Create("TextLabel", {
        Text = "✓",
        Font = FontBold,
        TextSize = 28,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 0, 8),
        ZIndex = ZIndex.TOP + 3,
        Parent = readyBubble,
    })
    local readyHint = Create("TextLabel", {
        Text = doneText,
        Font = FontBold,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 14),
        Position = UDim2.new(0, 5, 0, 46),
        ZIndex = ZIndex.TOP + 3,
        Parent = readyBubble,
    })

    local titleLabel = Create("TextLabel", {
        Text = titleText,
        Font = FontBold,
        TextSize = 15,
        TextColor3 = Theme.TextPrimary,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, -34, 0, 20),
        Position = UDim2.new(0, 17, 0, 106),
        ZIndex = ZIndex.TOP + 2,
        Parent = card,
    })

    local subtitleLabel = Create("TextLabel", {
        Text = subtitleText,
        Font = FontRegular,
        TextSize = 11,
        TextColor3 = Theme.TextSecondary,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        TextWrapped = false,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, -30, 0, 16),
        Position = UDim2.new(0, 15, 0, 129),
        ZIndex = ZIndex.TOP + 2,
        Parent = card,
    })

    local progressTrack = Create("Frame", {
        Size = UDim2.new(0, 226, 0, 4),
        Position = UDim2.new(0.5, -113, 0, 156),
        BackgroundColor3 = Theme.BorderSoft,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 1,
        Parent = card,
    })
    ApplyCorner(progressTrack, 2)
    local progressFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 2,
        Parent = progressTrack,
    })
    ApplyCorner(progressFill, 2)
    local sweep = Create("Frame", {
        Size = UDim2.new(0, 54, 1, 0),
        Position = UDim2.new(-0.18, 0, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = ZIndex.TOP + 1,
        Parent = card,
    })
    ApplyCorner(sweep, 12)

    local targetCardPos = card.Position
    card.Position = ShiftUDim2(targetCardPos, 0, 12)
    TweenObject(scrim, {BackgroundTransparency = 0.34}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenObject(card, {BackgroundTransparency = 0, Position = targetCardPos}, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenObject(cardStroke, {Transparency = 0.1}, 0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenObject(cardScale, {Scale = 1}, 0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenObject(spinnerHalo, {BackgroundTransparency = 0.9}, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenObject(spinnerHaloScale, {Scale = 1.22}, 0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenObject(topLine, {BackgroundTransparency = 0.66}, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    task.delay(0.05, function()
        if titleLabel and titleLabel.Parent then
            TweenObject(titleLabel, {TextTransparency = 0}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end)
    task.delay(0.09, function()
        if subtitleLabel and subtitleLabel.Parent then
            TweenObject(subtitleLabel, {TextTransparency = 0}, 0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end)
    task.delay(0.12, function()
        if progressTrack and progressTrack.Parent then
            TweenObject(progressTrack, {BackgroundTransparency = 0.6}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        if progressFill and progressFill.Parent then
            TweenObject(progressFill, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0.12}, holdTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end
        if sweep and sweep.Parent then
            TweenObject(sweep, {Position = UDim2.new(1.12, 0, 0, 0), BackgroundTransparency = 1}, 0.82, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
    end)

    local finished = false
    local function finishIntro()
        if finished then
            return
        end
        finished = true

        if spinnerStop then
            spinnerStop()
        end
        if spinner then
            spinner.Visible = false
        end
        if spinnerHalo and spinnerHalo.Parent then
            TweenObject(spinnerHalo, {BackgroundTransparency = 1}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
        if readyBubble and readyBubble.Parent then
            readyBubble.Visible = true
            TweenObject(readyBubble, {BackgroundTransparency = 0.04}, 0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            TweenObject(readyScale, {Scale = 1}, 0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            TweenObject(readyStroke, {Transparency = 0.22}, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            TweenObject(readyText, {TextTransparency = 0}, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            TweenObject(readyHint, {TextTransparency = 0}, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            TweenObject(titleLabel, {TextColor3 = Theme.Success}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            TweenObject(subtitleLabel, {TextColor3 = Theme.TextSecondary}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            TweenObject(progressFill, {BackgroundColor3 = Theme.Success}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end
        TweenObject(progressTrack, {BackgroundColor3 = Theme.Success}, 0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        task.delay(outTime, function()
            if not overlay or not overlay.Parent then
                return
            end
            TweenObject(scrim, {BackgroundTransparency = 1}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(card, {BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            TweenObject(cardStroke, {Transparency = 1}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(cardScale, {Scale = 0.97}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            TweenObject(titleLabel, {TextTransparency = 1}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(subtitleLabel, {TextTransparency = 1}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(progressTrack, {BackgroundTransparency = 1}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(progressFill, {BackgroundTransparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(sweep, {BackgroundTransparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(readyBubble, {BackgroundTransparency = 1}, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(readyText, {TextTransparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenObject(readyHint, {TextTransparency = 1}, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.22, function()
                if overlay and overlay.Parent then
                    pcall(function()
                        overlay:Destroy()
                    end)
                end
                if self._LoadingOverlayFrame == overlay then
                    self._LoadingOverlayFrame = nil
                end
                if self._LoadingOverlayStop == finishIntro then
                    self._LoadingOverlayStop = nil
                end
            end)
        end)
    end

    self._LoadingOverlayStop = finishIntro
    task.delay(holdTime, finishIntro)
    return holdTime + outTime + 0.22
end

local function StylePanelShell(frame, radius, strokeColor, strokeTransparency)
    if not frame then return nil end
    ApplyCorner(frame, radius or CompactStyle.OverlayRadius or 8)
    return ApplyStroke(frame, strokeColor or Theme.Border, 1, strokeTransparency == nil and 0.22 or strokeTransparency)
end

local function StyleUtilityOverlay(frame, accentColor)
    if not frame then return nil, nil end
    frame.BackgroundColor3 = Theme.UtilityBg
    local stroke = StylePanelShell(frame, CompactStyle.OverlayRadius or 8, Theme.BorderSoft, 0.16)
    local tint = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = AccentTint(accentColor or Theme.UtilityAccent, 0.06),
        BackgroundTransparency = 0.42,
        BorderSizePixel = 0,
        ZIndex = frame.ZIndex,
        Parent = frame,
    })
    ApplyCorner(tint, CompactStyle.OverlayRadius or 8)
    return stroke, tint
end

local function StyleQuietHeader(frame, height, zIndex)
    if not frame then return nil, nil end
    local header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, height or CompactStyle.OverlayHeaderHeight or 30),
        BackgroundColor3 = Theme.UtilityHeader,
        BorderSizePixel = 0,
        ZIndex = zIndex or frame.ZIndex + 1,
        Parent = frame,
    })
    ApplyCorner(header, CompactStyle.OverlayRadius or 8)
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, math.min(8, height or CompactStyle.OverlayHeaderHeight or 30)),
        Position = UDim2.new(0, 0, 1, -math.min(8, height or CompactStyle.OverlayHeaderHeight or 30)),
        BackgroundColor3 = Theme.UtilityHeader,
        BorderSizePixel = 0,
        ZIndex = (zIndex or frame.ZIndex + 1),
        Parent = header,
    })
    local divider = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.BorderSoft,
        BorderSizePixel = 0,
        ZIndex = (zIndex or frame.ZIndex + 1) + 1,
        Parent = header,
    })
    return header, divider
end

local function StyleInputField(field, radius, strokeColor)
    if not field then return nil end
    field.BackgroundColor3 = Theme.InputBg
    ApplyCorner(field, radius or CompactStyle.InputRadius or 4)
    return ApplyStroke(field, strokeColor or Theme.BorderSoft, 1, 0.2)
end

local function GetViewportSize()
    local cam = workspace.CurrentCamera
    if cam then
        return cam.ViewportSize
    end
    return Vector2.new(1920, 1080)
end

local function LetterSpace(text)
    -- Adds a space after each character, then strips the trailing space.
    -- Note: in Lua, $ in a pattern anchors to end-of-string, so " $" correctly
    -- matches a trailing space. The outer () ensures only the string is returned.
    return (text:gsub(".", function(c) return c .. " " end):gsub(" $", ""))
end

local function MeasureText(text, font, textSize, bounds)
    local ok, size = pcall(function()
        return TextService:GetTextSize(
            tostring(text or ""),
            textSize or 12,
            font or FontRegular,
            bounds or Vector2.new(9999, 9999)
        )
    end)
    if ok and size then return size end
    return Vector2.new(0, textSize or 12)
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// ICON SYSTEM WITH CACHE + LUCIDE INTEGRATION
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local IconCache     = {}  -- name в†’ url (already resolved)
local IconOverrides = {}
local IconBaseURL   = ""  -- Default empty: use text fallbacks. Call MIDNIGHT:SetIconRepo() with rbxassetid:// URLs or a working host
local IconExt       = ".png"

--// LUCIDE ICON MAP
--// Maps Lucide icon names (https://lucide.dev/icons) to Unicode fallback characters.
--// When no image URL is configured, these characters are rendered as TextLabels.
--// To use actual Lucide PNG images, call MIDNIGHT:UseLucideIcons(assetBaseURL)
--// with a URL pointing to your uploaded icon assets (e.g. rbxassetid://).
--// To use pre-uploaded LucideBlox icons (rbxassetid://), call MIDNIGHT:UseLucideBlox()
local LucideIcons = {
    -- Navigation / UI
    ["chevron-right"]   = "вЂє",
    ["chevron-down"]    = "в€Ё",
    ["chevron-up"]      = "в€§",
    ["chevron-left"]    = "вЂ№",
    ["chevrons-right"]  = "В»",
    ["chevrons-down"]   = "в‡“",
    ["arrow-right"]     = "в†’",
    ["arrow-left"]      = "в†ђ",
    ["arrow-up"]        = "в†‘",
    ["arrow-down"]      = "в†“",
    ["arrow-up-right"]  = "в†—",
    ["move"]            = "вњҐ",
    ["expand"]          = "в¤ў",
    ["shrink"]          = "в¤Ў",
    ["maximize"]        = "в›¶",
    ["minimize"]        = "в”Ђ",
    ["x"]               = "вњ•",
    ["plus"]            = "+",
    ["minus"]           = "в€’",
    ["more-horizontal"] = "в‹Ї",
    ["more-vertical"]   = "в‹®",
    ["menu"]            = "в°",
    ["hash"]            = "#",
    ["search"]          = "вЊ•",
    ["filter"]          = "в—…",
    ["sort-asc"]        = "в†‘",
    ["sort-desc"]       = "в†“",

    -- Media / Objects
    ["moon"]            = "вѕ",
    ["sun"]             = "вЂ",
    ["star"]            = "в…",
    ["heart"]           = "в™Ґ",
    ["eye"]             = "в—‰",
    ["eye-off"]         = "в—€",
    ["lock"]            = "вЉ",
    ["unlock"]          = "вЉ™",
    ["key"]             = "вљ·",
    ["shield"]          = "в—†",
    ["shield-check"]    = "вњ“",
    ["bell"]            = "рџ””",
    ["bookmark"]        = "рџ”–",
    ["flag"]            = "вљ‘",
    ["zap"]             = "вљЎ",
    ["flame"]           = "рџ”Ґ",
    ["sparkles"]        = "вњ¦",
    ["crown"]           = "в™›",
    ["gem"]             = "в—€",
    ["trophy"]          = "рџЏ†",
    ["target"]          = "в—Ћ",
    ["crosshair"]       = "вЉ•",
    ["circle-dot"]      = "вЉ",
    ["scan"]            = "вЊ—",
    ["focus"]           = "в—Ћ",
    ["radar"]           = "в—‰",

    -- Settings / Tools
    ["settings"]        = "вљ™",
    ["sliders"]         = "в‰Ў",
    ["wrench"]          = "рџ”§",
    ["hammer"]          = "рџ”Ё",
    ["tool"]            = "вљ’",
    ["cpu"]             = "в–Ј",
    ["gauge"]           = "вЉ",
    ["activity"]        = "вЃ“",
    ["wifi"]            = "в‹",
    ["radio"]           = "в—‰",
    ["terminal"]        = ">_",
    ["code"]            = "</>",

    -- Status / Feedback
    ["check"]           = "вњ“",
    ["check-circle"]    = "вњ“",
    ["x-circle"]        = "вњ•",
    ["alert-circle"]    = "!",
    ["alert-triangle"]  = "вљ ",
    ["info"]            = "в“",
    ["help-circle"]     = "?",
    ["ban"]             = "вЉ",
    ["alert-octagon"]   = "в¬Ў",

    -- Communication
    ["message-circle"]  = "рџ’¬",
    ["send"]            = "вћ¤",
    ["mail"]            = "вњ‰",
    ["volume-2"]        = "рџ”Љ",
    ["volume-x"]        = "рџ”‡",
    ["mic"]             = "рџЋ¤",
    ["mic-off"]         = "рџљ«",

    -- Users / People
    ["user"]            = "рџ‘¤",
    ["users"]           = "рџ‘Ґ",
    ["user-plus"]       = "+рџ‘¤",
    ["user-minus"]      = "в€’рџ‘¤",
    ["user-check"]      = "вњ“рџ‘¤",

    -- Map / World
    ["map"]             = "рџ—є",
    ["map-pin"]         = "рџ“Ќ",
    ["globe"]           = "рџЊђ",
    ["compass"]         = "рџ§­",
    ["navigation"]      = "вћ¤",

    -- Gaming
    ["swords"]          = "вљ”",
    ["gamepad-2"]       = "рџЋ®",
    ["joystick"]        = "рџ•№",
    ["puzzle"]          = "рџ§©",
    ["dice"]            = "рџЋІ",

    -- Misc
    ["palette"]         = "рџЋЁ",
    ["paintbrush"]      = "рџ–Њ",
    ["image"]           = "рџ–ј",
    ["camera"]          = "рџ“·",
    ["music"]           = "в™«",
    ["clock"]           = "рџ•ђ",
    ["timer"]           = "вЏ±",
    ["calendar"]        = "рџ“…",
    ["file-text"]       = "рџ“„",
    ["clipboard"]       = "рџ“‹",
    ["download"]        = "в†“",
    ["upload"]          = "в†‘",
    ["link"]            = "рџ”—",
    ["external-link"]   = "в†—",
    ["copy"]            = "в§‰",
    ["trash"]           = "рџ—‘",
    ["refresh-cw"]      = "в†»",
    ["rotate-ccw"]      = "в†є",
    ["power"]           = "вЏ»",
    ["log-out"]         = "вЏ»",
    ["home"]            = "вЊ‚",
    ["database"]        = "в›Ѓ",
    ["server"]          = "в—«",
    ["hard-drive"]      = "в–¦",
    ["folder"]          = "рџ“Ѓ",
    ["package"]         = "рџ“¦",
    ["box"]             = "вђ",
    ["layers"]          = "в°",
    ["grid"]            = "в–¦",
    ["layout"]          = "в—§",
    ["sidebar"]         = "в—§",
    ["panel-left"]      = "в—§",
    ["panel-right"]     = "в—§",

    -- Legacy aliases (old names в†’ Lucide names)
    ["chevron_r"]       = "вЂє",
    ["chevron_d"]       = "в€Ё",
    ["warn"]            = "вљ ",
}

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// LUCIDEBLOX ASSET MAP
--// Pre-uploaded Lucide icons as Roblox image assets (rbxassetid://)
--// Source: https://github.com/frappedevs/lucideblox
--// Call MIDNIGHT:UseLucideBlox() to activate these icons automatically
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local LucideBloxAssets = {
    ["activity"]        = "rbxassetid://7733655755",
    ["alert-circle"]    = "rbxassetid://7733658271",
    ["alert-octagon"]   = "rbxassetid://7733658335",
    ["alert-triangle"]  = "rbxassetid://7733658504",
    ["arrow-down"]      = "rbxassetid://7733672933",
    ["arrow-left"]      = "rbxassetid://7733673136",
    ["arrow-right"]     = "rbxassetid://7733673345",
    ["arrow-up"]        = "rbxassetid://7733673717",
    ["arrow-up-right"]  = "rbxassetid://7733673646",
    ["bell"]            = "rbxassetid://7733911828",
    ["bookmark"]        = "rbxassetid://7733692043",
    ["calendar"]        = "rbxassetid://7733919198",
    ["camera"]          = "rbxassetid://7733708692",
    ["check"]           = "rbxassetid://7733715400",
    ["check-circle"]    = "rbxassetid://7733919427",
    ["chevron-down"]    = "rbxassetid://7733717447",
    ["chevron-left"]    = "rbxassetid://7733717651",
    ["chevron-right"]   = "rbxassetid://7733717755",
    ["chevron-up"]      = "rbxassetid://7733919605",
    ["chevrons-down"]   = "rbxassetid://7733720604",
    ["chevrons-right"]  = "rbxassetid://7733919682",
    ["clipboard"]       = "rbxassetid://7733734762",
    ["clock"]           = "rbxassetid://7733734848",
    ["code"]            = "rbxassetid://7733749837",
    ["compass"]         = "rbxassetid://7733924216",
    ["copy"]            = "rbxassetid://7733764083",
    ["cpu"]             = "rbxassetid://7733765045",
    ["crosshair"]       = "rbxassetid://7733765307",
    ["crown"]           = "rbxassetid://7733765398",
    ["database"]        = "rbxassetid://7743866778",
    ["download"]        = "rbxassetid://7733770755",
    ["expand"]          = "rbxassetid://7733771982",
    ["external-link"]   = "rbxassetid://7743866903",
    ["eye"]             = "rbxassetid://7733774602",
    ["eye-off"]         = "rbxassetid://7733774495",
    ["file-text"]       = "rbxassetid://7733789088",
    ["filter"]          = "rbxassetid://7733798407",
    ["flag"]            = "rbxassetid://7733798691",
    ["flame"]           = "rbxassetid://7733798747",
    ["folder"]          = "rbxassetid://7733799185",
    ["gamepad"]         = "rbxassetid://7733799901",
    ["gamepad-2"]       = "rbxassetid://7733799795",
    ["gauge"]           = "rbxassetid://7733799969",
    ["gem"]             = "rbxassetid://7733942651",
    ["globe"]           = "rbxassetid://7733954760",
    ["grid"]            = "rbxassetid://7733955179",
    ["hammer"]          = "rbxassetid://7733955511",
    ["hard-drive"]      = "rbxassetid://7733955793",
    ["hash"]            = "rbxassetid://7733955906",
    ["heart"]           = "rbxassetid://7733956134",
    ["help-circle"]     = "rbxassetid://7733956210",
    ["home"]            = "rbxassetid://7733960981",
    ["image"]           = "rbxassetid://7733964126",
    ["info"]            = "rbxassetid://7733964719",
    ["key"]             = "rbxassetid://7733965118",
    ["layers"]          = "rbxassetid://7743868936",
    ["layout"]          = "rbxassetid://7733970543",
    ["link"]            = "rbxassetid://7733978098",
    ["lock"]            = "rbxassetid://7733992528",
    ["mail"]            = "rbxassetid://7733992732",
    ["map"]             = "rbxassetid://7733992829",
    ["map-pin"]         = "rbxassetid://7733992789",
    ["maximize"]        = "rbxassetid://7733992982",
    ["menu"]            = "rbxassetid://7733993211",
    ["message-circle"]  = "rbxassetid://7733993311",
    ["mic"]             = "rbxassetid://7743869805",
    ["minimize"]        = "rbxassetid://7733997941",
    ["minus"]           = "rbxassetid://7734000129",
    ["moon"]            = "rbxassetid://7743870134",
    ["more-horizontal"] = "rbxassetid://7734006080",
    ["more-vertical"]   = "rbxassetid://7734006187",
    ["move"]            = "rbxassetid://7743870731",
    ["music"]           = "rbxassetid://7734020554",
    ["navigation"]      = "rbxassetid://7734020989",
    ["package"]         = "rbxassetid://7734021469",
    ["palette"]         = "rbxassetid://7734021595",
    ["pen-tool"]        = "rbxassetid://7734022041",
    ["pencil"]          = "rbxassetid://7734022107",
    ["pin"]             = "rbxassetid://8997386648",
    ["plus"]            = "rbxassetid://7734042071",
    ["power"]           = "rbxassetid://7734042493",
    ["radio"]           = "rbxassetid://7743871662",
    ["refresh-cw"]      = "rbxassetid://7734051052",
    ["scan"]            = "rbxassetid://8997386861",
    ["search"]          = "rbxassetid://7734052925",
    ["send"]            = "rbxassetid://7734053039",
    ["server"]          = "rbxassetid://7734053426",
    ["settings"]        = "rbxassetid://7734053495",
    ["shield"]          = "rbxassetid://7734056608",
    ["shield-check"]    = "rbxassetid://7734056411",
    ["shrink"]          = "rbxassetid://7734056971",
    ["sliders"]         = "rbxassetid://7734058803",
    ["sort-asc"]        = "rbxassetid://7734060715",
    ["sort-desc"]       = "rbxassetid://7743871973",
    ["star"]            = "rbxassetid://7734068321",
    ["sun"]             = "rbxassetid://7734068495",
    ["target"]          = "rbxassetid://7743872758",
    ["terminal"]        = "rbxassetid://7743872929",
    ["timer"]           = "rbxassetid://7743873443",
    ["trash"]           = "rbxassetid://7743873871",
    ["unlock"]          = "rbxassetid://7743875263",
    ["upload"]          = "rbxassetid://7743875428",
    ["user"]            = "rbxassetid://7743875962",
    ["users"]           = "rbxassetid://7743876054",
    ["volume-2"]        = "rbxassetid://7743877250",
    ["volume-x"]        = "rbxassetid://7743877381",
    ["wifi"]            = "rbxassetid://7743878148",
    ["wrench"]          = "rbxassetid://7743878358",
    ["x"]               = "rbxassetid://7743878857",
    ["x-circle"]        = "rbxassetid://7743878496",
}

local SafeLucideText = {
    ["activity"] = "AC",
    ["alert-circle"] = "!",
    ["alert-octagon"] = "!",
    ["alert-triangle"] = "!",
    ["arrow-down"] = "v",
    ["arrow-left"] = "<",
    ["arrow-right"] = ">",
    ["arrow-up"] = "^",
    ["arrow-up-right"] = "^>",
    ["bell"] = "B",
    ["bookmark"] = "BM",
    ["calendar"] = "CAL",
    ["camera"] = "CAM",
    ["check"] = "OK",
    ["check-circle"] = "OK",
    ["chevron-down"] = "v",
    ["chevron-left"] = "<",
    ["chevron-right"] = ">",
    ["chevron-up"] = "^",
    ["chevrons-down"] = "vv",
    ["chevrons-right"] = ">>",
    ["clipboard"] = "CL",
    ["clock"] = "TM",
    ["code"] = "</>",
    ["compass"] = "CP",
    ["copy"] = "CP",
    ["cpu"] = "CPU",
    ["crosshair"] = "+",
    ["crown"] = "CR",
    ["database"] = "DB",
    ["download"] = "DN",
    ["expand"] = "+",
    ["external-link"] = "EX",
    ["eye"] = "O",
    ["eye-off"] = "NO",
    ["file-text"] = "TXT",
    ["filter"] = "FL",
    ["flag"] = "FG",
    ["flame"] = "FM",
    ["folder"] = "FD",
    ["gamepad"] = "GP",
    ["gamepad-2"] = "GP",
    ["gauge"] = "GU",
    ["gem"] = "GM",
    ["globe"] = "GL",
    ["grid"] = "GD",
    ["hammer"] = "HM",
    ["hard-drive"] = "HD",
    ["hash"] = "#",
    ["heart"] = "HP",
    ["help-circle"] = "?",
    ["home"] = "HM",
    ["image"] = "IMG",
    ["info"] = "i",
    ["key"] = "K",
    ["layers"] = "LY",
    ["layout"] = "LY",
    ["link"] = "LK",
    ["lock"] = "LK",
    ["mail"] = "ML",
    ["map"] = "MP",
    ["map-pin"] = "PN",
    ["maximize"] = "+",
    ["menu"] = "M",
    ["message-circle"] = "CH",
    ["mic"] = "MC",
    ["minimize"] = "-",
    ["minus"] = "-",
    ["moon"] = "MN",
    ["more-horizontal"] = "...",
    ["more-vertical"] = ":",
    ["move"] = "+",
    ["music"] = "MU",
    ["navigation"] = "NV",
    ["package"] = "PK",
    ["palette"] = "PL",
    ["panel-left"] = "PL",
    ["panel-right"] = "PR",
    ["pen-tool"] = "PT",
    ["pencil"] = "PN",
    ["pin"] = "PN",
    ["plus"] = "+",
    ["power"] = "PW",
    ["radio"] = "RD",
    ["refresh-cw"] = "RF",
    ["rotate-ccw"] = "RT",
    ["scan"] = "SC",
    ["search"] = "?",
    ["send"] = ">",
    ["server"] = "SV",
    ["settings"] = "ST",
    ["shield"] = "SH",
    ["shield-check"] = "OK",
    ["shrink"] = "-",
    ["sidebar"] = "SB",
    ["sliders"] = "=",
    ["sort-asc"] = "^",
    ["sort-desc"] = "v",
    ["star"] = "*",
    ["sun"] = "SN",
    ["target"] = "+",
    ["terminal"] = ">_",
    ["timer"] = "TM",
    ["trash"] = "TR",
    ["unlock"] = "UL",
    ["upload"] = "UP",
    ["user"] = "U",
    ["users"] = "US",
    ["volume-2"] = "VO",
    ["volume-x"] = "VX",
    ["wifi"] = "WF",
    ["wrench"] = "WR",
    ["x"] = "x",
    ["x-circle"] = "X",
    ["chevron_r"] = ">",
    ["chevron_d"] = "v",
    ["warn"] = "!",
}

local function BuildSafeIconFallback(iconName)
    local kebab = tostring(iconName or "")
        :gsub("([a-z])([A-Z])", function(a, b) return a .. "-" .. b:lower() end)
        :lower()
    local direct = SafeLucideText[kebab] or SafeLucideText[iconName]
    if direct and direct ~= "" then
        return direct
    end

    local parts = {}
    for token in kebab:gmatch("[^%-_]+") do
        if token ~= "" then
            parts[#parts + 1] = token
        end
    end
    if #parts == 0 then
        return "?"
    end
    if #parts == 1 then
        return parts[1]:sub(1, math.min(2, #parts[1])):upper()
    end
    local abbrev = ""
    for i = 1, math.min(2, #parts) do
        abbrev = abbrev .. parts[i]:sub(1, 1):upper()
    end
    return abbrev ~= "" and abbrev or "?"
end

local function UseDefaultIconSet()
    if IconBaseURL ~= "" or next(IconOverrides) ~= nil then return end
    for k, v in pairs(LucideBloxAssets) do
        IconOverrides[k] = v
    end
end

local function GetLucideFallback(iconName)
    if not iconName then return nil end
    if SafeLucideText[iconName] then return SafeLucideText[iconName] end
    -- Direct lookup
    if LucideIcons[iconName] then return LucideIcons[iconName] end
    -- Try kebab-case conversion: "chevronRight" в†’ "chevron-right"
    local kebab = iconName:gsub("([a-z])([A-Z])", function(a,b) return a.."-"..b:lower() end):lower()
    if SafeLucideText[kebab] then return SafeLucideText[kebab] end
    if LucideIcons[kebab] then return LucideIcons[kebab] end
    return nil
end

local function GetIconURL(iconName)
    if not iconName then return "" end
    UseDefaultIconSet()
    -- Cache check
    if IconCache[iconName] then return IconCache[iconName] end
    local url = ""
    if IconOverrides[iconName] and IconOverrides[iconName] ~= "" then
        url = IconOverrides[iconName]
    elseif IconBaseURL ~= "" then
        -- Build URL using Lucide kebab-case name convention
        local fileName = iconName:gsub("([a-z])([A-Z])", function(a,b) return a.."-"..b:lower() end):lower()
        url = IconBaseURL .. "/" .. fileName .. IconExt
    end
    IconCache[iconName] = url
    return url
end

local function CreateIconLabel(parent, iconName, size, position, color)
    local img = GetIconURL(iconName)
    if not img or img == "" then return nil end
    return Create("ImageLabel", {
        Name = "Icon_" .. (iconName or "x"),
        Image = img,
        Size  = size     or UDim2.new(0, 16, 0, 16),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ImageColor3 = color or Theme.TextSecondary,
        Parent = parent,
    })
end

local function CreateIconOrText(parent, iconName, fallbackText, size, position, color, font, textSize)
    local icon = CreateIconLabel(parent, iconName, size, position, color)
    if icon then icon.Name = "Icon_" .. (iconName or "x"); return icon end
    -- Auto-resolve Lucide fallback if no explicit fallback provided
    local text = fallbackText
    if (not text or text == "") and iconName then
        text = BuildSafeIconFallback(iconName)
    end
    -- Final fallback: first character of icon name, uppercased
    if (not text or text == "") and iconName and #iconName > 0 then
        text = iconName:sub(1,1):upper()
    end
    return Create("TextLabel", {
        Name = "IconText_" .. (iconName or "x"),
        Text = text or "",
        Font = font or FontBold,
        TextSize = textSize or 12,
        TextColor3 = color or Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = size or UDim2.new(0, 16, 0, 16),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent,
    })
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// MIDNIGHT LIBRARY
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
local MIDNIGHT = {
    Version = "7.1.0",

    _ScreenGui  = nil,
    _Windows    = {},
    _Notifications = {},
    _Keybinds   = {},
    _KeybindsMap = {},  -- [name] = kd, for O(1) lookup instead of ipairs scan
    _Connections = {},   -- ALL connections stored here for Destroy()

    _NotificationPosition = "TopRight",
    _NotificationMaxStack = 5,
    _NotificationStyle = "Compact",
    _MenuKey    = Enum.KeyCode.RightShift,
    _MenuKeyStr = "RShift",
    _MenuOpen   = false,
    _MenuToggleConn = nil,
    _LoadingIntroPlayed = false,
    _LoadingOverlayFrame = nil,
    _LoadingOverlayStop = nil,
    _DensityMode = "Compact",
    _StylePreset = "Midnight",

    _FPS = 0, _FPSCounter = 0, _LastFPSTick = 0,
    _Lagspike = false, _Ping = 0,
    _WatermarkFrame  = nil,
    _WatermarkConfig = {},
    _WatermarkPosition = "TopLeft",
    _WatermarkCustomText = nil,

    _KeybindListFrame   = nil,
    _KeybindListContent = nil,
    _RefreshKeybindList = nil,

    _Initialized = false,
    _ThemeCallbacks = {},

    _ActiveDropdown         = nil,
    _ActiveDropdownCloseConn = nil,
    _ActiveDropdownBtn      = nil,
    _ActiveColorPicker      = nil,
    _ActiveColorPickerCloseConn = nil,
    _KeybindSettingsFrame   = nil,
    _KeybindSettingsBg      = nil,
    _KeybindSettingsCloseConn = nil,
    _KeybindSettingsKeyConn = nil,
    _KeybindSettingsCb      = nil,
    _MenuCloseThreads       = {},
    _KeybindDispatcherInit  = false,
    _SliderDispatcherInit   = false,

    _TargetHUD              = nil,   -- frame
    _TargetHUDVisible       = false,
    _TargetHUDHideThread    = nil,
    _CommandPaletteKey      = Enum.KeyCode.Semicolon,
    _CommandPaletteConn     = nil,

    -- Config system
    _ConfigKey              = nil,   -- current config save key
    _ConfigWidgets          = {},    -- {id -> {get=fn, set=fn, type=str}}
}

function MIDNIGHT:_PlayLoadingIntro(config)
    return _PlayLoadingIntroImpl(self, config)
end

--// Helper: register a connection for cleanup
RegConn = function(conn)
    if conn then
        table.insert(MIDNIGHT._Connections, conn)
    end
    return conn
end

local function SafeDisconnect(conn)
    if conn then
        pcall(function() conn:Disconnect() end)
    end
end

local function SafeCancelThread(th)
    if th ~= nil then
        pcall(function() task.cancel(th) end)
    end
end

local function _RandomGuiName()
    local raw = ""
    pcall(function()
        raw = HttpService:GenerateGUID(false)
    end)
    raw = tostring(raw):gsub("%-", "")
    if #raw < 12 then
        raw = tostring(math.floor((os.clock() * 1000000) % 1000000000000))
    end
    return raw:sub(1, 12)
end

--// FIX #2: Global slider input dispatcher
--// Instead of one InputChanged + one InputEnded per slider (N*2 global UIS connections),
--// we use a single shared dispatcher that routes events to the active dragging slider.
--// Sliders call _SliderSetDrag(onMove, onEnd) on grab and _SliderClearDrag() on release.
local _sliderDragCallback = nil
local _sliderEndCallback  = nil

local function _SliderSetDrag(onMove, onEnd)
    _sliderDragCallback = onMove
    _sliderEndCallback  = onEnd
end
local function _SliderClearDrag()
    _sliderDragCallback = nil
    _sliderEndCallback  = nil
end

local function _InitSliderDispatcher()
    if MIDNIGHT._SliderDispatcherInit then return end
    MIDNIGHT._SliderDispatcherInit = true

    -- One permanent InputChanged for ALL sliders
    RegConn(UserInputService.InputChanged:Connect(function(inp)
        if _sliderDragCallback
        and (inp.UserInputType == Enum.UserInputType.MouseMovement
          or inp.UserInputType == Enum.UserInputType.Touch) then
            _sliderDragCallback(inp)
        end
    end))
    -- One permanent InputEnded for ALL sliders
    RegConn(UserInputService.InputEnded:Connect(function(inp)
        if _sliderEndCallback
        and (inp.UserInputType == Enum.UserInputType.MouseButton1
          or inp.UserInputType == Enum.UserInputType.Touch) then
            _sliderEndCallback()
        end
    end))
end

_InitSliderDispatcher()

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// ICON CONFIGURATION
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:SetIconRepo(baseURL, extension)
    if type(baseURL) ~= "string" or baseURL == "" then return end
    IconBaseURL = baseURL:gsub("/+$", "")
    if extension and type(extension) == "string" then
        IconExt = extension:sub(1,1) == "." and extension or ("." .. extension)
    end
    -- Clear cache so new URLs are resolved
    IconCache = {}
end

function MIDNIGHT:SetIcons(iconTable)
    if type(iconTable) ~= "table" then return end
    UseDefaultIconSet()
    for k, v in pairs(iconTable) do
        if type(k) == "string" and type(v) == "string" then
            IconOverrides[k] = v
            IconCache[k] = v -- update cache immediately
        end
    end
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// LUCIDE ICON CONFIGURATION
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:UseLucideIcons(assetBaseURL, extension)
    -- Set the base URL for Lucide icon images.
    -- assetBaseURL: URL where Lucide PNG icons are hosted
    --   - For Roblox assets: "rbxassetid://FOLDER_ID" (after uploading PNGs to Roblox)
    --   - For CDN: "https://your-cdn.com/lucide" (if executor supports external images)
    -- extension: File extension, default ".png"
    --
    -- Icon names follow Lucide kebab-case convention:
    --   "crosshair", "eye", "settings", "moon", "key", "chevron-right", etc.
    -- Full list: https://lucide.dev/icons
    --
    -- When no image URL is set, Unicode fallback characters from LucideIcons table are used.
    if type(assetBaseURL) == "string" and assetBaseURL ~= "" then
        self:SetIconRepo(assetBaseURL, extension or ".png")
    end
    -- Clear cache so new URLs are resolved on next icon request
    IconCache = {}
end

function MIDNIGHT:GetLucideIcons()
    -- Returns the full LucideIcons map (icon name в†’ fallback character)
    -- Useful for reference or custom modifications
    return LucideIcons
end

function MIDNIGHT:UseLucideBlox()
    -- Activate pre-uploaded Lucide icons from the LucideBlox project.
    -- Source: https://github.com/frappedevs/lucideblox
    -- These are actual Lucide icons uploaded as Roblox image assets (rbxassetid://).
    -- Call this function once after loading the library to enable real icon images
    -- instead of Unicode text fallbacks.
    --
    -- Example:
    --   local MIDNIGHT = loadstring(readfile("midnight.lua"))()
    --   MIDNIGHT:UseLucideBlox()  -- Enable Lucide icon images
    --
    -- Icons not available in LucideBlox will still use Unicode text fallbacks.
    self:SetIcons(LucideBloxAssets)
    -- Clear base URL since we're using direct rbxassetid:// overrides
    IconBaseURL = ""
    IconCache = {}
end

function MIDNIGHT:GetLucideBloxAssets()
    -- Returns the full LucideBloxAssets map (icon name в†’ rbxassetid:// URL)
    -- Useful for reference or to selectively override specific icons
    return LucideBloxAssets
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// THEME
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:SetThemeColor(color)
    if not color then return end
    Theme.Accent       = color
    Theme.AccentHover  = LightenColor(color, 28)
    Theme.AccentDark   = DarkenColor(color, 30)
    Theme.ToggleOn     = color
    Theme.SliderFill   = color
    Theme.TextAccent   = LightenColor(color, 28)
    Theme.AccentSoft   = LightenColor(color, 22)
    Theme.AccentMuted  = DarkenColor(color, 60)
    Theme.AccentFaint  = AccentTint(color, 0.22)
    Theme.UtilityAccent = LightenColor(color, 8)
    local r, g, b = ColorToRGB(color)
    Theme.BorderAccent = Color3.fromRGB(
        math.floor(r * 0.57),
        math.floor(g * 0.43),
        math.floor(b * 0.8)
    )
    Theme.Info = color
    for _, cb in ipairs(self._ThemeCallbacks) do pcall(cb, color) end
end

function MIDNIGHT:SetDensityMode(mode)
    ApplyDensityTokens(mode)
    self._DensityMode = CurrentDensityMode
    return self._DensityMode
end

function MIDNIGHT:GetDensityMode()
    return self._DensityMode or CurrentDensityMode
end

function MIDNIGHT:GetDensityModes()
    return {"Compact", "Readable", "Streamer"}
end

function MIDNIGHT:SetNotificationStyle(style)
    style = tostring(style or "Compact")
    self._NotificationStyle = (style == "Readable" or style == "Classic") and "Readable" or "Compact"
end

function MIDNIGHT:ApplyStylePreset(name)
    local preset = string.lower(tostring(name or "midnight"))
    if preset == "readable" then
        self:SetDensityMode("Readable")
        self:SetNotificationStyle("Readable")
        self._StylePreset = "Readable"
        return self._StylePreset
    elseif preset == "streamer" then
        self:SetDensityMode("Streamer")
        self:SetNotificationStyle("Readable")
        self._StylePreset = "Streamer"
        return self._StylePreset
    end
    self:SetDensityMode("Compact")
    self:SetNotificationStyle("Compact")
    self:SetThemeColor(Color3.fromRGB(96, 190, 255))
    self._StylePreset = "Midnight"
    return self._StylePreset
end

function MIDNIGHT:SetMenuKey(keyStr)
    local newKey = ParseKeyCode(keyStr)
    if newKey == Enum.KeyCode.Unknown then return end
    self._MenuKey    = newKey
    self._MenuKeyStr = KeyCodeToName(newKey)
end

function MIDNIGHT:SetWatermarkText(text)
    self._WatermarkCustomText = text
    self:_UpdateWatermark()
    if self._WatermarkSizeUpdate then
        self._WatermarkSizeUpdate()
    end
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// SCREENGUI
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_InitScreenGui()
    if self._ScreenGui and self._ScreenGui.Parent then return end
    self._ScreenGui = Create("ScreenGui", {
        Name = _RandomGuiName(),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn   = false,
        IgnoreGuiInset = true,
        DisplayOrder   = 999,
    })
    local ok = pcall(function() self._ScreenGui.Parent = CoreGui end)
    if not ok or not self._ScreenGui.Parent then
        pcall(function() self._ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
    end
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// FPS + PING TRACKER
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_InitFPSTracker()
    -- Cache the Stats item once вЂ” avoids repeated indexing inside the hot path
    local _pingStatItem = nil
    pcall(function()
        _pingStatItem = Stats.Network.ServerStatsItem["Data Ping"]
    end)

    -- #1 FIX: accumulate dt instead of calling tick() every frame.
    -- tick() is a C-call but still costs more than a float add; more importantly
    -- this removes the subtraction and branch on every single Heartbeat fire.
    local dtAccum = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        self._FPSCounter = self._FPSCounter + 1
        dtAccum = dtAccum + dt
        if dtAccum >= 1 then
            self._FPS        = self._FPSCounter
            self._Lagspike   = self._FPS < 30
            self._FPSCounter = 0
            dtAccum          = dtAccum - 1  -- keep remainder, don't reset to 0
            if _pingStatItem then
                local ok, v = pcall(_pingStatItem.GetValue, _pingStatItem)
                if ok then self._Ping = math.floor(v) end
            end
            self:_UpdateWatermark()
            self:_UpdateSidebarFooters()
        end
    end)
    RegConn(conn)
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// SIDEBAR FOOTERS (version + fps/ping per window)
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
MIDNIGHT._SidebarFooters = {}

-- #6 OPT: cache the formatted string so we only concat when values actually change
MIDNIGHT._SidebarFooterCache = ""
function MIDNIGHT:_UpdateSidebarFooters()
    if #self._SidebarFooters == 0 then return end
    local str = "v" .. self.Version .. "  |  " .. self._FPS .. " fps  |  " .. self._Ping .. " ms"
    if str == self._SidebarFooterCache then return end
    self._SidebarFooterCache = str
    for _, footer in ipairs(self._SidebarFooters) do
        if footer and footer.Parent then
            footer.Text = str
        end
    end
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// RESET
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:Reset()
    if self._TargetHUD and self._TargetHUD.StopTracking then
        pcall(function() self._TargetHUD:StopTracking() end)
    elseif self._TargetHUD and self._TargetHUD._DisconnectHPConn then
        pcall(self._TargetHUD._DisconnectHPConn)
    end
    if self._lagspikeBlinkStop then
        self._lagspikeBlinkStop()
        self._lagspikeBlinkStop = nil
    end
    if self._TargetHUDHideThread then
        SafeCancelThread(self._TargetHUDHideThread)
        self._TargetHUDHideThread = nil
    end
    if self._LoadingOverlayStop then
        pcall(self._LoadingOverlayStop)
        self._LoadingOverlayStop = nil
    end
    if self._LoadingOverlayFrame then
        pcall(function() self._LoadingOverlayFrame:Destroy() end)
        self._LoadingOverlayFrame = nil
    end
    for _, th in ipairs(self._MenuCloseThreads or {}) do
        SafeCancelThread(th)
    end
    self._MenuCloseThreads = {}
    if self._ActiveDropdownCloseConn then
        SafeDisconnect(self._ActiveDropdownCloseConn)
        self._ActiveDropdownCloseConn = nil
    end
    if self._ActiveColorPickerCloseConn then
        SafeDisconnect(self._ActiveColorPickerCloseConn)
        self._ActiveColorPickerCloseConn = nil
    end
    if self._KeybindSettingsCloseConn then
        SafeDisconnect(self._KeybindSettingsCloseConn)
        self._KeybindSettingsCloseConn = nil
    end
    if self._KeybindSettingsKeyConn then
        SafeDisconnect(self._KeybindSettingsKeyConn)
        self._KeybindSettingsKeyConn = nil
    end
    _SliderClearDrag()
    -- Disconnect all connections
    for _, conn in ipairs(self._Connections) do
        SafeDisconnect(conn)
    end
    self._Connections = {}
    -- Destroy GUI
    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end
    -- Reset state
    self._Windows = {}; self._Notifications = {}; self._Keybinds = {}; self._KeybindsMap = {}
    self._Initialized = false; self._MenuOpen = false
    self._WatermarkFrame = nil; self._WatermarkLabels = nil; self._KeybindListFrame = nil
    self._KeybindListContent = nil; self._RefreshKeybindList = nil
    self._ActiveDropdown = nil; self._ActiveColorPicker = nil
    self._KeybindSettingsFrame = nil; self._KeybindSettingsBg = nil
    self._SidebarFooters = {}
    self._ThemeCallbacks = {}
    self._WatermarkSizeUpdate = nil
    self._LoadingIntroPlayed = false
    self._lagspikeBlinkStop = nil
    self._MenuToggleConn = nil
    self._ActiveDropdownCloseConn = nil
    self._ActiveColorPickerCloseConn = nil
    self._KeybindSettingsCloseConn = nil
    self._KeybindSettingsKeyConn = nil
    self._TargetHUD = nil
    self._TargetHUDHideThread = nil
    self._MenuCloseThreads = {}
    self._KeybindDispatcherInit = false
    self._SliderDispatcherInit = false
    self._NotificationStyle = "Compact"
    self._DensityMode = CurrentDensityMode
    self._StylePreset = "Midnight"
    self._CommandPaletteConn = nil
    self._ConfigWidgets = {}  -- v7.1: reset widget registry (config key is preserved)
    IconCache = {}
    IconOverrides = {}
    IconBaseURL = ""
    UseDefaultIconSet()
    -- Re-initialize
    self:_InitScreenGui()
    _InitSliderDispatcher()
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// POPUP MANAGER
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_CloseAllPopups()
    self:_CloseDropdown()
    self:_CloseColorPicker()
    self:_CloseKeybindSettings()
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// KEYBIND SETTINGS PANEL
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_CloseKeybindSettings()
    if self._KeybindSettingsFrame then
        local f = self._KeybindSettingsFrame
        self._KeybindSettingsFrame = nil
        TweenObject(f, {BackgroundTransparency=1}, 0.1)
        task.delay(0.12, function() pcall(function() f:Destroy() end) end)
    end
    if self._KeybindSettingsBg then
        local bg = self._KeybindSettingsBg
        self._KeybindSettingsBg = nil
        TweenObject(bg, {BackgroundTransparency=1}, 0.1)
        task.delay(0.12, function() pcall(function() bg:Destroy() end) end)
    end
    if self._KeybindSettingsCloseConn then
        self._KeybindSettingsCloseConn:Disconnect()
        self._KeybindSettingsCloseConn = nil
    end
    -- Disconnect key listener if still listening
    if self._KeybindSettingsKeyConn then
        pcall(function() self._KeybindSettingsKeyConn:Disconnect() end)
        self._KeybindSettingsKeyConn = nil
        self._KeybindSettingsListening = nil
    end
    -- Remove theme callback for accentLine (prevents accumulation on repeated opens)
    if self._KeybindSettingsCb then
        for i, v in ipairs(self._ThemeCallbacks) do
            if v == self._KeybindSettingsCb then
                table.remove(self._ThemeCallbacks, i)
                break
            end
        end
        self._KeybindSettingsCb = nil
    end
end

function MIDNIGHT:_ShowKeybindSettings(config)
    self:_CloseAllPopups()
    self:_InitScreenGui()

    local position       = config.Position
    local currentMode    = config.Mode or "Press"
    local currentVisible = config.Visible ~= false
    local onModeChange   = config.OnModeChange
    local onVisibleChange = config.OnVisibleChange
    local onClose        = config.OnClose
    local currentKeyStr  = config.CurrentKeyStr or "None"
    local onKeyChange    = config.OnKeyChange

    local panelW, panelHFinal = 198, 156

    local vpSize = GetViewportSize()
    local posX = position.X + 4
    local posY = position.Y
    if posX + panelW > vpSize.X then posX = position.X - panelW - 4 end
    if posY + panelHFinal > vpSize.Y then posY = vpSize.Y - panelHFinal - 8 end
    if posY < 8 then posY = 8 end

    local bgFill = Create("Frame", {
        Name = _RandomGuiName(),
        Size = UDim2.new(0, panelW, 0, panelHFinal),
        Position = UDim2.new(0, posX, 0, posY),
        BackgroundColor3 = Theme.UtilityBg,
        BorderSizePixel  = 0,
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = ZIndex.POPUP,
        Parent = self._ScreenGui,
    })
    StylePanelShell(bgFill, 8, Theme.BorderSoft, 0.18)

    local pf = Create("Frame", {
        Name = _RandomGuiName(),
        Size = UDim2.new(0, panelW, 0, panelHFinal),
        Position = UDim2.new(0, posX, 0, posY),
        BackgroundColor3 = Theme.UtilityBg,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = ZIndex.POPUP + 1,
        Parent = self._ScreenGui,
    })
    StyleUtilityOverlay(pf, Theme.Accent)
    ApplyPadding(pf, 9, 9, 9, 9)

    -- Title row
    local titleRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.POPUP + 2,
        Parent = pf,
    })
    CreateIconOrText(titleRow, "settings", nil, UDim2.new(0,12,0,12), UDim2.new(0,0,0,4), Theme.UtilityAccent, FontBold, 10)
    Create("TextLabel", {
        Text = "Keybind Settings", Font = FontBold, TextSize = 11,
        TextColor3 = Theme.TextPrimary,
        Size = UDim2.new(1,-38,1,0), Position = UDim2.new(0,18,0,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP + 2, Parent = titleRow,
    })

    local closeX = Create("TextButton", {
        Text = "вњ•", Font = FontBold, TextSize = 11,
        TextColor3 = Theme.TextMuted,
        Size = UDim2.new(0,20,0,16), Position = UDim2.new(1,-22,0,1),
        BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
        ZIndex = ZIndex.TOP, Active = true, Parent = pf,
    })
    ApplyCorner(closeX, 4)
    closeX.Text = "x"
    closeX.TextSize = 10
    closeX.Position = UDim2.new(1,-22,0,2)
    closeX.MouseEnter:Connect(function() TweenObject(closeX, {BackgroundColor3=Theme.CloseHover, TextColor3=Color3.fromRGB(255,255,255)}, 0.12) end)
    closeX.MouseLeave:Connect(function() TweenObject(closeX, {BackgroundColor3=Theme.InputBg, TextColor3=Theme.TextMuted}, 0.12) end)
    closeX.MouseButton1Click:Connect(function()
        self:_CloseKeybindSettings()
        if onClose then onClose() end
    end)

    -- KEY label
    Create("TextLabel", {
        Text = "KEY", Font = FontBold, TextSize = 9,
        TextColor3 = Theme.TextMuted, Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,24),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })

    local keyBtn = Create("TextButton", {
        Text = "[ " .. currentKeyStr .. " ]",
        Font = FontBold, TextSize = 11,
        TextColor3 = Theme.TextAccent,
        Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,36),
        BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
        ZIndex = ZIndex.POPUP+2, Parent = pf,
    })
    ApplyCorner(keyBtn, 4); ApplyStroke(keyBtn, Theme.BorderSoft, 1, 0.22)

    local listening = false
    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "[ ... ]"; keyBtn.TextColor3 = Theme.Warning
        local conn2
        conn2 = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode ~= Enum.KeyCode.Unknown then
                local ns = KeyCodeToName(inp.KeyCode)
                keyBtn.Text = "[ " .. ns .. " ]"; keyBtn.TextColor3 = Theme.TextAccent
                listening = false; conn2:Disconnect()
                if onKeyChange then onKeyChange(inp.KeyCode, ns) end
            end
        end)
        -- Store conn2 reference so _CloseKeybindSettings can disconnect it.
        -- Do NOT add to RegConn: conn2 is either self-disconnecting (on key pick)
        -- or cleaned up via _KeybindSettingsKeyConn in _CloseKeybindSettings.
        -- RegConn here would accumulate a dead ref on every button click.
        self._KeybindSettingsKeyConn = conn2
        self._KeybindSettingsListening = true
        -- Auto-cleanup if panel is destroyed while still listening
        if pf and pf.Destroying then
            pf.Destroying:Connect(function()
                if self._KeybindSettingsKeyConn == conn2 then
                    pcall(function() conn2:Disconnect() end)
                    self._KeybindSettingsKeyConn = nil
                end
                listening = false
            end)
        end
    end)

    -- MODE label
    Create("TextLabel", {
        Text = "MODE", Font = FontBold, TextSize = 9,
        TextColor3 = Theme.TextMuted, Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,68),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })

    local modeRow = Create("Frame", {
        Size = UDim2.new(1,0,0,24), Position = UDim2.new(0,0,0,80),
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })
    local pressBtn = Create("TextButton", {
        Text = "Press", Font = FontBold, TextSize = 10,
        TextColor3 = currentMode=="Press" and Color3.fromRGB(255,255,255) or Theme.TextSecondary,
        Size = UDim2.new(0.5,-2,1,0), Position = UDim2.new(0,0,0,0),
        BackgroundColor3 = currentMode=="Press" and Theme.Accent or Theme.InputBg,
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+3, Parent = modeRow,
    })
    ApplyCorner(pressBtn, 4)
    local holdBtn = Create("TextButton", {
        Text = "Hold", Font = FontBold, TextSize = 10,
        TextColor3 = currentMode=="Hold" and Color3.fromRGB(255,255,255) or Theme.TextSecondary,
        Size = UDim2.new(0.5,-2,1,0), Position = UDim2.new(0.5,2,0,0),
        BackgroundColor3 = currentMode=="Hold" and Theme.Accent or Theme.InputBg,
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+3, Parent = modeRow,
    })
    ApplyCorner(holdBtn, 4)

    pressBtn.MouseButton1Click:Connect(function()
        TweenObject(pressBtn,{BackgroundColor3=Theme.Accent},0.18); TweenObject(pressBtn,{TextColor3=Color3.fromRGB(255,255,255)},0.18)
        TweenObject(holdBtn,{BackgroundColor3=Theme.InputBg},0.18); TweenObject(holdBtn,{TextColor3=Theme.TextSecondary},0.18)
        if onModeChange then onModeChange("Press") end
    end)
    holdBtn.MouseButton1Click:Connect(function()
        TweenObject(holdBtn,{BackgroundColor3=Theme.Accent},0.18); TweenObject(holdBtn,{TextColor3=Color3.fromRGB(255,255,255)},0.18)
        TweenObject(pressBtn,{BackgroundColor3=Theme.InputBg},0.18); TweenObject(pressBtn,{TextColor3=Theme.TextSecondary},0.18)
        if onModeChange then onModeChange("Hold") end
    end)

    -- Show in keybind list
    local visRow = Create("Frame", {
        Size = UDim2.new(1,0,0,24), Position = UDim2.new(0,0,0,112),
        BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
        ZIndex = ZIndex.POPUP+2, Parent = pf,
    })
    ApplyCorner(visRow, 4); ApplyStroke(visRow, Theme.BorderSoft, 1, 0.3); ApplyPadding(visRow,0,0,8,8)
    Create("TextLabel", {
        Text = "Show in Keybind List", Font = Font, TextSize = 10,
        TextColor3 = Theme.TextSecondary, Size = UDim2.new(0.65,0,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+3, Parent = visRow,
    })
    local visToggle = Create("Frame", {
        Size = UDim2.new(0,30,0,14), Position = UDim2.new(1,-34,0.5,-7),
        BackgroundColor3 = currentVisible and Theme.Accent or Theme.ToggleOff,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = ZIndex.POPUP+3, Parent = visRow,
    })
    ApplyCorner(visToggle, 7)
    local visKnob = Create("Frame", {
        Size = UDim2.new(0,10,0,10),
        Position = UDim2.new(0, currentVisible and 18 or 2, 0.5,-5),
        BackgroundColor3 = Color3.fromRGB(230,230,240),
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+4, Parent = visToggle,
    })
    ApplyCorner(visKnob, 5)
    local visState = currentVisible
    -- Use a transparent TextButton overlay so clicks work in all executors
    local visBtn = Create("TextButton", {
        Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Active = true, ZIndex = ZIndex.POPUP+5, Parent = visRow,
    })
    visBtn.MouseButton1Click:Connect(function()
        visState = not visState
        TweenObject(visToggle,{BackgroundColor3=visState and Theme.Accent or Theme.ToggleOff},0.18)
        TweenObject(visKnob,{Position=UDim2.new(0,visState and 18 or 2,0.5,-5)},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
        TweenObject(visKnob,{BackgroundColor3=visState and Color3.fromRGB(230,230,240) or Theme.ToggleKnob},0.18)
        if onVisibleChange then onVisibleChange(visState) end
    end)

    TweenObject(pf,     {BackgroundTransparency=0}, 0.15)
    TweenObject(bgFill, {BackgroundTransparency=0}, 0.15)

    self._KeybindSettingsFrame = pf
    self._KeybindSettingsBg    = bgFill

    if self._KeybindSettingsCloseConn then self._KeybindSettingsCloseConn:Disconnect() end
    task.defer(function()
        self._KeybindSettingsCloseConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if pf and pf.Parent then
                    local mp = UserInputService:GetMouseLocation()
                    local pp, ps = pf.AbsolutePosition, pf.AbsoluteSize
                    -- Use panelHFinal for hit area since pf may still be animating
                    if mp.X>=pp.X and mp.X<=pp.X+panelW and mp.Y>=pp.Y and mp.Y<=pp.Y+panelHFinal then return end
                end
                self:_CloseKeybindSettings()
                if onClose then onClose() end
            end
        end)
    end)
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// DROPDOWN POPUP
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_CloseDropdown()
    if self._ActiveDropdown then
        local dd = self._ActiveDropdown
        self._ActiveDropdown = nil
        local w = dd.AbsoluteSize.X
        TweenObject(dd, {BackgroundTransparency=1}, 0.11, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenObject(dd, {Size=UDim2.new(0,w,0,0)}, 0.11, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.15, function() pcall(function() dd:Destroy() end) end)
    end
    if self._ActiveDropdownBtn then
        TweenObject(self._ActiveDropdownBtn, {BackgroundColor3=Theme.InputBg}, 0.15)
        self._ActiveDropdownBtn = nil
    end
    if self._ActiveDropdownCloseConn then
        self._ActiveDropdownCloseConn:Disconnect()
        self._ActiveDropdownCloseConn = nil
    end
end

function MIDNIGHT:_OpenDropdown(config)
    if self._ActiveDropdown and self._ActiveDropdownBtn == config.DropdownBtn then
        self:_CloseDropdown(); return
    end
    self:_CloseAllPopups()
    self:_InitScreenGui()

    local absPos      = config.ButtonPos
    local absSize     = config.ButtonSize
    local opts        = config.Options
    local currentSel  = config.Current        -- string (single) or table (multi)
    local onSelect    = config.OnSelect
    local dropdownBtn = config.DropdownBtn
    local isMulti     = config.Multi or false

    -- For multiselect: currentSel is a map {value=true} (from AddDropdown's selSet).
    -- BUG-C FIX: was using ipairs() which yields nothing on a map вЂ” initial checked state
    -- was always empty regardless of what the user had already selected.
    local multiSel = {}
    if isMulti and type(currentSel) == "table" then
        -- Support both map {v=true} and array {"v1","v2"} formats for flexibility
        if currentSel[1] ~= nil then
            -- Array format
            for _, v in ipairs(currentSel) do multiSel[v] = true end
        else
            -- Map format (the normal case from AddDropdown)
            for k, v in pairs(currentSel) do if v then multiSel[k] = true end end
        end
    end

    local rowH  = 24
    local listH = #opts * rowH + 8
    if isMulti then listH = listH + 26 end  -- extra room for Apply button

    local vpSize = GetViewportSize()
    local posX = absPos.X
    local posY = absPos.Y + absSize.Y + 2
    if posX + absSize.X > vpSize.X then posX = vpSize.X - absSize.X - 8 end
    if posX < 8 then posX = 8 end
    if posY + listH > vpSize.Y then posY = absPos.Y - listH - 4 end
    if posY < 8 then posY = 8 end

    if dropdownBtn then TweenObject(dropdownBtn,{BackgroundColor3=AccentTint(Theme.Accent,0.12)},0.12) end

    local dd = Create("Frame", {
        Name = _RandomGuiName(),
        Size = UDim2.new(0,absSize.X,0,0),
        Position = UDim2.new(0,posX,0,posY),
        BackgroundColor3 = Theme.DropdownBg,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0, ClipsDescendants = true,
        ZIndex = ZIndex.DROPDOWN,
        Parent = self._ScreenGui,
    })
    ApplyCorner(dd,7); ApplyStroke(dd,Theme.Border,1)
    ApplyPadding(dd,3,3,3,3)
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=dd})

    -- Animate: slide down + fade in from transparent
    dd.BackgroundTransparency = 1
    dd.Position = UDim2.new(0,posX,0,posY-4)
    TweenObject(dd,{Size=UDim2.new(0,absSize.X,0,listH), BackgroundTransparency=0.02, Position=UDim2.new(0,posX,0,posY)},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)

    local optFrames = {}
    for i, opt in ipairs(opts) do
        local isSel = isMulti and multiSel[opt] or opt == currentSel
        local ob = Create("Frame",{
            Size = UDim2.new(1,0,0,rowH-4),
            BackgroundColor3 = isSel and Theme.TabActiveBg or Theme.InputBg,
            BorderSizePixel = 0, LayoutOrder = i, ZIndex = ZIndex.DROPDOWN+1,
            Parent = dd,
        })
        ApplyCorner(ob,4)

        -- Left accent bar for selected state
        local selBar = Create("Frame",{
            Size=UDim2.new(0,1,0.5,0), Position=UDim2.new(0,0,0.25,0),
            BackgroundColor3=Theme.Accent, BorderSizePixel=0,
            BackgroundTransparency = isSel and 0 or 1,
            ZIndex=ZIndex.DROPDOWN+2, Parent=ob,
        })
        ApplyCorner(selBar,1)

        -- Checkmark for multiselect
        local checkEl = nil
        if isMulti then
            local checkBox = Create("Frame",{
                Size=UDim2.new(0,12,0,12),
                Position=UDim2.new(1,-18,0.5,-6),
                BackgroundColor3 = isSel and Theme.Accent or Theme.InputBg,
                BorderSizePixel=0, ZIndex=ZIndex.DROPDOWN+3, Parent=ob,
            })
            ApplyCorner(checkBox,3); ApplyStroke(checkBox,isSel and Theme.Accent or Theme.BorderLight,1)
            if isSel then
                Create("TextLabel",{Text="вњ“",Font=FontBold,TextSize=9,TextColor3=Theme.TextPrimary,
                    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=ZIndex.DROPDOWN+4,Parent=checkBox})
            end
            local existingMark = checkBox:FindFirstChildWhichIsA("TextLabel")
            if existingMark then
                existingMark.Text = "x"
                existingMark.TextXAlignment = Enum.TextXAlignment.Center
                existingMark.TextYAlignment = Enum.TextYAlignment.Center
            end
            checkEl = checkBox
        end

        local lbl = Create("TextLabel",{
            Text = opt, Font = Font, TextSize = 10,
            TextColor3 = isSel and Theme.TextAccent or Theme.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1,isMulti and -28 or -14,1,0),
            Position = UDim2.new(0,8,0,0),
            BackgroundTransparency=1, ZIndex=ZIndex.DROPDOWN+2, Parent=ob,
        })

        local btn = Create("TextButton",{
            Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
            ZIndex=ZIndex.DROPDOWN+4,Parent=ob,
        })

        -- Hover
        btn.MouseEnter:Connect(function()
            if not (isMulti and multiSel[opt] or (not isMulti and opt==currentSel)) then
                TweenObject(ob,{BackgroundColor3=Theme.ItemHoverBg},0.09)
            end
            TweenObject(lbl,{TextColor3=Theme.TextPrimary},0.09)
        end)
        btn.MouseLeave:Connect(function()
            local isCurSel = isMulti and multiSel[opt] or opt==currentSel
            TweenObject(ob,{BackgroundColor3=isCurSel and Theme.TabActiveBg or Theme.InputBg},0.12)
            TweenObject(lbl,{TextColor3=isCurSel and Theme.TextAccent or Theme.TextSecondary},0.12)
        end)

        -- Click with ripple effect
        btn.MouseButton1Click:Connect(function()
            TweenObject(ob,{BackgroundColor3=AccentTint(Theme.Accent,0.16)},0.05)
            task.delay(0.06,function()
                if isMulti then
                    multiSel[opt] = not multiSel[opt]
                    local nowSel = multiSel[opt]
                    TweenObject(ob,{BackgroundColor3=nowSel and Theme.TabActiveBg or Theme.InputBg},0.12)
                    TweenObject(lbl,{TextColor3=nowSel and Theme.TextAccent or Theme.TextSecondary},0.12)
                    TweenObject(selBar,{BackgroundTransparency=nowSel and 0 or 1},0.12)
                    if checkEl then
                        TweenObject(checkEl,{BackgroundColor3=nowSel and Theme.Accent or Theme.InputBg},0.12)
                        -- Rebuild checkmark label
                        for _, ch in ipairs(checkEl:GetChildren()) do
                            if ch:IsA("TextLabel") then ch:Destroy() end
                        end
                        if nowSel then
                            Create("TextLabel",{Text="вњ“",Font=FontBold,TextSize=9,TextColor3=Theme.TextPrimary,
                                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=ZIndex.DROPDOWN+4,Parent=checkEl})
                        end
                    end
                else
                    -- Single select: update all rows
                    currentSel = opt
                    for _, fr in ipairs(optFrames) do
                        local isThis = fr._opt == opt
                        TweenObject(fr._frame,{BackgroundColor3=isThis and Theme.TabActiveBg or Theme.InputBg},0.12)
                        TweenObject(fr._lbl,{TextColor3=isThis and Theme.TextAccent or Theme.TextSecondary},0.12)
                        TweenObject(fr._bar,{BackgroundTransparency=isThis and 0 or 1},0.12)
                    end
                    onSelect(opt)
                    task.delay(0.12, function() self:_CloseDropdown() end)
                end
            end)
        end)

        table.insert(optFrames,{_opt=opt,_frame=ob,_lbl=lbl,_bar=selBar,_check=checkEl})
    end

    -- Multiselect: Apply button
    if isMulti then
        local applyBtn = Create("TextButton",{
            Text="Apply",Font=FontBold,TextSize=10,TextColor3=Theme.TextAccent,
            Size=UDim2.new(1,0,0,20),
            BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
            LayoutOrder=#opts+1, ZIndex=ZIndex.DROPDOWN+2, Parent=dd,
        })
        ApplyCorner(applyBtn,4); ApplyStroke(applyBtn,Theme.Border,1)
        applyBtn.MouseEnter:Connect(function() TweenObject(applyBtn,{BackgroundColor3=Theme.ItemHoverBg},0.12) end)
        applyBtn.MouseLeave:Connect(function() TweenObject(applyBtn,{BackgroundColor3=Theme.InputBg},0.12) end)
        applyBtn.MouseButton1Click:Connect(function()
            local selected = {}
            for v, state in pairs(multiSel) do if state then table.insert(selected,v) end end
            onSelect(selected)
            self:_CloseDropdown()
        end)
    end

    self._ActiveDropdown    = dd
    self._ActiveDropdownBtn = dropdownBtn

    if self._ActiveDropdownCloseConn then self._ActiveDropdownCloseConn:Disconnect() end
    task.defer(function()
        self._ActiveDropdownCloseConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dd and dd.Parent then
                    local mp = UserInputService:GetMouseLocation()
                    local dp, ds = dd.AbsolutePosition, dd.AbsoluteSize
                    if mp.X>=dp.X and mp.X<=dp.X+ds.X and mp.Y>=dp.Y and mp.Y<=dp.Y+ds.Y then return end
                end
                if dropdownBtn and dropdownBtn.Parent then
                    local mp = UserInputService:GetMouseLocation()
                    local bp, bs = dropdownBtn.AbsolutePosition, dropdownBtn.AbsoluteSize
                    if mp.X>=bp.X and mp.X<=bp.X+bs.X and mp.Y>=bp.Y and mp.Y<=bp.Y+bs.Y then
                        self:_CloseDropdown(); return
                    end
                end
                self:_CloseDropdown()
            end
        end)
    end)
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// COLOR PICKER POPUP
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_CloseColorPicker()
    if self._ActiveColorPicker then
        local cp = self._ActiveColorPicker
        self._ActiveColorPicker = nil
        local w = cp.AbsoluteSize.X
        TweenObject(cp,{Size=UDim2.new(0,w,0,0)},0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        task.delay(0.12, function() pcall(function() cp:Destroy() end) end)
    end
    if self._ActiveColorPickerCloseConn then
        self._ActiveColorPickerCloseConn:Disconnect()
        self._ActiveColorPickerCloseConn = nil
    end
end

function MIDNIGHT:_OpenColorPicker(config)
    self:_CloseAllPopups()
    self:_InitScreenGui()

    local absPos  = config.ButtonPos
    local curColor = config.Current or Theme.Accent
    local onColor  = config.OnColor
    local pickerW, pickerH = 152, 146

    local vpSize = GetViewportSize()
    local posX = absPos.X
    local posY = absPos.Y + 26
    if posX + pickerW > vpSize.X then posX = vpSize.X - pickerW - 8 end
    if posX < 8 then posX = 8 end
    if posY + pickerH > vpSize.Y then posY = absPos.Y - pickerH - 4 end
    if posY < 8 then posY = 8 end

    local pf = Create("Frame",{
        Name="ColorPickerPopup",
        Size=UDim2.new(0,pickerW,0,0),
        Position=UDim2.new(0,posX,0,posY),
        BackgroundColor3=Theme.DropdownBg, BorderSizePixel=0,
        ClipsDescendants=true, ZIndex=ZIndex.OVERLAY,
        Parent=self._ScreenGui,
    })
    ApplyCorner(pf,7); ApplyStroke(pf,Theme.Border,1); ApplyPadding(pf,6,6,6,6)
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),Parent=pf})

    local presets = {
        Color3.fromRGB(239,68,68),  Color3.fromRGB(245,158,11), Color3.fromRGB(234,179,8),
        Color3.fromRGB(34,197,94),  Color3.fromRGB(6,182,212),  Color3.fromRGB(96,190,255),
        Color3.fromRGB(56,128,255), Color3.fromRGB(255,255,255),Color3.fromRGB(188,194,204),
        Color3.fromRGB(116,123,136),Color3.fromRGB(66,72,82),   Color3.fromRGB(24,26,30),
    }
    local grid = Create("Frame",{Size=UDim2.new(1,0,0,72),BackgroundTransparency=1,LayoutOrder=1,ZIndex=ZIndex.OVERLAY+1,Parent=pf})
    Create("UIGridLayout",{CellSize=UDim2.new(0,28,0,20),CellPadding=UDim2.new(0,4,0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=grid})
    for i,c in ipairs(presets) do
        local cb = Create("TextButton",{Text="",BackgroundColor3=c,BorderSizePixel=0,LayoutOrder=i,ZIndex=ZIndex.OVERLAY+2,Parent=grid})
        ApplyCorner(cb,3); ApplyStroke(cb,Theme.BorderLight,1)
        cb.MouseButton1Click:Connect(function() onColor(c); self:_CloseColorPicker() end)
    end

    local customRow = Create("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,LayoutOrder=2,ZIndex=ZIndex.OVERLAY+1,Parent=pf})
    Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=customRow})

    local rVal = math.floor(curColor.R*255)
    local gVal = math.floor(curColor.G*255)
    local bVal = math.floor(curColor.B*255)

    local function makeColorInput(label, value, color, layoutOrder)
        local container = Create("Frame",{Size=UDim2.new(0.3,0,1,0),BackgroundTransparency=1,LayoutOrder=layoutOrder,ZIndex=ZIndex.OVERLAY+2,Parent=customRow})
        Create("TextLabel",{Text=label,Font=FontBold,TextSize=8,TextColor3=color,Size=UDim2.new(1,0,0,9),BackgroundTransparency=1,Parent=container})
        local box = Create("TextBox",{Text=tostring(value),Font=Font,TextSize=9,TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,Size=UDim2.new(1,0,0,13),Position=UDim2.new(0,0,0,10),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,ZIndex=ZIndex.OVERLAY+3,Parent=container})
        ApplyCorner(box,3); ApplyStroke(box,Theme.Border,1)
        return box
    end

    local rBox = makeColorInput("R", rVal, Color3.fromRGB(255,80,80),  1)
    local gBox = makeColorInput("G", gVal, Color3.fromRGB(80,255,80),  2)
    local bBox = makeColorInput("B", bVal, Color3.fromRGB(80,80,255),  3)

    local applyBtn = Create("TextButton",{Text="Apply",Font=FontBold,TextSize=9,TextColor3=Theme.TextAccent,Size=UDim2.new(1,0,0,18),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,LayoutOrder=3,ZIndex=ZIndex.OVERLAY+2,Parent=pf})
    ApplyCorner(applyBtn,4); ApplyStroke(applyBtn,Theme.Border,1)
    applyBtn.MouseButton1Click:Connect(function()
        local r = math.clamp(math.floor(tonumber(rBox.Text) or 0),0,255)
        local g = math.clamp(math.floor(tonumber(gBox.Text) or 0),0,255)
        local b = math.clamp(math.floor(tonumber(bBox.Text) or 0),0,255)
        onColor(Color3.fromRGB(r,g,b)); self:_CloseColorPicker()
    end)

    TweenObject(pf,{Size=UDim2.new(0,pickerW,0,pickerH)},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
    self._ActiveColorPicker = pf

    if self._ActiveColorPickerCloseConn then self._ActiveColorPickerCloseConn:Disconnect() end
    task.defer(function()
        self._ActiveColorPickerCloseConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if pf and pf.Parent then
                    local mp = UserInputService:GetMouseLocation()
                    local pp, ps = pf.AbsolutePosition, pf.AbsoluteSize
                    if mp.X>=pp.X and mp.X<=pp.X+ps.X and mp.Y>=pp.Y and mp.Y<=pp.Y+ps.Y then return end
                end
                self:_CloseColorPicker()
            end
        end)
    end)
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// MENU TOGGLE
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:_InitMenuToggle(menuKey, menuKeyStr)
    self._MenuKey    = menuKey
    self._MenuKeyStr = menuKeyStr or KeyCodeToName(menuKey)
    self._MenuOpen   = false
    self._MenuCloseThreads = {}

    if self._MenuToggleConn then self._MenuToggleConn:Disconnect() end
    self._MenuToggleConn = RegConn(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self._MenuKey then
            self._MenuOpen = not self._MenuOpen
            -- Cancel any pending close-delay threads when reopening
            if self._MenuOpen then
                for _, th in ipairs(self._MenuCloseThreads) do
                    SafeCancelThread(th)
                end
                self._MenuCloseThreads = {}
                if self._LoadingOverlayStop then
                    pcall(self._LoadingOverlayStop)
                    self._LoadingOverlayStop = nil
                end
                if self._LoadingOverlayFrame then
                    pcall(function() self._LoadingOverlayFrame:Destroy() end)
                    self._LoadingOverlayFrame = nil
                end
            end
            for _, w in ipairs(self._Windows) do
                if w._Frame then
                    if self._MenuOpen then
                        w._Frame.Visible = true
                        w._Frame.BackgroundTransparency = 1
                        local scale = w._Frame:FindFirstChildWhichIsA("UIScale")
                        if scale then
                            scale.Scale = 0.96
                        end
                        -- BUG-E FIX: respect minimized state вЂ” don't force full height if window was minimized
                        local openW, openH = CompactStyle.WindowWidth, (w._IsMinimized and CompactStyle.CollapsedWindowHeight or CompactStyle.WindowHeight)
                        if w._GetCurrentFrameSize then
                            openW, openH = w:_GetCurrentFrameSize()
                        end
                        w._Frame.Size = UDim2.new(0, openW, 0, openH)
                        -- Smooth fade in
                        TweenObject(w._Frame, {BackgroundTransparency=0}, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                        if scale then
                            TweenObject(scale, {Scale = 1}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        end
                    else
                        local scale = w._Frame:FindFirstChildWhichIsA("UIScale")
                        if scale then
                            TweenObject(scale, {Scale = 0.97}, 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                        end
                        TweenObject(w._Frame, {BackgroundTransparency=1}, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                        local th = task.delay(0.25, function() if not self._MenuOpen then w._Frame.Visible=false end end)
                        table.insert(self._MenuCloseThreads, th)
                    end
                end
            end
        end
    end))
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// WATERMARK
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:CreateWatermark(config)
    config = config or {}
    local name = config.Name or "MIDNIGHT"
    self._WatermarkPosition = config.Position or "TopLeft"
    self._WatermarkConfig = {
        ShowName      = config.ShowName ~= false,
        ShowUser      = config.ShowUser ~= false,
        ShowFPS       = config.ShowFPS  ~= false,
        ShowPing      = config.ShowPing ~= false,
        ShowLagspike  = config.ShowLagspike ~= false,
        ShowTime      = config.ShowTime ~= false,
    }
    self:_InitScreenGui()
    if self._lagspikeBlinkStop then
        self._lagspikeBlinkStop()
        self._lagspikeBlinkStop = nil
    end
    if self._WatermarkFrame then
        pcall(function() self._WatermarkFrame:Destroy() end)
        self._WatermarkFrame = nil
    end
    self._WatermarkLabels = nil
    self._WatermarkSizeUpdate = nil

    local wmFrame = Create("Frame",{
        Name = _RandomGuiName(), Size = UDim2.new(0,500,0,30),
        Position = UDim2.new(0,12,0,6),
        BackgroundColor3 = Theme.UtilityBg,
        BorderSizePixel = 0, ClipsDescendants = true,
        ZIndex = ZIndex.NOTIFY,
        Parent = self._ScreenGui,
    })
    StyleUtilityOverlay(wmFrame, Theme.Accent)

    local content = Create("Frame",{
        Name="Content", Size=UDim2.new(1,-18,1,-6),
        Position=UDim2.new(0,9,0,4),
        BackgroundTransparency=1, Parent=wmFrame,
    })
    Create("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,7),
        VerticalAlignment=Enum.VerticalAlignment.Center,
        Parent=content,
    })

    local lo = 0
    local function addSep()
        lo = lo + 1
        Create("TextLabel",{
            Text="вЂў",Font=FontRegular,TextSize=8,TextColor3=Theme.TextMuted,
            Size=UDim2.new(0,0,0,16),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,LayoutOrder=lo,Parent=content,
        })
    end
    local function addLabel(n, text, font, size, color, visible)
        lo = lo + 1
        return Create("TextLabel",{
            Name=n, Text=text, Font=font or FontRegular, TextSize=size or CompactStyle.UtilityTextSize,
            TextColor3=color or Theme.TextSecondary,
            Size=UDim2.new(0,0,0,16), AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1, LayoutOrder=lo, Visible=visible~=false,
            Parent=content,
        })
    end

    if self._WatermarkConfig.ShowName then
        local mi = CreateIconOrText(content,"moon",nil,UDim2.new(0,13,0,13),UDim2.new(0,0,0,1),Theme.UtilityAccent,FontBold,11)
        lo=lo+1; if mi then mi.LayoutOrder=lo end
        addLabel("NameLabel", name, FontBold,11,Theme.TextPrimary); addSep()
    end
    if self._WatermarkConfig.ShowUser then
        addLabel("UserLabel", LocalPlayer.DisplayName.." @"..LocalPlayer.Name, FontRegular, CompactStyle.UtilityTextSize, Theme.TextSecondary); addSep()
    end
    if self._WatermarkConfig.ShowFPS  then addLabel("FPSLabel","0 fps", FontBold, CompactStyle.UtilityTextSize, Theme.TextPrimary); addSep() end
    if self._WatermarkConfig.ShowPing then addLabel("PingLabel","0 ms", FontRegular, CompactStyle.UtilityTextSize, Theme.TextSecondary); addSep() end
    if self._WatermarkConfig.ShowLagspike then
        addLabel("LagspikeLabel","LAG",FontBold,CompactStyle.UtilityMetaSize + 1,Theme.Error,false)
    end
    if self._WatermarkConfig.ShowTime then addLabel("TimeLabel","", FontRegular, CompactStyle.UtilityTextSize, Theme.TextSecondary) end
    -- Custom text label
    addLabel("CustomLabel","",FontRegular,CompactStyle.UtilityTextSize,Theme.TextSecondary,false)

    self._WatermarkFrame = wmFrame

    local function positionWM()
        if not wmFrame or not wmFrame.Parent then return end
        local pos = self._WatermarkPosition
        if pos == "TopLeft" then
            wmFrame.AnchorPoint = Vector2.new(0,0)
            wmFrame.Position = UDim2.new(0,12,0,6)
        elseif pos == "TopCenter" then
            wmFrame.AnchorPoint = Vector2.new(0.5,0)
            wmFrame.Position = UDim2.new(0.5,0,0,6)
        elseif pos == "TopRight" then
            wmFrame.AnchorPoint = Vector2.new(1,0)
            wmFrame.Position = UDim2.new(1,-12,0,6)
        end
    end

    local function updateSize()
        task.defer(function()
            if not wmFrame or not wmFrame.Parent then return end
            local tw = 18
            local layout = content:FindFirstChildOfClass("UIListLayout")
            if layout and layout.AbsoluteContentSize.X > 0 then
                tw = tw + math.ceil(layout.AbsoluteContentSize.X)
            else
                local lastVisible = 0
                local children = content:GetChildren()
                local widths = {}
                for _, child in ipairs(children) do
                    if (child:IsA("TextLabel") or child:IsA("ImageLabel")) and child.Visible then
                        local cw = child:IsA("TextLabel") and child.TextBounds.X or child.AbsoluteSize.X
                        if cw > 0 then
                            widths[#widths+1] = cw
                            lastVisible = #widths
                        end
                    end
                end
                for i, cw in ipairs(widths) do
                    tw = tw + cw
                    if i < lastVisible then tw = tw + 7 end
                end
            end
            if tw < 84 then tw = 84 end
            wmFrame.Size = UDim2.new(0, tw, 0, 30)
            task.defer(positionWM)
        end)
    end

    -- Initialize FPS tracker early so watermark gets updated even before MakeWindow
    if not self._Initialized then
        self:_InitFPSTracker()
        self._Initialized = true
    end

    -- Update time label once per second via loop instead of every Heartbeat frame
    local timeLabel = content:FindFirstChild("TimeLabel")
    task.spawn(function()
        while self._WatermarkFrame == wmFrame and wmFrame.Parent do
            if timeLabel and timeLabel.Parent then
                timeLabel.Text = os.date("%H:%M:%S")
            end
            task.wait(1)
        end
    end)

    -- Calculate size after render so TextBounds are ready
    self._WatermarkSizeUpdate = updateSize
    task.delay(0.1, updateSize)
    task.delay(0.5, updateSize)

    positionWM()
    -- Apply any pre-set custom watermark text immediately
    self:_UpdateWatermark()
    local wmTargetPos = wmFrame.Position
    wmFrame.Position = ShiftUDim2(wmTargetPos, 0, -10)
    local wmSweep = Create("Frame", {
        Size = UDim2.new(0, 54, 1, 0),
        Position = UDim2.new(-0.2, 0, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = wmFrame.ZIndex + 3,
        Parent = wmFrame,
    })
    ApplyCorner(wmSweep, 12)
    AnimateReveal(wmFrame, {
        Duration = 0.32,
        Stagger = 0.02,
        StartScale = 0.84,
        ScaleDuration = 0.44,
        ScaleStyle = Enum.EasingStyle.Back,
        ScaleDirection = Enum.EasingDirection.Out,
    })
    TweenObject(wmFrame, {
        Position = wmTargetPos,
    }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenObject(wmSweep, {
        Position = UDim2.new(1.08, 0, 0, 0),
        BackgroundTransparency = 1,
    }, 0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    task.delay(1, function()
        if wmSweep and wmSweep.Parent then
            pcall(function()
                wmSweep:Destroy()
            end)
        end
    end)
    return wmFrame
end

function MIDNIGHT:SetWatermarkPosition(pos)
    self._WatermarkPosition = pos
    local wf = self._WatermarkFrame
    if not wf then return end
    -- Determine new AnchorPoint and target Position
    local newAP, newPos
    if pos=="TopLeft" then
        newAP = Vector2.new(0,0)
        newPos = UDim2.new(0,12,0,6)
    elseif pos=="TopCenter" then
        newAP = Vector2.new(0.5,0)
        newPos = UDim2.new(0.5,0,0,6)
    elseif pos=="TopRight" then
        newAP = Vector2.new(1,0)
        newPos = UDim2.new(1,-12,0,6)
    else
        return
    end
    -- Set AnchorPoint and Position atomically to prevent visual jump
    wf.AnchorPoint = newAP
    wf.Position = newPos
end

-- Lagspike blink tween
function MIDNIGHT:_UpdateWatermark()
    local wf = self._WatermarkFrame
    if not wf or not wf.Parent then return end
    local c = wf:FindFirstChild("Content"); if not c then return end
    local needsResize = false

    -- #2 FIX: cache label references on first call so FindFirstChild is not
    -- called every second (these labels are created once and never renamed).
    if not self._WatermarkLabels then
        self._WatermarkLabels = {
            fps  = c:FindFirstChild("FPSLabel"),
            ping = c:FindFirstChild("PingLabel"),
            lag  = c:FindFirstChild("LagspikeLabel"),
            cus  = c:FindFirstChild("CustomLabel"),
        }
    end
    local fpsL  = self._WatermarkLabels.fps
    local pingL = self._WatermarkLabels.ping
    local lagL  = self._WatermarkLabels.lag
    local cusL  = self._WatermarkLabels.cus

    if fpsL  then fpsL.Text  = self._FPS.." fps";  fpsL.TextColor3  = self._Lagspike and Theme.Error or Theme.TextSecondary end
    if pingL then pingL.Text = self._Ping.."ms";   pingL.TextColor3 = self._Ping>150 and Theme.Warning or Theme.TextSecondary end

    if lagL then
        if self._Lagspike and not lagL.Visible then
            lagL.Visible = true
            lagL.TextTransparency = 0
            needsResize = true
            -- #2 FIX: guard against double-start вЂ” only launch blink loop if one
            -- isn't already running (self._lagspikeBlinkStop acts as the flag).
            if not self._lagspikeBlinkStop then
                local blinking = true
                local function doBlink()
                    if not blinking or not lagL.Visible or not lagL.Parent then return end
                    TweenObject(lagL,{TextTransparency=1},0.35)
                    task.delay(0.4, function()
                        if not blinking or not lagL.Visible or not lagL.Parent then return end
                        TweenObject(lagL,{TextTransparency=0},0.35)
                        task.delay(0.4, doBlink)
                    end)
                end
                doBlink()
                self._lagspikeBlinkStop = function() blinking = false end
            end
        elseif not self._Lagspike and lagL.Visible then
            needsResize = true
            if self._lagspikeBlinkStop then self._lagspikeBlinkStop(); self._lagspikeBlinkStop = nil end
            TweenObject(lagL,{TextTransparency=1},0.2)
            task.delay(0.25, function()
                if not self._Lagspike then
                    lagL.Visible=false
                    lagL.TextTransparency=0
                    if self._WatermarkSizeUpdate then self._WatermarkSizeUpdate() end
                end
            end)
        end
    end

    if cusL then
        local showCustom = self._WatermarkCustomText and self._WatermarkCustomText ~= ""
        if showCustom then
            if cusL.Text ~= self._WatermarkCustomText or not cusL.Visible then
                needsResize = true
            end
        elseif cusL.Visible then
            needsResize = true
        end
        if self._WatermarkCustomText and self._WatermarkCustomText ~= "" then
            cusL.Text    = self._WatermarkCustomText
            cusL.Visible = true
        else
            cusL.Visible = false
        end
    end

    if needsResize and self._WatermarkSizeUpdate then
        self._WatermarkSizeUpdate()
    end

    -- #2 FIX: removed task.defer that rewrote AnchorPoint/Position every second.
    -- Position is only meaningful to update when the user calls SetWatermarkPosition()
    -- вЂ” that function already sets it directly. Doing it here caused a redundant
    -- deferred property write on every FPS tick with no visual benefit.
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// TARGET HUD
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--[[
    MIDNIGHT:CreateTargetHUD(config)
    Config: Position вЂ” "BottomLeft" (default) | "BottomRight" | "BottomCenter"
                       "TopLeft" | "TopRight"

    Returns: hud object
      hud:SetTarget(player)   вЂ” show HUD for given Player instance
      hud:ClearTarget()       вЂ” hide HUD immediately
      hud:SetTarget(player, autoClearSeconds)  вЂ” auto-hide after N seconds

    Usage example (silent-aim loop):
        local hud = MIDNIGHT:CreateTargetHUD({ Position = "BottomLeft" })
        -- РєРѕРіРґР° С†РµР»СЊ РІ FOV:
        hud:SetTarget(targetPlayer, 2)
        -- РєРѕРіРґР° РїРѕС‚РµСЂСЏР» С†РµР»СЊ:
        hud:ClearTarget()
]]
function MIDNIGHT:CreateTargetHUD(config)
    config = config or {}
    self:_InitScreenGui()

    local POS   = config.Position or "BottomLeft"
    local W, H  = 264, 72

    -- в”Ђв”Ђ Root frame в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local hf = Create("Frame", {
        Name = _RandomGuiName(),
        Size = UDim2.new(0, W, 0, H),
        BackgroundColor3 = Theme.Surface0,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Visible = false,
        ZIndex = ZIndex.OVERLAY,
        Parent = self._ScreenGui,
    })
    ApplyCorner(hf, 8)
    ApplyStroke(hf, Theme.BorderSoft, 1, 0.16)

    local leftAccent = Create("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = ZIndex.OVERLAY + 1,
        Parent = hf,
    })
    ApplyCorner(leftAccent, 2)

    -- Drop shadow
    Create("ImageLabel", {
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.new(0, -12, 0, -12),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.68,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = ZIndex.OVERLAY - 1,
        Parent = hf,
    })

    -- Accent line top
    local hudAccent = CreateAccentLine(hf, 8)
    if hudAccent then hudAccent.BackgroundTransparency = 0.84 end

    -- в”Ђв”Ђ Avatar frame (left column) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local avatarFrame = Create("Frame", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 10, 0.5, -25),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        ZIndex = ZIndex.OVERLAY + 1,
        Parent = hf,
    })
    ApplyCorner(avatarFrame, 6)
    ApplyStroke(avatarFrame, Theme.BorderSoft, 1, 0.28)

    local avatarImg = Create("ImageLabel", {
        Name = "Avatar",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "",
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = avatarFrame,
    })
    ApplyCorner(avatarImg, 5)

    -- Avatar placeholder icon while loading
    local avatarIcon = CreateIconOrText(avatarFrame, "user", nil,
        UDim2.new(0, 22, 0, 22), UDim2.new(0.5, -11, 0.5, -11),
        Theme.TextMuted, FontBold, 18)

    -- в”Ђв”Ђ Info column (right of avatar) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local infoFrame = Create("Frame", {
        Size = UDim2.new(1, -72, 1, -16),
        Position = UDim2.new(0, 68, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.OVERLAY + 1,
        Parent = hf,
    })

    -- Player name
    local nameLabel = Create("TextLabel", {
        Name = "NameLabel",
        Text = "",
        Font = FontBold,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = infoFrame,
    })

    -- Team badge row
    local teamRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 18),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = infoFrame,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = teamRow,
    })

    -- Team color dot
    local teamDot = Create("Frame", {
        Size = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Theme.TextMuted,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Parent = teamRow,
    })
    ApplyCorner(teamDot, 4)

    local teamLabel = Create("TextLabel", {
        Name = "TeamLabel",
        Text = "No Team",
        Font = FontRegular,
        TextSize = 9,
        TextColor3 = Theme.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = teamRow,
    })

    -- HP bar background
    local hpBg = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 7),
        Position = UDim2.new(0, 0, 0, 38),
        BackgroundColor3 = Theme.SliderTrack,
        BorderSizePixel = 0,
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = infoFrame,
    })
    ApplyCorner(hpBg, 3)

    local hpFill = Create("Frame", {
        Name = "HPFill",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Success,
        BorderSizePixel = 0,
        ZIndex = ZIndex.OVERLAY + 3,
        Parent = hpBg,
    })
    ApplyCorner(hpFill, 3)

    -- HP value label (right of bar)
    local hpLabel = Create("TextLabel", {
        Name = "HPLabel",
        Text = "100 HP",
        Font = FontBold,
        TextSize = 10,
        TextColor3 = Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Right,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.OVERLAY + 2,
        Parent = infoFrame,
    })

    -- в”Ђв”Ђ Positioning helper в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local function positionHUD()
        local vs = GetViewportSize()
        local margin = 14
        if POS == "BottomLeft" then
            hf.AnchorPoint = Vector2.new(0, 1)
            hf.Position = UDim2.new(0, margin, 1, -margin)
        elseif POS == "BottomRight" then
            hf.AnchorPoint = Vector2.new(1, 1)
            hf.Position = UDim2.new(1, -margin, 1, -margin)
        elseif POS == "BottomCenter" then
            hf.AnchorPoint = Vector2.new(0.5, 1)
            hf.Position = UDim2.new(0.5, 0, 1, -margin)
        elseif POS == "TopLeft" then
            hf.AnchorPoint = Vector2.new(0, 0)
            hf.Position = UDim2.new(0, margin, 0, margin + 34)
        elseif POS == "TopRight" then
            hf.AnchorPoint = Vector2.new(1, 0)
            hf.Position = UDim2.new(1, -margin, 0, margin + 34)
        elseif POS == "CenterLow" then
            -- РџРѕ С†РµРЅС‚СЂСѓ СЌРєСЂР°РЅР°, С‡СѓС‚СЊ РЅРёР¶Рµ СЃРµСЂРµРґРёРЅС‹ (~62% РїРѕ РІРµСЂС‚РёРєР°Р»Рё)
            hf.AnchorPoint = Vector2.new(0.5, 0.5)
            hf.Position = UDim2.new(0.5, 0, 0.62, 0)
        end
    end
    positionHUD()

    -- в”Ђв”Ђ HP color helper в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local function hpColor(pct)
        if pct > 0.6 then return Theme.Success
        elseif pct > 0.3 then return Theme.Warning
        else return Theme.Error end
    end

    -- в”Ђв”Ђ Drag handle (С‚РѕРЅРєР°СЏ РїРѕР»РѕСЃРєР° СЃРІРµСЂС…Сѓ HUD) в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local dragHandle = Create("Frame", {
        Name = "DragHandle",
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.OVERLAY + 5,
        Active = true,
        Parent = hf,
    })

    -- РРєРѕРЅРєР° grip (С‚СЂРё С‚РѕС‡РєРё) РїРѕ С†РµРЅС‚СЂСѓ handle
    local gripDots = Create("Frame", {
        Size = UDim2.new(0, 24, 0, 4),
        Position = UDim2.new(0.5, -12, 0.5, -2),
        BackgroundTransparency = 1,
        Parent = dragHandle,
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = gripDots,
    })
    for i = 1, 4 do
        local dot = Create("Frame", {
            Size = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Theme.TextMuted,
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Parent = gripDots,
        })
        ApplyCorner(dot, 2)
    end

    -- Hover: РїРѕРґСЃРІРµС‡РёРІР°РµРј dots РїСЂРё РЅР°РІРµРґРµРЅРёРё РЅР° handle
    dragHandle.MouseEnter:Connect(function()
        for _, dot in ipairs(gripDots:GetChildren()) do
            if dot:IsA("Frame") then
                TweenObject(dot, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0}, 0.12)
            end
        end
    end)
    dragHandle.MouseLeave:Connect(function()
        for _, dot in ipairs(gripDots:GetChildren()) do
            if dot:IsA("Frame") then
                TweenObject(dot, {BackgroundColor3 = Theme.TextMuted, BackgroundTransparency = 0.4}, 0.2)
            end
        end
    end)

    -- в”Ђв”Ђ Drag logic в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local _dragging   = false
    local _dragInput  = nil
    local _dragStart  = nil
    local _startPos   = nil
    local _dragEndConn = nil
    local _isDragged  = false  -- true РїРѕСЃР»Рµ РїРµСЂРІРѕРіРѕ СЂСѓС‡РЅРѕРіРѕ РїРµСЂРµС‚Р°СЃРєРёРІР°РЅРёСЏ

    RegConn(dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if _dragEndConn then
                _dragEndConn:Disconnect()
                _dragEndConn = nil
            end
            _dragging  = true
            _dragStart = input.Position
            _startPos  = hf.Position
            -- РџРѕСЃР»Рµ СЂСѓС‡РЅРѕРіРѕ drag вЂ” РѕС‚РєР»СЋС‡Р°РµРј preset-РїРѕР·РёС†РёРѕРЅРёСЂРѕРІР°РЅРёРµ
            _isDragged = true
            POS = nil
            _dragEndConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    _dragging = false
                    if _dragEndConn then
                        _dragEndConn:Disconnect()
                        _dragEndConn = nil
                    end
                end
            end)
        end
    end))

    RegConn(dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            _dragInput = input
        end
    end))

    RegConn(UserInputService.InputChanged:Connect(function(input)
        if input == _dragInput and _dragging and _startPos then
            local delta = input.Position - _dragStart
            -- РЎР±СЂР°СЃС‹РІР°РµРј AnchorPoint РІ (0,0) С‡С‚РѕР±С‹ offset Р±С‹Р» РїСЂРµРґСЃРєР°Р·СѓРµРј
            hf.AnchorPoint = Vector2.new(0, 0)
            hf.Position = UDim2.new(0, _startPos.X.Offset + _startPos.X.Scale * hf.Parent.AbsoluteSize.X + delta.X,
                                     0, _startPos.Y.Offset + _startPos.Y.Scale * hf.Parent.AbsoluteSize.Y + delta.Y)
        end
    end))

    -- в”Ђв”Ђ HUD object в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
    local hud = { _Frame = hf, _Visible = false, _CurrentPlayer = nil, _CurrentCharacter = nil, _CurrentHumanoid = nil }
    local function disconnectHPConn()
        if hud._HPConn then
            pcall(function() hud._HPConn:Disconnect() end)
            hud._HPConn = nil
        end
        hud._CurrentHumanoid = nil
    end
    hud._DisconnectHPConn = disconnectHPConn

    function hud:SetPosition(pos)
        -- Р•СЃР»Рё РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ СѓР¶Рµ РїРµСЂРµС‚Р°С‰РёР» РІСЂСѓС‡РЅСѓСЋ вЂ” РёРіРЅРѕСЂРёСЂСѓРµРј
        if _isDragged then return end
        POS = pos
        positionHUD()
    end

    function hud:ResetPosition(pos)
        -- РџСЂРёРЅСѓРґРёС‚РµР»СЊРЅС‹Р№ СЃР±СЂРѕСЃ РґР°Р¶Рµ РїРѕСЃР»Рµ СЂСѓС‡РЅРѕРіРѕ drag
        _isDragged = false
        hf.AnchorPoint = Vector2.new(0.5, 0.5)  -- РІРµСЂРЅС‘Рј РЅРµР№С‚СЂР°Р»СЊРЅС‹Р№ anchor
        POS = pos or "CenterLow"
        positionHUD()
    end

    function hud:ClearTarget()
        disconnectHPConn()
        self._CurrentPlayer = nil
        self._CurrentCharacter = nil
        if not self._Visible then return end
        self._Visible = false
        -- Cancel pending auto-hide
        if MIDNIGHT._TargetHUDHideThread then
            if typeof(MIDNIGHT._TargetHUDHideThread) == "thread" then
                pcall(task.cancel, MIDNIGHT._TargetHUDHideThread)
            end
            MIDNIGHT._TargetHUDHideThread = nil
        end
        TweenObject(hf, {BackgroundTransparency = 1}, 0.2)
        task.delay(0.22, function()
            if not self._Visible then hf.Visible = false end
        end)
    end

    function hud:SetTarget(player, autoClearSecs)
        if not player or not player.Parent then return end

        -- Cancel existing auto-hide thread
        if MIDNIGHT._TargetHUDHideThread then
            if typeof(MIDNIGHT._TargetHUDHideThread) == "thread" then
                pcall(task.cancel, MIDNIGHT._TargetHUDHideThread)
            end
            MIDNIGHT._TargetHUDHideThread = nil
        end

        local char = player.Character
        local isSame = (self._CurrentPlayer == player)
        local charChanged = (self._CurrentCharacter ~= char)
        self._CurrentPlayer = player
        self._CurrentCharacter = char
        self._Visible = true

        -- в”Ђв”Ђ Static info (name, team, avatar) вЂ” only update on player change в”Ђв”Ђ
        if not isSame then
            -- в”Ђв”Ђ Name в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            nameLabel.Text = player.DisplayName ~= player.Name
                and (player.DisplayName .. "  @" .. player.Name)
                or player.Name

            -- в”Ђв”Ђ Team в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local teamColor = Theme.TextMuted
            local teamName  = "No Team"
            pcall(function()
                if player.Team then
                    teamName  = player.Team.Name
                    teamColor = player.Team.TeamColor.Color
                end
            end)
            teamDot.BackgroundColor3   = teamColor
            teamLabel.Text             = string.upper(teamName)
            teamLabel.TextColor3       = teamColor
        end

        -- в”Ђв”Ђ HP в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
        local function refreshHP()
            if not hf.Parent then return end
            pcall(function()
                if not char then
                    hpFill.Size = UDim2.new(0, 0, 1, 0)
                    hpLabel.Text = "? HP"
                    hpFill.BackgroundColor3 = Theme.TextMuted
                    hpLabel.TextColor3 = Theme.TextMuted
                    return
                end
                local hum = self._CurrentHumanoid
                if not hum or hum.Parent ~= char then
                    hum = char:FindFirstChildOfClass("Humanoid")
                    self._CurrentHumanoid = hum
                end
                if not hum then return end
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                local fillColor = hpColor(pct)
                local targetSize = UDim2.new(pct, 0, 1, 0)
                if hpFill.Size ~= targetSize then
                    TweenObject(hpFill, {Size = targetSize}, 0.15)
                end
                if hpFill.BackgroundColor3 ~= fillColor then
                    TweenObject(hpFill, {BackgroundColor3 = fillColor}, 0.15)
                end
                local hpText = math.ceil(hum.Health) .. " / " .. math.ceil(hum.MaxHealth) .. " HP"
                if hpLabel.Text ~= hpText then
                    hpLabel.Text = hpText
                end
                if hpLabel.TextColor3 ~= fillColor then
                    hpLabel.TextColor3 = fillColor
                end
            end)
        end

        if not isSame or charChanged or not hf.Visible then
            refreshHP()
        end

        -- в”Ђв”Ђ HealthChanged listener вЂ” disconnect previous, connect new в”Ђв”Ђ
        if not isSame or charChanged then
            -- Disconnect previous HealthChanged listener to prevent accumulation
            disconnectHPConn()
            pcall(function()
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        self._CurrentHumanoid = hum
                        self._HPConn = hum.HealthChanged:Connect(function()
                            if self._CurrentPlayer == player then
                                refreshHP()
                            end
                        end)
                        -- Note: NOT added to RegConn вЂ” managed manually above
                    end
                end
            end)
        end

        -- в”Ђв”Ђ Avatar в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
        if not isSame then
            avatarImg.Image = ""
            if avatarIcon then avatarIcon.Visible = true end
            task.spawn(function()
                local ok, result = pcall(function()
                    return game:GetService("Players"):GetUserThumbnailAsync(
                        player.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size60x60
                    )
                end)
                if ok and result and self._CurrentPlayer == player then
                    avatarImg.Image = result
                    if avatarIcon then avatarIcon.Visible = false end
                end
            end)
        end

        -- в”Ђв”Ђ Show animation в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
        if not hf.Visible then
            hf.Visible = true
            hf.BackgroundTransparency = 1
            TweenObject(hf, {BackgroundTransparency = 0}, 0.25,
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end

        -- в”Ђв”Ђ Auto-hide в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
        if autoClearSecs and autoClearSecs > 0 then
            MIDNIGHT._TargetHUDHideThread = task.delay(autoClearSecs, function()
                MIDNIGHT._TargetHUDHideThread = nil
                self:ClearTarget()
            end)
        end
    end

    self._TargetHUD = hud
    return hud
end


function MIDNIGHT:SetNotificationPosition(pos)
    self._NotificationPosition = pos
    self:_RepositionNotifications()
end

function MIDNIGHT:_GetNotifPos(notif, totalH)
    local pos = self._NotificationPosition
    local vs  = GetViewportSize()
    local margin = 12

    local wmOffset = 0
    if self._WatermarkFrame and self._WatermarkFrame.Parent then
        local wmPos = self._WatermarkPosition
        if (pos:find("Top") and (wmPos=="TopCenter" or wmPos=="TopLeft" or wmPos=="TopRight")) then
            wmOffset = 36
        end
    end

    local width, height = 350, 72
    if type(notif) == "table" then
        if notif._ExpectedWidth and notif._ExpectedWidth > 0 then width = notif._ExpectedWidth end
        if notif._ExpectedHeight and notif._ExpectedHeight > 0 then height = notif._ExpectedHeight end
        if notif._Frame and notif._Frame.Parent then
            local abs = notif._Frame.AbsoluteSize
            if abs.X > 0 then width = abs.X end
            if abs.Y > 0 then height = abs.Y end
        end
    end

    local x, y
    if pos == "TopCenter" then
        x = vs.X/2 - width/2
        y = wmOffset + margin + totalH
    elseif pos == "TopLeft" then
        x = margin
        y = wmOffset + margin + totalH
    elseif pos == "TopRight" then
        x = vs.X - width - margin
        y = wmOffset + margin + totalH
    elseif pos == "BottomLeft" then
        x = margin
        y = vs.Y - margin - height - totalH
    elseif pos == "BottomRight" then
        x = vs.X - width - margin
        y = vs.Y - margin - height - totalH
    elseif pos == "BottomCenter" then
        x = vs.X/2 - width/2
        y = vs.Y - margin - height - totalH
    else
        x = vs.X - width - margin
        y = wmOffset + margin + totalH
    end

    return UDim2.new(0, math.floor(x + 0.5), 0, math.floor(y + 0.5))
end

function MIDNIGHT:_GetNotifSlideOffset(pos)
    if pos=="TopRight" or pos=="BottomRight" then
        return UDim2.new(0,100,0,0)
    elseif pos=="TopLeft" or pos=="BottomLeft" then
        return UDim2.new(0,-100,0,0)
    elseif pos=="BottomCenter" then
        return UDim2.new(0,0,0,36)
    else
        return UDim2.new(0,0,0,-36)
    end
end

function MIDNIGHT:_RepositionNotifications()
    local totalH = 0
    for _, n in ipairs(self._Notifications) do
        if n._Frame and n._Frame.Parent then
            TweenObject(n._Frame,{Position=self:_GetNotifPos(n,totalH)},0.36,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            local absH = n._Frame.AbsoluteSize.Y
            local notifH = absH > 0 and absH or (n._ExpectedHeight or 72)
            totalH = totalH + notifH + (n._Gap or 10)
        end
    end
end

function MIDNIGHT:_RemoveNotificationEntry(target)
    for i, n in ipairs(self._Notifications) do
        if n == target then
            table.remove(self._Notifications, i)
            return true
        end
    end
    return false
end

function MIDNIGHT:_FindDuplicateNotification(title, contentText, notifType)
    for i = #self._Notifications, 1, -1 do
        local n = self._Notifications[i]
        if n
        and not n._Dismissed
        and n._Frame and n._Frame.Parent
        and n._Title == title
        and n._Content == contentText
        and n._Type == notifType then
            return n
        end
    end
    return nil
end

function MIDNIGHT:_TrimNotifications(maxCount)
    local limit = math.max(1, math.floor(tonumber(maxCount) or self._NotificationMaxStack or 5))
    while true do
        local liveCount = 0
        local oldestLive = nil
        for _, n in ipairs(self._Notifications) do
            if n and not n._Dismissed and n._Frame and n._Frame.Parent then
                liveCount = liveCount + 1
                if not oldestLive then oldestLive = n end
            end
        end
        if liveCount < limit or not oldestLive then
            break
        end
        if oldestLive.Dismiss then
            oldestLive:Dismiss(true)
        else
            pcall(function() oldestLive._Frame:Destroy() end)
            self:_RemoveNotificationEntry(oldestLive)
        end
    end
end

function MIDNIGHT:_LegacyNotify(config)
    config = config or {}
    local title       = config.Title    or "MIDNIGHT"
    local contentText = config.Content  or ""
    local notifType   = string.lower(config.Type or "info")
    local duration    = config.Duration or 5

    self:_InitScreenGui()

    local typeColors = {success=Theme.Success,warning=Theme.Warning,error=Theme.Error,info=Theme.Info}
    local typeColor  = typeColors[notifType] or Theme.Info

    local nf = Create("Frame",{
        Name=_RandomGuiName(), Size=UDim2.new(0,350,0,72),
        Position=UDim2.new(0,-380,0,0),
        BackgroundColor3=Theme.WindowBg, BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY, Parent=self._ScreenGui,
    })
    ApplyCorner(nf,10); ApplyStroke(nf,Theme.Border,1)

    -- Left accent bar
    local ab = Create("Frame",{
        Size=UDim2.new(0,3,1,-12), Position=UDim2.new(0,6,0,6),
        BackgroundColor3=typeColor, BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+1, Parent=nf,
    })
    ApplyCorner(ab,2)

    -- Icon circle вЂ” animated scale 0в†’1 with Back easing
    local iconBg = Create("Frame",{
        Size=UDim2.new(0,0,0,0),  -- start at 0 for animation
        Position=UDim2.new(0,18,0.5,-16),
        BackgroundColor3=AccentTint(typeColor,0.15),
        BorderSizePixel=0, ZIndex=ZIndex.NOTIFY+2, Parent=nf,
    })
    ApplyCorner(iconBg,16)

    local iconName = notifType=="success" and "check" or notifType=="error" and "x" or notifType=="warning" and "alert-triangle" or "info"
    local iconFb   = nil  -- Auto-resolved from LucideIcons table
    local iconEl = CreateIconOrText(iconBg, iconName, iconFb,
        UDim2.new(0,16,0,16), UDim2.new(0.5,-8,0.5,-8), typeColor, FontBold, 14)
    if iconEl and iconEl:IsA("TextLabel") then
        iconEl.TextXAlignment = Enum.TextXAlignment.Center
        iconEl.TextYAlignment = Enum.TextYAlignment.Center
    end
    -- Animate icon scale: 0 в†’ 32 with Back easing separately
    task.defer(function()
        TweenObject(iconBg,{Size=UDim2.new(0,32,0,32)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    end)

    -- Title
    Create("TextLabel",{
        Text=title, Font=FontBold, TextSize=13, TextColor3=typeColor,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd,
        Size=UDim2.new(1,-96,0,18), Position=UDim2.new(0,58,0,12),
        BackgroundTransparency=1, ZIndex=ZIndex.NOTIFY+1, Parent=nf,
    })

    -- Content
    Create("TextLabel",{
        Text=contentText, Font=FontRegular, TextSize=11, TextColor3=Theme.TextSecondary,
        TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true,
        TextTruncate=Enum.TextTruncate.AtEnd,
        Size=UDim2.new(1,-96,0,20), Position=UDim2.new(0,58,0,32),
        BackgroundTransparency=1, ZIndex=ZIndex.NOTIFY+1, Parent=nf,
    })

    -- Close button (вњ•)
    local closeNBtn = Create("TextButton",{
        Text="вњ•", Font=FontBold, TextSize=10,
        TextColor3=Theme.TextMuted,
        Size=UDim2.new(0,20,0,20), Position=UDim2.new(1,-28,0,8),
        BackgroundColor3=Theme.InputBg, BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+3, Parent=nf,
    })
    ApplyCorner(closeNBtn,5)
    closeNBtn.MouseEnter:Connect(function() TweenObject(closeNBtn,{BackgroundColor3=Theme.CloseHover,TextColor3=Color3.fromRGB(255,255,255)},0.12) end)
    closeNBtn.MouseLeave:Connect(function() TweenObject(closeNBtn,{BackgroundColor3=Theme.InputBg,TextColor3=Theme.TextMuted},0.12) end)

    -- Progress bar
    local pBg = Create("Frame",{
        Size=UDim2.new(1,-16,0,2), Position=UDim2.new(0,8,1,-8),
        BackgroundColor3=Theme.SliderTrack, BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+1, Parent=nf,
    })
    ApplyCorner(pBg,1)
    local pFill = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=typeColor,BorderSizePixel=0,ZIndex=ZIndex.NOTIFY+2,Parent=pBg})
    ApplyCorner(pFill,1)

    local nd = {_Frame=nf, _StartTime=tick(), _Duration=duration}
    table.insert(self._Notifications, nd)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        if not nf or not nf.Parent then return end
        local slideOut = self:_GetNotifSlideOffset(self._NotificationPosition)
        -- Slide out + fade simultaneously
        TweenObject(nf,{Position=nf.Position+slideOut, BackgroundTransparency=1},0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        task.delay(0.3,function()
            pcall(function() nf:Destroy() end)
            for i, n in ipairs(self._Notifications) do
                if n==nd then table.remove(self._Notifications,i); break end
            end
            self:_RepositionNotifications()
        end)
    end

    closeNBtn.MouseButton1Click:Connect(dismiss)

    local totalH = 0
    for _, n in ipairs(self._Notifications) do
        if n._Frame and n._Frame.Parent then totalH = totalH + n._Frame.AbsoluteSize.Y + 8 end
    end
    -- BUG-G FIX: nf.AbsoluteSize.Y is 0 before the first render pass.
    -- The notification height is fixed at 72px вЂ” use the literal value.
    local nfH = 72
    local finalPos = self:_GetNotifPos(#self._Notifications, totalH - nfH - 8)
    local slideOffset = self:_GetNotifSlideOffset(self._NotificationPosition)
    nf.Position = finalPos + slideOffset
    TweenObject(nf,{Position=finalPos},0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.defer(function() self:_RepositionNotifications() end)

    TweenObject(pFill,{Size=UDim2.new(0,0,1,0)},duration,Enum.EasingStyle.Linear)
    task.delay(duration, dismiss)

    return nd
end

-- Notification v2 override: dynamic card layout + improved motion/stacking.
function MIDNIGHT:Notify(config)
    config = config or {}
    local title       = tostring(config.Title or "MIDNIGHT")
    local contentText = tostring(config.Content or "")
    local notifType   = string.lower(config.Type or "info")
    local duration    = math.max(0.4, tonumber(config.Duration) or 5)
    local styleName   = tostring(config.Style or self._NotificationStyle or (CompactStyle.NotificationCompact and "Compact" or "Readable"))
    local compactMode = string.lower(styleName) ~= "readable"
    local width       = math.clamp(math.floor(tonumber(config.Width) or (compactMode and CompactStyle.NotificationCompactWidth or CompactStyle.NotificationWidth)), 280, 420)

    self:_InitScreenGui()

    local typeColors = {success=Theme.Success,warning=Theme.Warning,error=Theme.Error,info=Theme.Info}
    local typeLabels = {success="SUCCESS",warning="WARNING",error="ERROR",info="INFO"}
    local typeColor  = typeColors[notifType] or Theme.Info
    local iconName   = notifType=="success" and "check" or notifType=="error" and "x" or notifType=="warning" and "alert-triangle" or "info"
    local duplicate = self:_FindDuplicateNotification(title, contentText, notifType)
    if duplicate and duplicate._RefreshDuplicate then
        duplicate:_RefreshDuplicate()
        return duplicate
    end
    self:_TrimNotifications(self._NotificationMaxStack)

    local iconSize  = compactMode and 28 or 32
    local leftPad   = compactMode and 11 or 12
    local topPad    = compactMode and 10 or 12
    local rightPad  = 12
    local closeArea = 28
    local textX     = leftPad + iconSize + (compactMode and 9 or 10)
    local textW     = math.max(120, width - textX - rightPad - closeArea)
    local badgeH    = compactMode and 14 or 16
    local badgeY    = topPad
    local titleY    = badgeY + badgeH + (compactMode and 5 or 6)
    local titleH    = math.max(14, MeasureText(title, FontBold, compactMode and 11 or 12, Vector2.new(textW, 200)).Y)
    local contentH  = contentText ~= "" and math.max(12, MeasureText(contentText, FontRegular, compactMode and 10 or 10, Vector2.new(textW, 600)).Y) or 0
    local contentY  = titleY + titleH + (contentH > 0 and (compactMode and 3 or 4) or 0)
    local contentBottom = contentH > 0 and (contentY + contentH) or (titleY + titleH)
    local cardH = math.max(compactMode and 68 or 72, contentBottom + (compactMode and 16 or 18))

    local nf = Create("Frame",{
        Name=_RandomGuiName(),
        Size=UDim2.new(0,width,0,cardH),
        Position=UDim2.new(0,-width,0,0),
        BackgroundColor3=compactMode and Theme.OverlayBg or Theme.WindowBg,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Active=true,
        ZIndex=ZIndex.NOTIFY,
        Parent=self._ScreenGui,
    })
    ApplyCorner(nf,compactMode and 8 or 10)
    local nfStroke = ApplyStroke(nf, Theme.BorderSoft, 1, 1)
    local nfScale = Create("UIScale",{Scale=compactMode and 0.985 or 0.97,Parent=nf})

    local shadow = Create("ImageLabel",{
        Size=UDim2.new(1,compactMode and 18 or 24,1,compactMode and 18 or 24),Position=UDim2.new(0,compactMode and -9 or -12,0,compactMode and -8 or -10),
        BackgroundTransparency=1,Image="rbxassetid://6015897843",
        ImageColor3=Theme.Shadow,ImageTransparency=1,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),
        ZIndex=ZIndex.NOTIFY-1,Parent=nf,
    })

    local tintOverlay = Create("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=AccentTint(typeColor,compactMode and 0.05 or 0.08),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY,
        Parent=nf,
    })
    ApplyCorner(tintOverlay,compactMode and 8 or 10)

    local accentLine = CreateAccentLine(nf,compactMode and 8 or 10,typeColor)
    if accentLine then accentLine.BackgroundTransparency = 1 end

    local iconBg = Create("Frame",{
        Size=UDim2.new(0,iconSize,0,iconSize),
        Position=UDim2.new(0,leftPad,0,topPad),
        BackgroundColor3=AccentTint(typeColor,compactMode and 0.12 or 0.16),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=nf,
    })
    ApplyCorner(iconBg,compactMode and 7 or 8)
    local iconBgStroke = ApplyStroke(iconBg, typeColor, 1, 1)

    local iconGlow = Create("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=typeColor,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=iconBg,
    })
    ApplyCorner(iconGlow,compactMode and 7 or 8)

    local iconEl = CreateIconOrText(iconBg, iconName, nil,
        UDim2.new(0,compactMode and 14 or 15,0,compactMode and 14 or 15), UDim2.new(0.5,-7,0.5,-7), typeColor, FontBold, compactMode and 13 or 14)
    if iconEl and iconEl:IsA("TextLabel") then
        iconEl.TextXAlignment = Enum.TextXAlignment.Center
        iconEl.TextYAlignment = Enum.TextYAlignment.Center
        iconEl.TextTransparency = 1
    elseif iconEl and iconEl:IsA("ImageLabel") then
        iconEl.ImageTransparency = 1
    end

    local countBadge = Create("Frame",{
        Size=UDim2.new(0,16,0,16),
        Position=UDim2.new(1,3,0,-5),
        AnchorPoint=Vector2.new(1,0),
        BackgroundColor3=typeColor,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Visible=false,
        ZIndex=ZIndex.NOTIFY+4,
        Parent=iconBg,
    })
    ApplyCorner(countBadge,8)
    local countScale = Create("UIScale",{Scale=0.8,Parent=countBadge})
    local countStroke = ApplyStroke(countBadge, Theme.WindowBg, 1, 1)
    if countStroke then countStroke.Transparency = 1 end
    local countLabel = Create("TextLabel",{
        Text="2",
        Font=FontBold,
        TextSize=8,
        TextColor3=Color3.fromRGB(255,255,255),
        TextTransparency=1,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        ZIndex=ZIndex.NOTIFY+5,
        Parent=countBadge,
    })

    local typeBadge = Create("Frame",{
        Size=UDim2.new(0,0,0,badgeH),
        AutomaticSize=Enum.AutomaticSize.X,
        Position=UDim2.new(0,textX,0,badgeY),
        BackgroundColor3=AccentTint(typeColor,compactMode and 0.08 or 0.12),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=nf,
    })
    ApplyCorner(typeBadge,7)
    ApplyPadding(typeBadge,0,0,compactMode and 6 or 7,compactMode and 6 or 7)
    local typeBadgeStroke = ApplyStroke(typeBadge, typeColor, 1, 1)
    local typeLabel = Create("TextLabel",{
        Text=typeLabels[notifType] or string.upper(notifType),
        Font=FontBold,TextSize=compactMode and 7 or 8,TextColor3=typeColor,
        Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundTransparency=1,TextTransparency=1,
        ZIndex=ZIndex.NOTIFY+3,Parent=typeBadge,
    })

    local titleLabel = Create("TextLabel",{
        Text=title,
        Font=FontBold,
        TextSize=compactMode and 11 or 12,
        TextColor3=Theme.TextPrimary,
        TextTransparency=1,
        TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
        Size=UDim2.new(0,textW,0,titleH),
        Position=UDim2.new(0,textX,0,titleY),
        BackgroundTransparency=1,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=nf,
    })

    local contentLabel = Create("TextLabel",{
        Text=contentText,
        Font=FontRegular,
        TextSize=compactMode and 10 or 10,
        TextColor3=Theme.TextSecondary,
        TextTransparency=1,
        TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
        Size=UDim2.new(0,textW,0,contentH),
        Position=UDim2.new(0,textX,0,contentY),
        BackgroundTransparency=1,
        Visible=contentH > 0,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=nf,
    })

    local closeNBtn = Create("TextButton",{
        Text="",
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(1,-rightPad-18,0,topPad),
        BackgroundColor3=Theme.InputBg,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        AutoButtonColor=false,
        ZIndex=ZIndex.NOTIFY+3,
        Parent=nf,
    })
    ApplyCorner(closeNBtn,5)
    local closeStroke = ApplyStroke(closeNBtn, Theme.BorderSoft, 1, 1)
    local closeIcon = CreateIconOrText(closeNBtn,"x",nil,UDim2.new(0,8,0,8),UDim2.new(0.5,-4,0.5,-4),Theme.TextMuted,FontBold,8)
    if closeIcon and closeIcon:IsA("TextLabel") then
        closeIcon.TextXAlignment = Enum.TextXAlignment.Center
        closeIcon.TextYAlignment = Enum.TextYAlignment.Center
        closeIcon.TextTransparency = 1
    elseif closeIcon and closeIcon:IsA("ImageLabel") then
        closeIcon.ImageTransparency = 1
    end

    local pBg = Create("Frame",{
        Size=UDim2.new(1,-24,0,2),
        Position=UDim2.new(0,12,1,-9),
        BackgroundColor3=Theme.SliderTrack,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+1,
        Parent=nf,
    })
    ApplyCorner(pBg,1)
    local pFill = Create("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=typeColor,
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=ZIndex.NOTIFY+2,
        Parent=pBg,
    })
    ApplyCorner(pFill,1)

    local nd = {
        _Frame=nf,
        _StartTime=tick(),
        _Duration=duration,
        _ExpectedWidth=width,
        _ExpectedHeight=cardH,
        _Gap=8,
        _Title=title,
        _Content=contentText,
        _Type=notifType,
        _Count=1,
        _Elapsed=0,
        _Paused=false,
        _Hovered=false,
        _Dismissed=false,
    }
    table.insert(self._Notifications, nd)

    local function getCountText(count)
        return count > 99 and "99+" or tostring(count)
    end

    local function tweenVisualTransparency(inst, value, dur)
        if not inst then return end
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            TweenObject(inst,{TextTransparency=value},dur)
        elseif inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
            TweenObject(inst,{ImageTransparency=value},dur)
        end
    end

    local dismissed = false
    local dismissThread = nil
    local progressTween = nil
    local dismiss

    local function cancelDismissThread()
        SafeCancelThread(dismissThread)
        dismissThread = nil
    end

    local function cancelProgressTween()
        if progressTween then
            progressTween:Cancel()
            progressTween = nil
        end
    end

    local function updateCountBadge(pulse)
        if nd._Count <= 1 then return end
        countLabel.Text = getCountText(nd._Count)
        if not countBadge.Visible then
            countBadge.Visible = true
            countScale.Scale = 0.82
            TweenObject(countBadge,{BackgroundTransparency=0.04},0.14)
            if countStroke then TweenObject(countStroke,{Transparency=0.36},0.14) end
            TweenObject(countScale,{Scale=1},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
            TweenObject(countLabel,{TextTransparency=0},0.16)
        elseif pulse then
            countScale.Scale = 0.9
            TweenObject(countScale,{Scale=1},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
            TweenObject(countBadge,{BackgroundColor3=LightenColor(typeColor,5)},0.08)
            task.delay(0.09,function()
                if not dismissed and countBadge.Parent then
                    TweenObject(countBadge,{BackgroundColor3=typeColor},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                end
            end)
        end
    end

    local function applyNotifHoverState(isHover)
        if nfStroke then
            TweenObject(nfStroke,{
                Color = isHover and LightenColor(typeColor,6) or Theme.Border,
                Transparency = isHover and 0.08 or 0.18
            }, isHover and 0.16 or 0.18)
        end
        TweenObject(tintOverlay,{BackgroundTransparency=isHover and 0.28 or 0.44},isHover and 0.16 or 0.18)
        TweenObject(iconBg,{BackgroundTransparency=isHover and 0.08 or 0.16},isHover and 0.16 or 0.18)
    end

    local function startLifetime(remaining)
        if dismissed then return end
        cancelDismissThread()
        cancelProgressTween()
        remaining = math.max(0.05, remaining or (duration - nd._Elapsed))
        nd._Paused = false
        nd._StartTime = tick()
        progressTween = TweenObject(pFill,{Size=UDim2.new(0,0,1,0)},remaining,Enum.EasingStyle.Linear)
        dismissThread = task.delay(remaining, function()
            dismiss(false)
        end)
    end

    local function pauseLifetime()
        if dismissed or nd._Paused then return end
        if nd._StartTime then
            nd._Elapsed = math.min(duration, nd._Elapsed + math.max(0, tick() - nd._StartTime))
        end
        nd._StartTime = nil
        nd._Paused = true
        cancelDismissThread()
        cancelProgressTween()
    end

    local function resetLifetime()
        nd._Elapsed = 0
        nd._StartTime = nil
        cancelDismissThread()
        cancelProgressTween()
        pFill.Size = UDim2.new(1,0,1,0)
        pFill.BackgroundTransparency = 0
        if nd._Hovered then
            nd._Paused = true
        else
            startLifetime(duration)
        end
    end

    local function pulseNotification()
        if dismissed then return end
        TweenObject(nfScale,{Scale=compactMode and 1.008 or 1.015},0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        task.delay(0.13,function()
            if not dismissed and nfScale.Parent then
                TweenObject(nfScale,{Scale=1},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
            end
        end)
        if shadow then
            TweenObject(shadow,{ImageTransparency=compactMode and 0.82 or 0.72},0.1)
            task.delay(0.13,function()
                if not dismissed and shadow.Parent then
                    TweenObject(shadow,{ImageTransparency=compactMode and 0.9 or 0.8},0.18)
                end
            end)
        end
        applyNotifHoverState(true)
        task.delay(0.15,function()
            if not dismissed and nf.Parent then
                applyNotifHoverState(nd._Hovered)
            end
        end)
    end

    local function finalizeDismiss()
        cancelDismissThread()
        cancelProgressTween()
        nd._Dismissed = true
        pcall(function() nf:Destroy() end)
        self:_RemoveNotificationEntry(nd)
        self:_RepositionNotifications()
    end

    dismiss = function(immediate)
        if dismissed then return end
        dismissed = true
        nd._Dismissed = true
        cancelDismissThread()
        cancelProgressTween()
        if immediate or not nf or not nf.Parent then
            finalizeDismiss()
            return
        end
        local slideOut = self:_GetNotifSlideOffset(self._NotificationPosition)
        TweenObject(nf,{Position=nf.Position+slideOut, BackgroundTransparency=1},compactMode and 0.2 or 0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        TweenObject(nfScale,{Scale=compactMode and 0.985 or 0.96},0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        if nfStroke then TweenObject(nfStroke,{Transparency=1},0.2) end
        if shadow then TweenObject(shadow,{ImageTransparency=1},0.2) end
        if tintOverlay then TweenObject(tintOverlay,{BackgroundTransparency=1},0.2) end
        if accentLine then TweenObject(accentLine,{BackgroundTransparency=1},0.18) end
        TweenObject(iconBg,{BackgroundTransparency=1},0.2)
        if iconBgStroke then TweenObject(iconBgStroke,{Transparency=1},0.18) end
        if iconGlow then TweenObject(iconGlow,{BackgroundTransparency=1},0.18) end
        TweenObject(typeBadge,{BackgroundTransparency=1},0.18)
        if typeBadgeStroke then TweenObject(typeBadgeStroke,{Transparency=1},0.18) end
        TweenObject(closeNBtn,{BackgroundTransparency=1},0.18)
        if closeStroke then TweenObject(closeStroke,{Transparency=1},0.18) end
        TweenObject(pBg,{BackgroundTransparency=1},0.18)
        TweenObject(pFill,{BackgroundTransparency=1},0.18)
        TweenObject(countBadge,{BackgroundTransparency=1},0.16)
        if countStroke then TweenObject(countStroke,{Transparency=1},0.16) end
        tweenVisualTransparency(iconEl, 1, 0.16)
        tweenVisualTransparency(closeIcon, 1, 0.16)
        tweenVisualTransparency(typeLabel, 1, 0.16)
        TweenObject(countLabel,{TextTransparency=1},0.16)
        TweenObject(titleLabel,{TextTransparency=1},0.16)
        TweenObject(contentLabel,{TextTransparency=1},0.16)
        task.delay(0.26,function()
            finalizeDismiss()
        end)
    end

    function nd:Dismiss(immediate)
        dismiss(immediate)
    end

    function nd:_RefreshDuplicate()
        if dismissed then return end
        self._Count = self._Count + 1
        updateCountBadge(true)
        pulseNotification()
        resetLifetime()
    end

    closeNBtn.MouseButton1Click:Connect(dismiss)

    closeNBtn.MouseEnter:Connect(function()
        TweenObject(closeNBtn,{BackgroundTransparency=0.04,BackgroundColor3=AccentTint(typeColor,compactMode and 0.14 or 0.18)},0.12)
        if closeStroke then TweenObject(closeStroke,{Color=typeColor,Transparency=0.18},0.12) end
        if closeIcon then
            if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextColor3=typeColor},0.12)
            elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageColor3=typeColor},0.12) end
        end
    end)
    closeNBtn.MouseLeave:Connect(function()
        TweenObject(closeNBtn,{BackgroundTransparency=compactMode and 0.34 or 0.28,BackgroundColor3=Theme.InputBg},0.14)
        if closeStroke then TweenObject(closeStroke,{Color=Theme.BorderSoft,Transparency=0.4},0.14) end
        if closeIcon then
            if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextColor3=Theme.TextMuted},0.14)
            elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageColor3=Theme.TextMuted},0.14) end
        end
    end)

    nf.MouseEnter:Connect(function()
        nd._Hovered = true
        pauseLifetime()
        applyNotifHoverState(true)
    end)
    nf.MouseLeave:Connect(function()
        nd._Hovered = false
        applyNotifHoverState(false)
        startLifetime(math.max(0.05, duration - nd._Elapsed))
    end)

    local totalH = 0
    for _, n in ipairs(self._Notifications) do
        if n._Frame and n._Frame.Parent then
            local absH = n._Frame.AbsoluteSize.Y
            totalH = totalH + (absH > 0 and absH or (n._ExpectedHeight or 72)) + (n._Gap or 10)
        end
    end
    local finalPos = self:_GetNotifPos(nd, totalH - cardH - nd._Gap)
    local slideOffset = self:_GetNotifSlideOffset(self._NotificationPosition)
    nf.Position = finalPos + slideOffset
    task.defer(function()
        TweenMotion(nf,{Position=finalPos,BackgroundTransparency=0},"OverlayIn")
        TweenMotion(nfScale,{Scale=1},"OverlayIn")
        if nfStroke then TweenObject(nfStroke,{Transparency=compactMode and 0.26 or 0.18},0.18) end
        if shadow then TweenObject(shadow,{ImageTransparency=compactMode and 0.9 or 0.8},0.22) end
        if tintOverlay then TweenObject(tintOverlay,{BackgroundTransparency=compactMode and 0.62 or 0.44},0.18) end
        if accentLine then TweenObject(accentLine,{BackgroundTransparency=compactMode and 0.86 or 0.68},0.18) end
        TweenObject(iconBg,{BackgroundTransparency=compactMode and 0.26 or 0.16},0.18)
        if iconBgStroke then TweenObject(iconBgStroke,{Transparency=compactMode and 0.74 or 0.62},0.18) end
        if iconGlow then TweenObject(iconGlow,{BackgroundTransparency=compactMode and 0.98 or 0.94},0.18) end
        TweenObject(typeBadge,{BackgroundTransparency=compactMode and 0.24 or 0.14},0.18)
        if typeBadgeStroke then TweenObject(typeBadgeStroke,{Transparency=compactMode and 0.8 or 0.68},0.18) end
        TweenObject(closeNBtn,{BackgroundTransparency=compactMode and 0.34 or 0.28},0.18)
        if closeStroke then TweenObject(closeStroke,{Transparency=0.4},0.18) end
        TweenObject(pBg,{BackgroundTransparency=compactMode and 0.38 or 0.26},0.18)
        TweenObject(pFill,{BackgroundTransparency=0},0.2)
        tweenVisualTransparency(iconEl, 0, 0.16)
        tweenVisualTransparency(closeIcon, 0, 0.16)
        tweenVisualTransparency(typeLabel, 0, 0.16)
        TweenObject(titleLabel,{TextTransparency=0},0.16)
        TweenObject(contentLabel,{TextTransparency=0},0.16)
        resetLifetime()
    end)

    return nd
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// KEYBIND LIST
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:CreateKeybindList(config)
    config = config or {}
    local title = config.Name or "Keybinds"
    self:_InitScreenGui()

    local kf = Create("Frame",{
        Name=_RandomGuiName(), Size=UDim2.new(0,196,0,30),
        Position=UDim2.new(1,-204,0,38),
        BackgroundColor3=Theme.UtilityBg, BorderSizePixel=0,
        ZIndex=ZIndex.WINDOW, Parent=self._ScreenGui,
    })
    StyleUtilityOverlay(kf, Theme.Accent)

    local tb2 = StyleQuietHeader(kf, 28, ZIndex.WINDOW + 1)
    local tc2 = Create("Frame",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Parent=tb2})
    local icon = CreateIconOrText(tc2,"key",nil,UDim2.new(0,12,0,12),UDim2.new(0,0,0.5,-6),Theme.UtilityAccent,FontBold,10)
    if icon and icon:IsA("TextLabel") then
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.TextYAlignment = Enum.TextYAlignment.Center
    end
    Create("TextLabel",{
        Text=title,Font=FontBold,TextSize=CompactStyle.UtilityTextSize,
        TextColor3=Theme.TextPrimary,Size=UDim2.new(1,-18,1,0),Position=UDim2.new(0,18,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
        BackgroundTransparency=1,Parent=tc2
    })

    local lc2 = Create("Frame",{Size=UDim2.new(1,0,1,-30),Position=UDim2.new(0,0,0,30),BackgroundTransparency=1,Parent=kf})
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=lc2})
    ApplyPadding(lc2,4,4,6,6)

    self._KeybindListFrame   = kf
    self._KeybindListContent = lc2
    MakeDraggable(kf, tb2)

    local function refresh()
        if not lc2 or not lc2.Parent then return end
        for _, ch in ipairs(lc2:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        local count = 0
        for _, kb in ipairs(self._Keybinds) do
            if kb._Visible then
                count = count + 1
                local isActive = kb._Active
                local row = Create("Frame",{
                    Size=UDim2.new(1,0,0,22),
                    BackgroundColor3 = isActive and AccentTint(Theme.Accent,0.12) or Theme.Surface2,
                    BackgroundTransparency = isActive and 0.02 or 0.08,
                    BorderSizePixel=0, LayoutOrder=count, Parent=lc2,
                })
                ApplyCorner(row,5)
                ApplyStroke(row, isActive and Theme.AccentMuted or Theme.BorderSoft, 1, isActive and 0.2 or 0.42)
                if isActive then
                    Create("Frame",{Size=UDim2.new(0,2,0.66,0),Position=UDim2.new(0,0,0.17,0),BackgroundColor3=Theme.UtilityAccent,BorderSizePixel=0,Parent=row})
                end
                Create("TextLabel",{
                    Text=kb._Name, Font=FontRegular, TextSize=CompactStyle.UtilityTextSize,
                    TextColor3=isActive and Theme.TextPrimary or Theme.TextSecondary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(0.58,0,1,0), Position=UDim2.new(0,isActive and 8 or 6,0,0),
                    BackgroundTransparency=1, Parent=row,
                })
                local badge = Create("Frame",{
                    Size=UDim2.new(0,0,0,16),
                    AutomaticSize=Enum.AutomaticSize.X,
                    Position=UDim2.new(1,-5,0.5,-8),
                    AnchorPoint=Vector2.new(1,0),
                    BackgroundColor3=isActive and AccentTint(Theme.Accent,0.16) or Theme.InputBg,
                    BorderSizePixel=0, Parent=row,
                })
                ApplyCorner(badge,4)
                ApplyStroke(badge, isActive and Theme.AccentMuted or Theme.BorderSoft, 1, isActive and 0.28 or 0.48)
                ApplyPadding(badge,0,0,4,4)
                Create("TextLabel",{
                    Text=KeyCodeToName(kb._Key), Font=FontBold, TextSize=CompactStyle.UtilityMetaSize,
                    TextColor3=isActive and Theme.TextAccent or Theme.TextMuted,
                    Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
                    BackgroundTransparency=1, Parent=badge,
                })
            end
        end
        kf.Size = UDim2.new(0,196,0,30+count*24+10)
    end

    self._RefreshKeybindList = refresh
    refresh()
    AnimateReveal(kf, {
        Duration = 0.28,
        Stagger = 0.02,
        StartScale = 0.9,
    })
    return kf
end

-- #1 OPT: Single shared dispatcher instead of N*2 global UIS connections
function MIDNIGHT:_InitKeybindDispatcher()
    if self._KeybindDispatcherInit then return end
    self._KeybindDispatcherInit = true

    RegConn(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        local needRefresh = false
        for _, kd in ipairs(self._Keybinds) do
            if kd._Key == kc then
                if kd._Mode == "Hold" then
                    kd._Active = true
                    if kd._Callback then kd._Callback(true) end
                elseif kd._Mode == "Press" then
                    kd._Active = not kd._Active
                    if kd._Callback then kd._Callback(kd._Active) end
                end
                needRefresh = true
            end
        end
        if needRefresh and self._RefreshKeybindList then
            self._RefreshKeybindList()
        end
    end))

    RegConn(UserInputService.InputEnded:Connect(function(input)
        local kc = input.KeyCode
        local needRefresh = false
        for _, kd in ipairs(self._Keybinds) do
            if kd._Key == kc and kd._Mode == "Hold" and kd._Active then
                kd._Active = false
                if kd._Callback then kd._Callback(false) end
                needRefresh = true
            end
        end
        if needRefresh and self._RefreshKeybindList then
            self._RefreshKeybindList()
        end
    end))
end

function MIDNIGHT:_AddKeybindToList(name, key, mode, callback, visible)
    self:_InitKeybindDispatcher()
    local kd = {_Name=name,_Key=key,_Mode=mode or "Press",_Callback=callback,_Active=false,_Visible=visible~=false}
    table.insert(self._Keybinds, kd)
    self._KeybindsMap[name] = kd
    if self._RefreshKeybindList then self._RefreshKeybindList() end
    return kd
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// WINDOW
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:MakeWindow(config)
    config = config or {}
    local windowName  = config.Name    or "MIDNIGHT"
    local menuKeyStr  = config.MenuKey or "RightShift"
    local menuKey     = ParseKeyCode(menuKeyStr)
    local titleBarH   = CompactStyle.TitleBarHeight
    local collapsedH  = CompactStyle.CollapsedWindowHeight
    local sidebarW    = CompactStyle.SidebarWidth
    local footerH     = CompactStyle.SidebarFooterHeight
    -- v7.1: configurable window size + optional resize handle
    local winW        = math.max(400, config.Width  or CompactStyle.WindowWidth)
    local winH        = math.max(200, config.Height or CompactStyle.WindowHeight)
    local resizable   = config.Resizable or false
    local minWinW     = config.MinWidth  or 400
    local minWinH     = config.MinHeight or 200
    local wd

    self:_InitScreenGui()
    if not self._Initialized then
        self:_InitFPSTracker()
        self._Initialized = true
    end
    if not self._MenuToggleConn then
        self:_InitMenuToggle(menuKey, KeyCodeToName(menuKey))
    end

    -- Open animation: starts transparent
    local wf = Create("Frame",{
        Name = _RandomGuiName(),
        Size = UDim2.new(0,winW,0,winH),
        Position = UDim2.new(0.5,-winW/2,0.5,-winH/2),
        BackgroundColor3 = Theme.WindowBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        ZIndex = ZIndex.WINDOW,
        Parent = self._ScreenGui,
    })
    ApplyCorner(wf,CompactStyle.WindowRadius)
    Create("ImageLabel",{
        Size=UDim2.new(1,24,1,24),Position=UDim2.new(0,-12,0,-12),
        BackgroundTransparency=1,Image="rbxassetid://6015897843",
        ImageColor3=Theme.Shadow,ImageTransparency=0.68,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),
        ZIndex=ZIndex.WINDOW-1,Parent=wf,
    })
    ApplyStroke(wf,Theme.BorderSoft,1,0.16)
    local wfScale = Create("UIScale", {Scale = 0.94, Parent = wf})
    local openPosition = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
    wf.Visible = false
    wf.BackgroundTransparency = 1
    wf.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2 + 12)

    self._MenuOpen = true

    local windowPulseToken = 0
    local function QueueWindowBorderPulse()
        windowPulseToken = windowPulseToken + 1
        local token = windowPulseToken
        task.delay(0.1, function()
            if token ~= windowPulseToken or not wf or not wf.Parent or not wf.Visible or not self._MenuOpen then return end
            local stroke = wf:FindFirstChildWhichIsA("UIStroke")
            if stroke then
                TweenObject(stroke, {Color = Theme.BorderAccent, Thickness = 1.2, Transparency = 0.1}, 0.16)
                task.delay(0.22, function()
                    if token ~= windowPulseToken or not stroke or not stroke.Parent or not wf.Visible or not self._MenuOpen then return end
                    TweenObject(stroke, {Color = Theme.Border, Thickness = 1, Transparency = 0.22}, 0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end)
            end
        end)
    end

    local function animateWindowOpen()
        if not wf or not wf.Parent or not self._MenuOpen then
            return
        end
        wf.Visible = true
        wf.BackgroundTransparency = 1
        wf.Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2 + 12)
        wfScale.Scale = 0.94
        TweenObject(wf, {
            BackgroundTransparency = 0,
            Position = openPosition,
        }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenObject(wfScale, {Scale = 1}, 0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        QueueWindowBorderPulse()
    end

    if not self._LoadingIntroPlayed then
        self._LoadingIntroPlayed = true
        local introDelay = _PlayLoadingIntroImpl(self, {
            Parent = self._ScreenGui,
            Title = windowName,
            Subtitle = "Loading interface...",
            DoneText = "Ready",
        })
        task.delay(math.max(0, introDelay or 0), animateWindowOpen)
    else
        animateWindowOpen()
    end

    -- TITLE BAR
    local tb = Create("Frame",{
        Name="TitleBar", Size=UDim2.new(1,0,0,titleBarH),
        BackgroundColor3=Theme.UtilityHeader, BorderSizePixel=0,
        ClipsDescendants=false, Active=true, ZIndex=ZIndex.CONTENT, Parent=wf,
    })
    ApplyCorner(tb,CompactStyle.HeaderRadius)
    Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.HeaderRadius),Position=UDim2.new(0,0,1,-CompactStyle.HeaderRadius),BackgroundColor3=Theme.UtilityHeader,BorderSizePixel=0,Parent=tb})
    Create("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=Theme.BorderSoft,BorderSizePixel=0,Parent=tb})
    CreateIconOrText(tb,"moon",nil,UDim2.new(0,14,0,14),UDim2.new(0,12,0,11),Theme.UtilityAccent,FontBold,12)
    Create("TextLabel",{
        Text=windowName,Font=FontBold,TextSize=12,TextColor3=Theme.TextPrimary,
        Size=UDim2.new(1,-108,1,0),Position=UDim2.new(0,32,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,
        ZIndex=ZIndex.CONTENT+1,Parent=tb,
    })

    -- Minimize
    local minBtn = Create("TextButton",{
        Name="MinBtn",Text="",Size=UDim2.new(0,24,0,18),
        Position=UDim2.new(1,-56,0,9),BackgroundColor3=Theme.MinNormal,
        BorderSizePixel=0,ZIndex=ZIndex.CONTENT+2,Parent=tb,
    })
    ApplyCorner(minBtn,4)
    Create("Frame",{Size=UDim2.new(0,8,0,2),Position=UDim2.new(0.5,-4,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Parent=minBtn})
    ApplyHoverEffect(minBtn,Theme.MinNormal,Theme.MinHover,false)

    -- Close
    local closeBtn = Create("TextButton",{
        Name="CloseBtn",Text="",Size=UDim2.new(0,24,0,18),
        Position=UDim2.new(1,-28,0,9),BackgroundColor3=Theme.CloseNormal,
        BorderSizePixel=0,ZIndex=ZIndex.CONTENT+2,Parent=tb,
    })
    ApplyCorner(closeBtn,4)
    Create("Frame",{Size=UDim2.new(0,8,0,2),Position=UDim2.new(0.5,-4,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=45,Parent=closeBtn})
    Create("Frame",{Size=UDim2.new(0,8,0,2),Position=UDim2.new(0.5,-4,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=closeBtn})
    ApplyHoverEffect(closeBtn,Theme.CloseNormal,Theme.CloseHover,false)

    closeBtn.MouseButton1Click:Connect(function()
        self._MenuOpen = false
        -- Cancel any previously pending close threads first
        for _, th in ipairs(self._MenuCloseThreads) do
            SafeCancelThread(th)
        end
        self._MenuCloseThreads = {}
        if self._LoadingOverlayStop then
            pcall(self._LoadingOverlayStop)
            self._LoadingOverlayStop = nil
        end
        if self._LoadingOverlayFrame then
            pcall(function() self._LoadingOverlayFrame:Destroy() end)
            self._LoadingOverlayFrame = nil
        end
        for _, w in ipairs(self._Windows) do
            if w._Frame then
                TweenObject(w._Frame,{BackgroundTransparency=1},0.2)
                local th = task.delay(0.25,function() if not self._MenuOpen then w._Frame.Visible=false end end)
                table.insert(self._MenuCloseThreads, th)
            end
        end
        for _, fw in ipairs(self._FloatingWindows or {}) do
            if fw and fw.Hide then
                pcall(function() fw:Hide() end)
            elseif fw and fw._Frame then
                pcall(function()
                    fw._Visible = false
                    fw._Frame.Visible = false
                end)
            end
        end
        self:Notify({Title="Menu Hidden",Content="Press ["..self._MenuKeyStr.."] to reopen",Type="info",Duration=4})
    end)

    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if wd then
            wd._IsMinimized = isMinimized
        end
        if isMinimized then
            TweenObject(wf,{Size=UDim2.new(0,winW,0,collapsedH)},0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
        else
            TweenObject(wf,{Size=UDim2.new(0,winW,0,winH)},0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
        end
    end)

    MakeDraggable(wf, tb, function() self:_CloseAllPopups() end)

    -- v7.1: Resize handle (bottom-right corner grip)
    if resizable then
        local rh = Create("TextButton",{
            Text="",Size=UDim2.new(0,18,0,18),
            Position=UDim2.new(1,-18,1,-18),
            BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+4,Parent=wf,
        })
        -- Draw the three diagonal lines of the grip
        for i=1,3 do
            local off=(i-1)*5
            Create("Frame",{
                Size=UDim2.new(0,i*4,0,1),
                Position=UDim2.new(1,-2-i*4,1,-3-off),
                BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,
                Rotation=-45,ZIndex=ZIndex.CONTENT+5,Parent=rh,
            })
        end
        local resDrag=false; local resStart; local resStartSize; local resEndConn=nil
        rh.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                if resEndConn then resEndConn:Disconnect(); resEndConn=nil end
                resDrag=true; resStart=inp.Position
                resStartSize=wf.Size
                resEndConn=inp.Changed:Connect(function()
                    if inp.UserInputState==Enum.UserInputState.End then
                        resDrag=false
                        if resEndConn then resEndConn:Disconnect(); resEndConn=nil end
                    end
                end)
            end
        end)
        RegConn(UserInputService.InputChanged:Connect(function(inp)
            if resDrag and inp.UserInputType==Enum.UserInputType.MouseMovement then
                local d=inp.Position-resStart
                local nw=math.max(minWinW, resStartSize.X.Offset+d.X)
                local nh=math.max(minWinH, resStartSize.Y.Offset+d.Y)
                winW=nw; winH=nh
                wf.Size=UDim2.new(0,nw,0,nh)
            end
        end))
    end

    -- BODY
    local body = Create("Frame",{
        Name="Body",Size=UDim2.new(1,0,1,-titleBarH),Position=UDim2.new(0,0,0,titleBarH),
        BackgroundTransparency=1, Active=true, Parent=wf,
    })

    -- SIDEBAR
    local sidebar = Create("Frame",{
        Name="Sidebar",Size=UDim2.new(0,sidebarW,1,-footerH),
        BackgroundColor3=Theme.Surface1,BorderSizePixel=0,Parent=body,
    })
    Create("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=Theme.BorderSoft,BorderSizePixel=0,Parent=sidebar})

    local tabList = Create("ScrollingFrame",{
        Name="TabList",Size=UDim2.new(1,0,1,-4),Position=UDim2.new(0,0,0,4),
        BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=2,ScrollBarImageColor3=Theme.ScrollBarColor,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=ZIndex.CONTENT,Parent=sidebar,
    })
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=tabList})
    ApplyPadding(tabList,4,4,CompactStyle.SidebarPadding,CompactStyle.SidebarPadding)

    -- Sidebar footer: version + fps/ping
    -- Uses UICorner with CornerRadiusMode to only round the bottom-left corner
    local sidebarFooterBg = Create("Frame",{
        Size=UDim2.new(0,sidebarW,0,footerH),Position=UDim2.new(0,0,1,-footerH),
        BackgroundColor3=Theme.Surface1,BorderSizePixel=0,
        ClipsDescendants=true, Parent=body,
    })
    -- Bottom-left rounded corner: cover top-left, top-right, bottom-right with a square overlay
    -- The window frame (wf) already has radius=10 at bottom-left вЂ” we need footer to match
    Create("UICorner",{CornerRadius=UDim.new(0,10),Parent=sidebarFooterBg})
    -- Square off top-left, top-right, bottom-right by overlaying flush rectangles
    Create("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.Surface1,BorderSizePixel=0,ZIndex=sidebarFooterBg.ZIndex,Parent=sidebarFooterBg})
    Create("Frame",{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=Theme.Surface1,BorderSizePixel=0,ZIndex=sidebarFooterBg.ZIndex,Parent=sidebarFooterBg})
    -- Border lines
    Create("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=Theme.BorderSoft,BorderSizePixel=0,ZIndex=sidebarFooterBg.ZIndex+1,Parent=sidebarFooterBg})
    Create("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.BorderSoft,BorderSizePixel=0,ZIndex=sidebarFooterBg.ZIndex+1,Parent=sidebarFooterBg})
    local footerLabel = Create("TextLabel",{
        Text="v"..self.Version.."  |  0 fps  |  0 ms",
        Font=FontRegular,TextSize=CompactStyle.UtilityMetaSize,TextColor3=Theme.TextMuted,
        Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,6,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,Parent=sidebarFooterBg,
    })
    table.insert(self._SidebarFooters, footerLabel)

    -- CONTENT AREA
    local contentFrame = Create("Frame",{
        Name="ContentFrame",Size=UDim2.new(1,-sidebarW,1,0),Position=UDim2.new(0,sidebarW,0,0),
        BackgroundColor3=Theme.Surface0,BorderSizePixel=0,
        ZIndex=ZIndex.CONTENT,Parent=body,
    })
    ApplyCorner(contentFrame,CompactStyle.WindowRadius)
    Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.WindowRadius),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.Surface0,BorderSizePixel=0,Parent=contentFrame})

    wd = {
        _Frame=wf, _TitleBar=tb, _Body=body, _Sidebar=sidebar,
        _TabList=tabList, _ContentFrame=contentFrame,
        _Tabs={}, _ActiveTab=nil, _FloatingWindows={},
        _AdminLogsWindow=nil, _AdminPresenceWidget=nil, _ChatLoggerWindow=nil,
        _Commands={}, _CommandPalette=nil,
        _TabCount=0,
        _IsMinimized=false,  -- BUG-E FIX: track minimized state in wd so MenuKey open restores correctly
    }

    function wd:_GetCurrentFrameSize()
        return winW, self._IsMinimized and collapsedH or winH
    end

    -- v7.1: public resize API on wd
    function wd:SetSize(w, h)
        w = math.max(minWinW, w or winW)
        h = math.max(minWinH, h or winH)
        winW, winH = w, h
        TweenObject(wf,{Size=UDim2.new(0,w,0,self._IsMinimized and collapsedH or h)},0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
    end

    function wd:_RegisterCommand(entry)
        if type(entry) ~= "table" then return entry end
        self._Commands[#self._Commands + 1] = entry
        return entry
    end

    function wd:_CollectCommands()
        local commands = {}
        for _, t in ipairs(self._Tabs) do
            if t._Name and t._Button and t._Button.Visible ~= false then
                commands[#commands + 1] = {
                    Title = t._Name,
                    Subtitle = "Open tab",
                    Search = (t._Name .. " tab open switch"):lower(),
                    Action = function()
                        if t._Select then t._Select() end
                    end,
                }
            end
        end
        for _, cmd in ipairs(self._Commands) do
            if type(cmd) == "table" and type(cmd.Action) == "function" then
                commands[#commands + 1] = cmd
            end
        end
        table.sort(commands, function(a, b)
            return tostring(a.Title or "") < tostring(b.Title or "")
        end)
        return commands
    end

    table.insert(self._Windows, wd)

    --// в•ђв•ђв•ђ MAKE TAB в•ђв•ђв•ђ
    function wd:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""

        self._TabCount = self._TabCount + 1

        -- Auto-add separator in sidebar if tabs > 6
        if self._TabCount == 7 then
            local sep = CreateGradientSeparator(tabList, self._TabCount - 1)
            if sep then sep.LayoutOrder = self._TabCount - 1 end
        end

        local btn = Create("TextButton",{
            Name="Tab_"..tabName,
            Size=UDim2.new(1,0,0,CompactStyle.TabHeight),
            BackgroundColor3=Theme.Surface2,
            BorderSizePixel=0, Text="",
            LayoutOrder=self._TabCount,
            ZIndex=ZIndex.CONTENT+1,
            Parent=tabList,
        })
        ApplyCorner(btn,5)

        local btnContent = Create("Frame",{Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,6,0,0),BackgroundTransparency=1,Parent=btn})
        Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=btnContent})

        local tabIconEl = nil
        if tabIcon ~= "" then
            tabIconEl = CreateIconOrText(btnContent,tabIcon,nil,UDim2.new(0,CompactStyle.TabIconSize,0,CompactStyle.TabIconSize),UDim2.new(0,0,0,0),Theme.TextMuted,FontBold,10)
            if tabIconEl then tabIconEl.LayoutOrder=1 end
        end

        local tabLabel = Create("TextLabel",{
            Text=tabName,Font=Font,TextSize=CompactStyle.TabTextSize,TextColor3=Theme.TextSecondary,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,LayoutOrder=2,Parent=btnContent,
        })

        local indicator = Create("Frame",{
            Size=UDim2.new(0,3,0,0),Position=UDim2.new(0,0,0.5,0),
            BackgroundColor3=Theme.Accent,BorderSizePixel=0,Parent=btn,
        })
        ApplyCorner(indicator,1)

        -- Active tab glow stroke
        local tabGlowStroke = Create("UIStroke",{
            Color=Theme.AccentMuted,Thickness=1,Transparency=1,
            Parent=btn,
        })

        -- Scrollbar auto-hide per scrolling frame
        -- FIX #2: Register via RegConn so the CanvasPosition listener is disconnected on
        -- MIDNIGHT:Destroy(). Previously this connection leaked forever вЂ” every tab ever
        -- created kept a live CanvasPosition listener even after the GUI was torn down,
        -- causing memory bloat and potential nil-indexing crashes after Destroy().
        -- BUG FIX #2+#3: Scrollbar auto-hide rewrite
        -- Old code had two bugs:
        --   1. scrollFrame.ScrollBarImageTransparency = 0 AFTER TweenObject({..Transparency=1}) cancelled
        --      the tween visually вЂ” the bar flashed instead of fading smoothly.
        --   2. Direct property writes (Thickness=3) on EVERY CanvasPosition change caused micro-jank;
        --      now we guard with a `visible` flag so we only write on state transitions.
        local function setupScrollbarAutoHide(scrollFrame)
            if not scrollFrame then return end
            local fadeTimer  = nil
            local fadeToken  = 0
            local sbVisible  = false  -- track state so we don't write on every scroll event

            RegConn(scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if not scrollFrame.Parent then return end
                fadeToken = fadeToken + 1
                local token = fadeToken

                -- Show bar only on state transition (hidden в†’ visible)
                if not sbVisible then
                    sbVisible = true
                    scrollFrame.ScrollBarThickness = 3
                    scrollFrame.ScrollBarImageTransparency = 0
                end

                -- Cancel previous hide timer вЂ” use pcall in case the thread is already dead
                -- BUG-D FIX: some executors return nil or userdata from task.delay, not a thread.
                -- Unconditionally pcall-cancel and nil the ref; typeof guard would silently skip it.
                if fadeTimer ~= nil then
                    pcall(function() task.cancel(fadeTimer) end)
                    fadeTimer = nil
                end

                -- Schedule hide
                fadeTimer = task.delay(1.5, function()
                    fadeTimer = nil
                    if token ~= fadeToken or not scrollFrame.Parent then return end
                    -- Fade out transparency only; do NOT reset Transparency back to 0 after fade
                    -- (the old code did ScrollBarImageTransparency=0 after the tween, which
                    --  made the bar reappear briefly вЂ” that line is intentionally absent here)
                    TweenObject(scrollFrame, {ScrollBarImageTransparency = 1}, 0.4)
                    task.delay(0.45, function()
                        if token ~= fadeToken then return end
                        if scrollFrame and scrollFrame.Parent then
                            -- Only hide thickness AFTER the tween completes, and mark invisible
                            scrollFrame.ScrollBarThickness = 0
                            sbVisible = false
                            -- Keep ImageTransparency=1 so next show starts from invisible state
                        end
                    end)
                end)
            end))
        end

        -- Page (tab content) вЂ” uses a ClipsDescendants frame for slide animation
        local pageClip = Create("Frame",{
            Name="TabClip_"..tabName,
            Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0),
            BackgroundTransparency=1, BorderSizePixel=0,
            ClipsDescendants=true,
            Visible=false,
            ZIndex=ZIndex.CONTENT,
            Parent=contentFrame,
        })
        local page = Create("ScrollingFrame",{
            Name="TabContent_"..tabName,
            Size=UDim2.new(1,-8,1,-8),Position=UDim2.new(0,4,0,4),
            BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=3,ScrollBarImageColor3=Theme.ScrollBarColor,
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ZIndex=ZIndex.CONTENT+1,
            Parent=pageClip,
        })
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=page})
        ApplyPadding(page,2,2,6,6)
        setupScrollbarAutoHide(page)

        -- Empty placeholder
        local placeholder = Create("TextLabel",{
            Text="No items",Font=FontRegular,TextSize=12,
            TextColor3=Theme.TextMuted,
            Size=UDim2.new(1,0,1,0),
            TextXAlignment=Enum.TextXAlignment.Center,
            TextYAlignment=Enum.TextYAlignment.Center,
            BackgroundTransparency=1,
            ZIndex=ZIndex.CONTENT+2,
            Parent=page,
        })

        local td = {
            _Name=tabName,
            _Button=btn, _Page=page, _PageClip=pageClip,
            _Layout=nil, _Window=wd, _ItemCount=0,
            _Indicator=indicator, _Label=tabLabel,
            _IconEl=tabIconEl, _GlowStroke=tabGlowStroke,
            _Placeholder=placeholder,
            _Select=nil,
        }
        table.insert(self._Tabs, td)

        local function selectTab()
            if self._ActiveTab == td and pageClip.Visible then
                return
            end

            for _, t in ipairs(self._Tabs) do
                local active = (t == td)
                if t._PageClip then
                    t._PageClip.Visible = active
                    if t._Page then
                        t._Page.Position = UDim2.new(0,4,0,4)
                    end
                end
                TweenObject(t._Button,{BackgroundColor3 = active and Theme.TabActiveBg or Theme.Surface2},0.18)
                TweenObject(t._Indicator,{
                    Size = active and UDim2.new(0,3,0.62,0) or UDim2.new(0,3,0,0),
                    Position = active and UDim2.new(0,0,0.19,0) or UDim2.new(0,0,0.5,0),
                },0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                if t._Label then
                    TweenObject(t._Label,{TextColor3 = active and Theme.TextAccent or Theme.TextSecondary},0.18)
                end
                if t._IconEl then
                    if t._IconEl:IsA("ImageLabel") then
                        TweenObject(t._IconEl,{ImageColor3 = active and Theme.Accent or Theme.TextMuted},0.18)
                    else
                        TweenObject(t._IconEl,{TextColor3 = active and Theme.Accent or Theme.TextMuted},0.18)
                    end
                end
                if t._GlowStroke then
                    TweenObject(t._GlowStroke,{Transparency = active and 0.72 or 1},0.18)
                end
            end

            pageClip.Visible = true
            page.Position = UDim2.new(0,4,0,4)
            self._ActiveTab = td
        end
        td._Select = selectTab

        btn.MouseButton1Click:Connect(selectTab)
        ApplyHoverEffect(btn, Theme.Surface2, Theme.Surface3, false, {
            GetNormalBg = function()
                return self._ActiveTab == td and Theme.TabActiveBg or Theme.Surface2
            end,
            GetHoverBg = function()
                return self._ActiveTab == td and Theme.TabActiveBg or Theme.Surface3
            end,
        })
        if #self._Tabs == 1 then
            pageClip.Visible=true; page.Position=UDim2.new(0,4,0,4)
            TweenObject(btn,{BackgroundColor3=Theme.TabActiveBg},0.18)
            TweenObject(indicator,{Size=UDim2.new(0,3,0.62,0),Position=UDim2.new(0,0,0.19,0)},0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
            if tabLabel then tabLabel.TextColor3=Theme.TextAccent end
            if tabGlowStroke then tabGlowStroke.Transparency=0.72 end
            self._ActiveTab=td
        end

        -- tab:SetVisible
        function td:SetVisible(bool)
            btn.Visible = bool
            if not bool and self._Window._ActiveTab == td then
                -- Switch to first visible tab
                local switched = false
                for _, t in ipairs(self._Window._Tabs) do
                    if t ~= td and t._Button.Visible then
                        if t._Select then
                            t._Select()
                            switched = true
                        end
                        break
                    end
                end
                if not switched then
                    self._Window._ActiveTab = nil
                    if self._PageClip then self._PageClip.Visible = false end
                end
            end
        end

        local function nextOrder()
            td._ItemCount = td._ItemCount + 1
            -- Hide placeholder once there's content
            if td._Placeholder then td._Placeholder.Visible = false end
            return td._ItemCount
        end

        local function registerCommand(title, kind, action, extraSearch)
            return wd:_RegisterCommand({
                Title = title,
                Subtitle = tabName .. " / " .. (kind or "Action"),
                Search = string.lower(table.concat({title or "", tabName or "", kind or "", extraSearch or ""}, " ")),
                Action = function()
                    selectTab()
                    if action then action() end
                end,
            })
        end

        local rowControlH = 20
        local rowControlY = -math.floor(rowControlH / 2)
        local rowWideControlW = 116
        local rowValueControlW = 58
        local rowToggleW = 34
        local rowBadgeGap = 8
        local rowLabelInset = 122

        local function CreateInlineCheck(parent)
            return CreateIconOrText(
                parent,
                "check",
                "v",
                UDim2.new(0,8,0,8),
                UDim2.new(0.5,-4,0.5,-4),
                Theme.TextPrimary,
                FontBold,
                8
            )
        end

        --// ADDSECTION
        function td:AddSection(sc)
            sc = sc or {}; local nm = sc.Name or "Section"
            local sf = Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.SectionHeight),BackgroundTransparency=1,LayoutOrder=nextOrder(),Parent=page})
            local sc2 = Create("Frame",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,2),BackgroundTransparency=1,Parent=sf})
            Create("TextLabel",{
                Text=nm,Font=FontBold,TextSize=CompactStyle.SectionTextSize,
                TextColor3=Theme.TextSecondary,TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=sc2,
            })
            Create("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-3),BackgroundColor3=Theme.BorderSoft,BorderSizePixel=0,Parent=sf})
            return sf
        end

        --// ADDSEPARATOR
        function td:AddSeparator()
            local s = CreateGradientSeparator(page, nextOrder())
            return s
        end

        --// ADDLABEL
        function td:AddLabel(lc)
            lc = lc or {}; local nm = lc.Name or "Label"
            local lf = Create("Frame",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,LayoutOrder=nextOrder(),Parent=page})
            local lbl = Create("TextLabel",{
                Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextSecondary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),
                BackgroundTransparency=1,Parent=lf,
            })
            return {_Label=lbl, Set=function(_,t) lbl.Text=t end}
        end

        --// ADDTOGGLE
        function td:AddToggle(tc)
            tc = tc or {}
            local nm      = tc.Name    or "Toggle"
            local def     = tc.Default or false
            local cb      = tc.Callback
            local col     = tc.Color   or Theme.Accent
            local bindKey = ParseKeyCode(tc.Key or "Unknown")
            local bindMode = tc.Mode   or "Press"
            local isMenuKey = tc.IsMenuKey or false
            local cfgFlag  = tc.Flag

            local item = Create("Frame",{
                Size=UDim2.new(1,0,0,CompactStyle.RowHeight),BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0,Active=true,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local nameLabel = Create("TextLabel",{
                Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,-rowLabelInset,1,0),BackgroundTransparency=1,Parent=ic,
            })

            -- Keybind badge
            local keyBadge = Create("Frame",{
                Size=UDim2.new(0,0,0,18),AutomaticSize=Enum.AutomaticSize.X,
                AnchorPoint=Vector2.new(1,0.5),
                Position=UDim2.new(1,-(rowToggleW + rowBadgeGap),0.5,0),
                BackgroundColor3=Theme.Surface3,BorderSizePixel=0,Parent=ic,
            })
            ApplyCorner(keyBadge,4); ApplyStroke(keyBadge,Theme.BorderSoft,1,0.35); ApplyPadding(keyBadge,0,0,4,4)
            local keyBadgeLabel = Create("TextLabel",{
                Text=bindKey~=Enum.KeyCode.Unknown and KeyCodeToName(bindKey) or "",
                Font=FontBold,TextSize=CompactStyle.UtilityMetaSize,TextColor3=Theme.TextMuted,
                Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundTransparency=1,Parent=keyBadge,
            })

            local sw = Create("Frame",{Size=UDim2.new(0,rowToggleW,0,18),Position=UDim2.new(1,-rowToggleW,0.5,-9),BackgroundColor3=Theme.ToggleOff,BorderSizePixel=0,ClipsDescendants=false,Parent=ic})
            ApplyCorner(sw,8)
            local knob = Create("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(0,2,0.5,-6),BackgroundColor3=Theme.ToggleKnob,BorderSizePixel=0,Parent=sw})
            ApplyCorner(knob,6)

            local on = def
            local data = {_Value=on,_Key=bindKey,_Mode=bindMode,_KeyBadge=keyBadgeLabel}
            local bindVisible = not isMenuKey

            local function refreshKeyBadge()
                local hasKey = bindKey ~= Enum.KeyCode.Unknown
                keyBadge.Visible = hasKey
                keyBadgeLabel.Text = hasKey and KeyCodeToName(bindKey) or ""
                nameLabel.Size = UDim2.new(1,-(hasKey and rowLabelInset or (rowToggleW + 8)),1,0)
            end

            local function update(anim)
                if on then
                    if anim then
                        TweenObject(sw,{BackgroundColor3=col},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                        TweenObject(knob,{Position=UDim2.new(0,20,0.5,-6),BackgroundColor3=Theme.ToggleKnob},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                    else
                        sw.BackgroundColor3=col
                        knob.Size=UDim2.new(0,12,0,12); knob.Position=UDim2.new(0,20,0.5,-6)
                        knob.BackgroundColor3=Theme.ToggleKnob
                    end
                else
                    if anim then
                        TweenObject(sw,{BackgroundColor3=Theme.ToggleOff},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                        TweenObject(knob,{Position=UDim2.new(0,2,0.5,-6),BackgroundColor3=Theme.ToggleKnob},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                    else
                        sw.BackgroundColor3=Theme.ToggleOff
                        knob.Size=UDim2.new(0,12,0,12); knob.Position=UDim2.new(0,2,0.5,-6)
                        knob.BackgroundColor3=Theme.ToggleKnob
                    end
                end
            end

            local function syncKeybindData()
                refreshKeyBadge()
                if data._KeybindData then
                    data._KeybindData._Key = bindKey
                    data._KeybindData._Mode = bindMode
                    data._KeybindData._Visible = bindVisible
                    data._KeybindData._Active = on
                elseif bindKey ~= Enum.KeyCode.Unknown then
                    local kd = MIDNIGHT:_AddKeybindToList(nm,bindKey,bindMode,function(active)
                        on=active; data._Value=on; update(true); if cb then cb(on) end
                    end, bindVisible)
                    kd._Active = on
                    data._KeybindData = kd
                end
                if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
            end

            -- Transparent button overlay for reliable click handling
            local clickBtn = Create("TextButton",{
                Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                ZIndex=ZIndex.CONTENT+2,Parent=item,
            })
            clickBtn.MouseButton1Click:Connect(function()
                on=not on; data._Value=on; update(true)
                if data._KeybindData then data._KeybindData._Active=on end
                if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                if cb then cb(on) end
            end)
            clickBtn.MouseButton2Click:Connect(function()
                local ap = item.AbsolutePosition; local as = item.AbsoluteSize
                local curVis = data._KeybindData and data._KeybindData._Visible or bindVisible
                MIDNIGHT:_ShowKeybindSettings({
                    Position=Vector2.new(ap.X+as.X,ap.Y),
                    Mode=data._Mode, Visible=curVis,
                    CurrentKeyStr=bindKey~=Enum.KeyCode.Unknown and KeyCodeToName(bindKey) or "None",
                    OnKeyChange=function(newKey,newKeyStr)
                        bindKey=newKey; keyBadgeLabel.Text=newKeyStr; data._Key=newKey
                        syncKeybindData()
                        if isMenuKey then MIDNIGHT:SetMenuKey(newKeyStr) end
                    end,
                    OnModeChange=function(newMode)
                        data._Mode=newMode; bindMode=newMode
                        if data._KeybindData and data._KeybindData._Mode=="Hold" and data._KeybindData._Active and newMode~="Hold" then
                            data._KeybindData._Active=false
                            if data._KeybindData._Callback then data._KeybindData._Callback(false) end
                        end
                        syncKeybindData()
                    end,
                    OnVisibleChange=function(vis)
                        bindVisible = vis
                        syncKeybindData()
                    end,
                })
            end)

            update(false)
            syncKeybindData()

            function data:Set(v)
                -- BUG-6 FIX: only fire callback when value actually changes
                local changed = (v ~= on)
                on = v; data._Value = v; update(true)
                if data._KeybindData then data._KeybindData._Active = v end
                if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                if cb and changed then cb(v) end
            end
            function data:SetKey(k)
                local nk=ParseKeyCode(k); if nk==Enum.KeyCode.Unknown then return end
                bindKey=nk; keyBadgeLabel.Text=KeyCodeToName(nk); data._Key=nk
                syncKeybindData()
                if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(nk)) end
            end
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) data:Set(v) end,
                    "toggle"
                )
            end
            registerCommand(nm, "Toggle", function()
                data:Set(not data._Value)
            end, "toggle switch enable disable")
            return data
        end

        --// ADDSLIDER
        function td:AddSlider(sc)
            sc = sc or {}
            local nm   = sc.Name         or "Slider"
            local mn   = sc.Min          or 0
            local mx   = sc.Max          or 100
            local def  = sc.Default      or mn
            local pct  = sc.Percentage
            local step = sc.Step         or 1
            local dec  = sc.DecimalPlaces or (pct and 1 or 0)
            local cb   = sc.Callback
            local cfgFlag = sc.Flag

            if mx < mn then mn, mx = mx, mn end
            if mx == mn then mx = mn + 1 end
            if step <= 0 then step = 1 end
            def = math.clamp(def, mn, mx)
            local range = mx - mn

            local item = Create("Frame",{
                Size=UDim2.new(1,0,0,CompactStyle.TallRowHeight),BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,6,6,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{
                Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,-(rowValueControlW + 6),0,16),BackgroundTransparency=1,Parent=ic,
            })

            local valueWrap = Create("Frame",{
                Size=UDim2.new(0,rowValueControlW,0,rowControlH),
                Position=UDim2.new(1,-rowValueControlW,0,0),
                BackgroundColor3=Theme.Surface3,
                BorderSizePixel=0,
                Parent=ic,
            })
            ApplyCorner(valueWrap,4)
            ApplyStroke(valueWrap,Theme.BorderSoft,1,0.24)

            local vl = Create("TextLabel",{
                Text=pct and def.."%" or tostring(def),
                Font=FontBold,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextAccent,
                TextXAlignment=Enum.TextXAlignment.Right,
                Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),
                BackgroundTransparency=1,Parent=valueWrap,
            })

            local track = Create("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,0,27),BackgroundColor3=Theme.SliderTrack,BorderSizePixel=0,Parent=ic})
            ApplyCorner(track,2)
            local r0 = (def-mn)/range
            local fill = Create("Frame",{Size=UDim2.new(r0,0,1,0),BackgroundColor3=Theme.SliderFill,BorderSizePixel=0,Parent=track})
            ApplyCorner(fill,2)
            local k = Create("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(r0,-6,0.5,-6),BackgroundColor3=Theme.SliderKnob,BorderSizePixel=0,Parent=track})
            ApplyCorner(k,6); Create("UIStroke",{Color=Theme.Accent,Thickness=1.2,Transparency=0.08,Parent=k})

            -- Tooltip above knob
            local tooltip = Create("Frame",{
                Size=UDim2.new(0,44,0,18),
                Position=UDim2.new(r0,-22,0,-24),
                BackgroundColor3=Theme.InputBg,
                BorderSizePixel=0, BackgroundTransparency=1,
                ZIndex=ZIndex.TOOLTIP, Parent=track,
            })
            ApplyCorner(tooltip,4)
            local tooltipLabel = Create("TextLabel",{
                Text=tostring(def),Font=FontBold,TextSize=9,
                TextColor3=Theme.TextPrimary,
                Size=UDim2.new(1,0,1,0),
                TextXAlignment=Enum.TextXAlignment.Center,
                BackgroundTransparency=1,ZIndex=ZIndex.TOOLTIP+1,Parent=tooltip,
            })

            -- Manual value input (click value label в†’ TextBox)
            local inputBox = Create("TextBox",{
                Text="",PlaceholderText=vl.Text,
                Font=FontBold,TextSize=11,TextColor3=Theme.Accent,
                TextXAlignment=Enum.TextXAlignment.Right,
                Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),
                BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
                Visible=false,ZIndex=ZIndex.CONTENT+3,Parent=valueWrap,
            })
            ApplyCorner(inputBox,3); ApplyStroke(inputBox,Theme.Accent,1)

            local cur = def; local drag = false; local data = {_Value=cur}

            local function upd(v, anim, forceCb)
                v=math.clamp(v,mn,mx)
                v=math.floor((v-mn)/step+0.5)*step+mn
                v=math.clamp(v,mn,mx)
                local changed = v ~= cur
                cur=v; data._Value=v
                local rat=(v-mn)/range
                local txt = pct and string.format("%."..dec.."f%%",v) or string.format("%."..dec.."f",v)
                vl.Text=txt; tooltipLabel.Text=txt; inputBox.PlaceholderText=txt
                if anim then
                    TweenObject(fill,{Size=UDim2.new(rat,0,1,0)},0.1)
                    TweenObject(k,{Position=UDim2.new(rat,-6,0.5,-6)},0.1)
                    TweenObject(tooltip,{Position=UDim2.new(rat,-22,0,-24)},0.1)
                else
                    fill.Size=UDim2.new(rat,0,1,0)
                    k.Position=UDim2.new(rat,-6,0.5,-6)
                    tooltip.Position=UDim2.new(rat,-22,0,-24)
                end
                if cb and (changed or forceCb) then cb(v) end
            end

            local function onInp(inp)
                if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
                    local rl=math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                    upd(mn+rl*range,false)
                end
            end

            -- FIX #1: Use the shared global slider dispatcher (_SliderSetDrag/_SliderClearDrag)
            -- instead of registering two new global UIS connections per slider instance.
            -- Previously each AddSlider() added RegConn(UIS.InputEnded) + RegConn(UIS.InputChanged),
            -- meaning N sliders = N*2 global mouse-event listeners firing every frame вЂ”
            -- a direct FPS killer on tabs with many sliders. Now we route through the
            -- single permanent dispatcher pair registered at module load time.
            local function onGrabStart(inp)
                drag = true; onInp(inp)
                TweenObject(k,{Size=UDim2.new(0,16,0,16)},0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                TweenObject(tooltip,{BackgroundTransparency=0},0.15)
                TweenObject(tooltipLabel,{TextTransparency=0},0.15)
                -- Register with shared dispatcher so only this slider gets move/end events
                _SliderSetDrag(
                    function(mi) onInp(mi) end,
                    function()
                        drag = false
                        _SliderClearDrag()
                        TweenObject(k,{Size=UDim2.new(0,12,0,12)},0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                        TweenObject(tooltip,{BackgroundTransparency=1},0.2)
                        TweenObject(tooltipLabel,{TextTransparency=1},0.2)
                    end
                )
            end

            track.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    onGrabStart(inp)
                end
            end)
            k.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    onGrabStart(inp)
                end
            end)

            -- Click value label to open manual input
            tooltip.BackgroundTransparency=1; tooltipLabel.TextTransparency=1
            vl.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                    vl.Visible=false; inputBox.Visible=true; inputBox.Text=""
                    inputBox:CaptureFocus()
                end
            end)
            inputBox.FocusLost:Connect(function(enter)
                local v = tonumber(inputBox.Text)
                if v then upd(v,true,true) end
                inputBox.Visible=false; vl.Visible=true; inputBox.Text=""
            end)

            upd(def,false,true)
            function data:Set(v) upd(v,true,false) end
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) if tonumber(v) then data:Set(tonumber(v)) end end,
                    "slider"
                )
            end
            registerCommand(nm, "Slider", function()
                data:Set(math.min(mx, data._Value + step))
            end, "slider increase adjust")
            return data
        end

        --// ADDKEYBIND
        function td:AddKeybind(kc)
            kc = kc or {}
            local nm = kc.Name or "Keybind"; local key = ParseKeyCode(kc.Key or "Unknown")
            local mode = kc.Mode or "Press"; local cb = kc.Callback; local isMenuKey = kc.IsMenuKey or false
            local cfgFlag = kc.Flag

            local item = Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.RowHeight),BackgroundColor3=Theme.Surface2,BorderSizePixel=0,Active=true,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local nc = Create("Frame",{Size=UDim2.new(1,-84,0,14),Position=UDim2.new(0,0,0,4),BackgroundTransparency=1,Parent=ic})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=nc})
            local ki2 = CreateIconOrText(nc,"key",nil,UDim2.new(0,11,0,11),UDim2.new(0,0,0,0),Theme.TextPrimary,FontBold,10)
            if ki2 then ki2.LayoutOrder=1 end
            Create("TextLabel",{Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,LayoutOrder=2,Parent=nc})
            local modeLbl = Create("TextLabel",{Text=mode:upper(),Font=FontRegular,TextSize=CompactStyle.UtilityMetaSize,TextColor3=Theme.TextMuted,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,-84,0,12),Position=UDim2.new(0,0,0,19),BackgroundTransparency=1,Parent=ic})

            local function updateModeLabel(m)
                mode=m; modeLbl.Text=m:upper()
            end

            -- Keybind badge button
            local kbBadge = Create("Frame",{
                Size=UDim2.new(0,0,0,18),AutomaticSize=Enum.AutomaticSize.X,
                Position=UDim2.new(1,0,0.5,0),AnchorPoint=Vector2.new(1,0.5),
                BackgroundColor3=Theme.Surface3,BorderSizePixel=0,Parent=ic,
            })
            ApplyCorner(kbBadge,4); ApplyStroke(kbBadge,Theme.BorderSoft,1,0.35); ApplyPadding(kbBadge,0,0,5,5)
            local kbLabel = Create("TextLabel",{
                Text=KeyCodeToName(key),Font=FontBold,TextSize=CompactStyle.FieldTextSize,
                TextColor3=Theme.TextAccent,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundTransparency=1,Parent=kbBadge,
            })
            local kbBtn = Create("TextButton",{Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+2,Parent=kbBadge})

            local kd
            local listening2 = false
            kbBtn.MouseButton1Click:Connect(function()
                if listening2 then return end
                listening2=true; kbLabel.Text="..."; kbLabel.TextColor3=Theme.Warning
                local conn; conn=UserInputService.InputBegan:Connect(function(inp,gp)
                    if gp then return end
                    if inp.KeyCode~=Enum.KeyCode.Unknown then
                        key=inp.KeyCode; kbLabel.Text=KeyCodeToName(key); kbLabel.TextColor3=Theme.TextAccent
                        listening2=false; conn:Disconnect()
                        kd._Key=key
                        if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                        if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(key)) end
                    end
                end)
                -- BUG-10 FIX: do NOT add to RegConn вЂ” conn self-disconnects when user picks a key.
                -- RegConn here accumulates a dead ref on every click. Lifetime is managed by
                -- item.Destroying so the conn is cleaned up if the widget is destroyed mid-listen.
                if item and item.Destroying then
                    item.Destroying:Connect(function()
                        pcall(function() conn:Disconnect() end)
                        listening2 = false
                    end)
                end
            end)

            kbBtn.MouseButton2Click:Connect(function()
                local ap=kbBadge.AbsolutePosition; local as=kbBadge.AbsoluteSize
                MIDNIGHT:_ShowKeybindSettings({
                    Position=Vector2.new(ap.X,ap.Y),Mode=mode,Visible=kd._Visible,
                    CurrentKeyStr=key~=Enum.KeyCode.Unknown and KeyCodeToName(key) or "None",
                    OnKeyChange=function(nk,ns) key=nk; kbLabel.Text=ns
                        kd._Key=nk
                        if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                        if isMenuKey then MIDNIGHT:SetMenuKey(ns) end
                    end,
                    OnModeChange=function(nm2) updateModeLabel(nm2)
                        if kd._Mode=="Hold" and kd._Active and nm2~="Hold" then
                            kd._Active=false
                            if kd._Callback then kd._Callback(false) end
                        end
                        kd._Mode=nm2
                    end,
                    OnVisibleChange=function(vis)
                        kd._Visible=vis
                        if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                    end,
                })
            end)

            kd = MIDNIGHT:_AddKeybindToList(nm,key,mode,cb,not isMenuKey)
            kd._Frame=item; kd._KeyLabel=kbLabel; kd._ModeLabel=modeLbl
            function kd:Set(k2)
                local nk=ParseKeyCode(k2); kbLabel.Text=KeyCodeToName(nk); key=nk
                kd._Key=nk
                if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(nk)) end
            end
            function kd:SetMode(m)
                updateModeLabel(m)
                if kd._Mode=="Hold" and kd._Active and m~="Hold" then
                    kd._Active=false
                    if kd._Callback then kd._Callback(false) end
                end
                kd._Mode=m
            end
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function()
                        return kd._Key or Enum.KeyCode.Unknown
                    end,
                    function(v) kd:Set(v) end,
                    "keybind"
                )
            end
            registerCommand(nm, "Keybind", function()
                local ap=kbBadge.AbsolutePosition
                MIDNIGHT:_ShowKeybindSettings({
                    Position=Vector2.new(ap.X,ap.Y),Mode=mode,Visible=kd._Visible,
                    CurrentKeyStr=key~=Enum.KeyCode.Unknown and KeyCodeToName(key) or "None",
                    OnKeyChange=function(nk,ns) key=nk; kbLabel.Text=ns; kd._Key=nk end,
                    OnModeChange=function(nm2) updateModeLabel(nm2); kd._Mode=nm2 end,
                    OnVisibleChange=function(vis) kd._Visible=vis end,
                })
            end, "keybind hotkey mode")
            return kd
        end

        --// ADDDROPDOWN (popup)
        function td:AddDropdown(dc)
            dc = dc or {}
            local nm    = dc.Name    or "Dropdown"
            local opts  = dc.Options or {}
            local def   = dc.Default or opts[1]
            local cb    = dc.Callback
            local multi = dc.Multi or false  -- NEW: multiselect mode
            local cfgFlag = dc.Flag

            -- Height: single=34, multi can show tags so also 34 base
            local item=Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.RowHeight),BackgroundColor3=Theme.Surface2,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,-(rowWideControlW + 8),1,0),BackgroundTransparency=1,Parent=ic})

            -- The selector button
            local sb=Create("TextButton",{
                Text = multi and "Select..." or (def or ""),
                Font=Font,TextSize=CompactStyle.FieldTextSize,TextColor3=Theme.TextSecondary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(0,rowWideControlW,0,rowControlH),Position=UDim2.new(1,-rowWideControlW,0.5,rowControlY),
                BackgroundColor3=Theme.Surface3,BorderSizePixel=0,Parent=ic,
                TextTruncate=Enum.TextTruncate.AtEnd,
                ClipsDescendants=true,
            })
            ApplyCorner(sb,4); ApplyStroke(sb,Theme.BorderSoft,1,0.22)
            ApplyPadding(sb,0,0,8,18)
            -- BUG-5 FIX: capture the chevron element directly from the return value.
            -- FindFirstChildWhichIsA("TextLabel") could return any TextLabel child (e.g. the sb's
            -- own Text property rendered as a child), picking the wrong element for rotation.
            local chevIcon = CreateIconOrText(sb,"chevron-down",nil,UDim2.new(0,8,0,8),UDim2.new(1,-11,0.5,-4),Theme.TextMuted,FontBold,7)

            -- Multi: track selected set; Single: track string
            local selSet = {}  -- for multi
            local sel    = def -- for single

            -- Init multiselect default
            if multi and type(def) == "table" then
                for _, v in ipairs(def) do selSet[v] = true end
            end

            local function getMultiLabel()
                local parts = {}
                for _, o in ipairs(opts) do if selSet[o] then table.insert(parts, o) end end
                if #parts == 0 then return "None" end
                if #parts == 1 then return parts[1] end
                return parts[1] .. " +" .. (#parts - 1)
            end

            local data = {_Value = multi and {} or sel}

            local function refreshLabel()
                if multi then
                    local parts = {}
                    for _, o in ipairs(opts) do if selSet[o] then table.insert(parts, o) end end
                    data._Value = parts
                    sb.Text = getMultiLabel()
                    sb.TextColor3 = #parts > 0 and Theme.TextAccent or Theme.TextSecondary
                else
                    sb.Text = sel or "Select..."
                    sb.TextColor3 = sel and Theme.TextAccent or Theme.TextSecondary
                    data._Value = sel
                end
            end

            -- Chevron tween on open/close
            local dropOpen = false
            sb.MouseButton1Click:Connect(function()
                dropOpen = not dropOpen
                if chevIcon then
                    TweenObject(chevIcon, {Rotation = dropOpen and 180 or 0}, 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end
                MIDNIGHT:_OpenDropdown({
                    ButtonPos=item.AbsolutePosition, ButtonSize=item.AbsoluteSize,
                    Options=opts, Current=multi and selSet or sel,
                    DropdownBtn=sb, Multi=multi,
                    OnSelect=function(opt)
                        if multi then
                            -- opt is the table of selected values
                            selSet = {}
                            for _, v in ipairs(opt) do selSet[v] = true end
                            refreshLabel()
                            if cb then cb(opt) end
                        else
                            sel = opt; refreshLabel()
                            if cb then cb(opt) end
                        end
                        dropOpen = false
                        if chevIcon then TweenObject(chevIcon,{Rotation=0},0.12,Enum.EasingStyle.Quint,Enum.EasingDirection.Out) end
                    end,
                })
            end)

            refreshLabel()

            function data:Set(v)
                if multi then
                    selSet = {}
                    if type(v) == "table" then for _, x in ipairs(v) do selSet[x]=true end end
                else sel = v end
                refreshLabel()
            end
            function data:SetOptions(newOpts)
                opts = newOpts
                if not multi and not table.find(opts, sel) then sel=opts[1] end
                refreshLabel()
            end
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) data:Set(v) end,
                    "dropdown"
                )
            end
            return data
        end

        --// ADDINLINEDROPDOWN (no popup, expands inline)
        function td:AddInlineDropdown(dc)
            dc = dc or {}
            local nm    = dc.Name    or "Dropdown"
            local opts  = dc.Options or {}
            local def   = dc.Default or opts[1]
            local cb    = dc.Callback
            local multi = dc.Multi or false  -- NEW: multiselect mode
            local cfgFlag = dc.Flag

            local sel    = multi and {} or def
            local selSet = {}  -- for multi
            if multi and type(def) == "table" then
                for _, v in ipairs(def) do selSet[v] = true end
            elseif multi then sel = {} end

            local data     = {_Value = multi and {} or def}
            local expanded = false
            local baseH    = CompactStyle.RowHeight
            local itemH    = 24

            local wrapper = Create("Frame",{
                Size=UDim2.new(1,0,0,baseH), BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0, LayoutOrder=nextOrder(), Parent=page,
                ClipsDescendants=true,
            })
            ApplyCorner(wrapper,6); ApplyStroke(wrapper,Theme.BorderSoft,1,0.24)
            ApplyHoverEffect(wrapper, Theme.Surface2, Theme.Surface3, true)

            local header = Create("Frame",{Size=UDim2.new(1,0,0,baseH),BackgroundTransparency=1,Parent=wrapper})
            ApplyPadding(header,0,0,10,10)
            local hic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=header})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,-(rowWideControlW + 18),1,0),BackgroundTransparency=1,Parent=hic})

            local selLabel = Create("TextLabel",{
                Text = multi and "None" or (def or ""),
                Font=FontBold, TextSize=CompactStyle.FieldTextSize, TextColor3=Theme.TextAccent,
                TextXAlignment=Enum.TextXAlignment.Right,
                Size=UDim2.new(0,rowWideControlW - 18,1,0), Position=UDim2.new(1,-30,0,0),
                BackgroundTransparency=1, Parent=hic,
            })

            -- Animated chevron frame
            local chevFrame = Create("Frame",{
                Size=UDim2.new(0,10,0,10),
                Position=UDim2.new(1,-10,0.5,-5),
                BackgroundTransparency=1, Parent=hic,
            })
            local chevLabel = Create("TextLabel",{
                Text="в–ј", Font=FontBold, TextSize=9, TextColor3=Theme.TextMuted,
                Size=UDim2.new(1,0,1,0), TextXAlignment=Enum.TextXAlignment.Center,
                BackgroundTransparency=1, Parent=chevFrame,
            })
            chevLabel.Text = "v"

            local function getLabel()
                if not multi then return sel or "" end
                local parts = {}
                for _, o in ipairs(opts) do if selSet[o] then table.insert(parts, o) end end
                data._Value = parts
                if #parts == 0 then return "None" end
                if #parts == 1 then return parts[1] end
                return parts[1] .. " +" .. (#parts-1)
            end

            local function refreshSelectionLabel()
                local labelText = getLabel()
                selLabel.Text = labelText
                local hasValue = multi and (#data._Value > 0) or (labelText ~= nil and labelText ~= "")
                if not multi and (labelText == nil or labelText == "") then
                    hasValue = false
                end
                selLabel.TextColor3 = hasValue and Theme.TextAccent or Theme.TextMuted
            end

            -- Separator line between header and list
            local sepLine = Create("Frame",{
                Size=UDim2.new(1,-16,0,1), Position=UDim2.new(0,8,0,baseH-1),
                BackgroundColor3=Theme.BorderLight, BorderSizePixel=0,
                BackgroundTransparency=1, Parent=wrapper,
            })

            local listFrame = Create("Frame",{
                Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,baseH),
                BackgroundTransparency=1, Parent=wrapper,
            })
            Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=listFrame})
            ApplyPadding(listFrame,2,2,5,5)

            local optBtns = {}
            for i, opt in ipairs(opts) do
                local isSel = multi and selSet[opt] or opt==def
                local ob = Create("Frame",{
                    Size=UDim2.new(1,0,0,itemH),
                BackgroundColor3=isSel and Theme.TabActiveBg or Theme.Surface3,
                    BorderSizePixel=0, LayoutOrder=i, Parent=listFrame,
                })
                ApplyCorner(ob,4)

                local selBar = Create("Frame",{
                    Size=UDim2.new(0,1,0.5,0), Position=UDim2.new(0,0,0.25,0),
                    BackgroundColor3=Theme.Accent, BorderSizePixel=0,
                    BackgroundTransparency=isSel and 0 or 1, Parent=ob,
                })
                ApplyCorner(selBar,1)

                -- Checkmark for multi
                local checkEl = nil
                if multi then
                    local cb2 = Create("Frame",{
                        Size=UDim2.new(0,12,0,12), Position=UDim2.new(1,-18,0.5,-6),
                        BackgroundColor3=isSel and Theme.Accent or Theme.Surface3,
                        BorderSizePixel=0, Parent=ob,
                    })
                    ApplyCorner(cb2,3); ApplyStroke(cb2,isSel and Theme.Accent or Theme.BorderLight,1)
                    if isSel then
                        Create("TextLabel",{Text="вњ“",Font=FontBold,TextSize=9,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=cb2})
                    end
                    if isSel then
                        for _, child in ipairs(cb2:GetChildren()) do
                            if child:IsA("TextLabel") or child:IsA("ImageLabel") then child:Destroy() end
                        end
                        CreateInlineCheck(cb2)
                    end
                    checkEl = cb2
                end

                local lbl = Create("TextLabel",{
                    Text=opt, Font=Font, TextSize=10,
                    TextColor3=isSel and Theme.TextAccent or Theme.TextSecondary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,multi and -28 or -14,1,0),
                    Position=UDim2.new(0,8,0,0),
                    BackgroundTransparency=1, Parent=ob,
                })

                local clickBtn = Create("TextButton",{Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+3,Parent=ob})

                clickBtn.MouseEnter:Connect(function()
                    local curSel = multi and selSet[opt] or opt==sel
                    if not curSel then TweenObject(ob,{BackgroundColor3=Theme.Surface3},0.08) end
                    TweenObject(lbl,{TextColor3=Theme.TextPrimary},0.08)
                end)
                clickBtn.MouseLeave:Connect(function()
                    local curSel = multi and selSet[opt] or opt==sel
                    TweenObject(ob,{BackgroundColor3=curSel and Theme.TabActiveBg or Theme.Surface3},0.1)
                    TweenObject(lbl,{TextColor3=curSel and Theme.TextAccent or Theme.TextSecondary},0.1)
                end)

                clickBtn.MouseButton1Click:Connect(function()
                    TweenObject(ob,{BackgroundColor3=AccentTint(Theme.Accent,0.16)},0.05)
                    task.delay(0.06,function()
                        if multi then
                            selSet[opt] = not selSet[opt]
                            local nowSel = selSet[opt]
                            TweenObject(ob,{BackgroundColor3=nowSel and Theme.TabActiveBg or Theme.Surface3},0.12)
                            TweenObject(lbl,{TextColor3=nowSel and Theme.TextAccent or Theme.TextSecondary},0.12)
                            TweenObject(selBar,{BackgroundTransparency=nowSel and 0 or 1},0.12)
                            if checkEl then
                                TweenObject(checkEl,{BackgroundColor3=nowSel and Theme.Accent or Theme.Surface3},0.12)
                                for _, ch in ipairs(checkEl:GetChildren()) do if ch:IsA("TextLabel") or ch:IsA("ImageLabel") then ch:Destroy() end end
                                if nowSel then Create("TextLabel",{Text="вњ“",Font=FontBold,TextSize=9,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=checkEl}) end
                            end
                            if checkEl and nowSel then
                                for _, ch in ipairs(checkEl:GetChildren()) do
                                    if ch:IsA("TextLabel") or ch:IsA("ImageLabel") then ch:Destroy() end
                                end
                                CreateInlineCheck(checkEl)
                            end
                            refreshSelectionLabel()
                            -- callback fires live on each toggle
                            local parts={}; for _,o in ipairs(opts) do if selSet[o] then table.insert(parts,o) end end
                            data._Value = parts; if cb then cb(parts) end
                        else
                            -- Single: update all
                            sel = opt; data._Value = opt; refreshSelectionLabel()
                            for _, bb in ipairs(optBtns) do
                                local isThis = bb._opt == opt
                                TweenObject(bb._frame,{BackgroundColor3=isThis and Theme.TabActiveBg or Theme.Surface3},0.12)
                                TweenObject(bb._lbl,{TextColor3=isThis and Theme.TextAccent or Theme.TextSecondary},0.12)
                                TweenObject(bb._bar,{BackgroundTransparency=isThis and 0 or 1},0.12)
                            end
                            if cb then cb(opt) end
                            -- Auto-collapse on single select
                            expanded = false
                            TweenObject(chevFrame,{Rotation=0},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                            TweenObject(sepLine,{BackgroundTransparency=1},0.12)
                            TweenObject(wrapper,{Size=UDim2.new(1,0,0,baseH)},0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                        end
                    end)
                end)

                table.insert(optBtns,{_opt=opt,_frame=ob,_lbl=lbl,_bar=selBar,_check=checkEl})
            end

            local totalH = baseH + #opts * (itemH+2) + 12
            local headerBtn = Create("TextButton",{Text="",Size=UDim2.new(1,0,0,baseH),BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+2,Parent=header})
            headerBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    TweenObject(chevFrame,{Rotation=180},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                    TweenObject(sepLine,{BackgroundTransparency=0.18},0.14)
                    TweenObject(wrapper,{Size=UDim2.new(1,0,0,totalH)},0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                else
                    TweenObject(chevFrame,{Rotation=0},0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                    TweenObject(sepLine,{BackgroundTransparency=1},0.12)
                    TweenObject(wrapper,{Size=UDim2.new(1,0,0,baseH)},0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                end
            end)

            function data:Set(v)
                if multi then
                    selSet = {}
                    if type(v)=="table" then for _, x in ipairs(v) do selSet[x]=true end end
                    -- BUG-B FIX: getLabel() updates data._Value as a side-effect, but call it
                    -- explicitly so _Value is correct even if selLabel is not yet visible.
                    local parts = {}
                    for _, o in ipairs(opts) do if selSet[o] then table.insert(parts, o) end end
                    data._Value = parts
                    refreshSelectionLabel()
                else sel=v; data._Value=v; refreshSelectionLabel() end
            end
            refreshSelectionLabel()
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) data:Set(v) end,
                    "dropdown"
                )
            end
            return data
        end

        --// ADDBUTTON
        function td:AddButton(bc)
            bc = bc or {}; local nm=bc.Name or "Button"; local cb=bc.Callback
            local item=Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.RowHeight),BackgroundColor3=Theme.Surface2,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local btn=Create("TextButton",{
                Text=nm,Font=FontBold,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,Parent=ic,
            })
            btn.MouseEnter:Connect(function()
                TweenObject(btn,{TextColor3=Theme.TextAccent},0.15)
            end)
            btn.MouseLeave:Connect(function()
                TweenObject(btn,{TextColor3=Theme.TextPrimary},0.18)
            end)
            btn.MouseButton1Click:Connect(function()
                TweenObject(item,{BackgroundColor3=AccentTint(Theme.Accent,0.12)},0.06)
                TweenObject(btn,{TextColor3=Theme.TextAccent},0.06)
                local stroke = item:FindFirstChildWhichIsA("UIStroke")
                if stroke then TweenObject(stroke,{Color=Theme.Accent,Thickness=1.2},0.06) end
                task.delay(0.1,function()
                    TweenObject(item,{BackgroundColor3=Theme.Surface3},0.25,Enum.EasingStyle.Quint)
                    TweenObject(btn,{TextColor3=Theme.TextAccent},0.25)
                    if stroke then TweenObject(stroke,{Color=Theme.BorderSoft,Thickness=1},0.3) end
                end)
                if cb then cb() end
            end)
            registerCommand(nm, "Button", function()
                if cb then cb() end
            end, "button run execute")
            return {_Frame=item,_Button=btn}
        end

        --// ADDTEXTBOX
        function td:AddTextBox(tbc)
            tbc = tbc or {}
            local nm  = tbc.Name        or "TextBox"
            local ph  = tbc.Placeholder or "Enter text..."
            local def = tbc.Default     or ""
            local cb  = tbc.Callback
            local multiLine = tbc.MultiLine or false
            local cfgFlag = tbc.Flag

            local h = multiLine and math.max(48, CompactStyle.TallRowHeight + 2) or CompactStyle.RowHeight
            local item=Create("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=Theme.Surface2,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,4,4,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)

            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local box
            if multiLine then
                Create("TextLabel",{
                    Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Parent=ic,
                })
                box=Create("TextBox",{
                    Text=def,PlaceholderText=ph,Font=Font,TextSize=CompactStyle.FieldTextSize,
                    TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,
                    Size=UDim2.new(1,0,0,26),
                    Position=UDim2.new(0,0,0,16),
                    BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
                    ClearTextOnFocus=false,TextWrapped=true,
                    MultiLine=true,Parent=ic,
                })
            else
                Create("TextLabel",{
                    Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,-(rowWideControlW + 8),1,0),BackgroundTransparency=1,Parent=ic,
                })
                box=Create("TextBox",{
                    Text=def,PlaceholderText=ph,Font=Font,TextSize=CompactStyle.FieldTextSize,
                    TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(0,rowWideControlW,0,rowControlH),
                    Position=UDim2.new(1,-rowWideControlW,0.5,rowControlY),
                    BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
                    ClearTextOnFocus=false,TextWrapped=false,
                    MultiLine=false,Parent=ic,
                })
            end
            ApplyCorner(box,4)
            local boxStroke = ApplyStroke(box,Theme.BorderSoft,1,0.22)
            ApplyPadding(box,2,2,multiLine and 4 or 8,multiLine and 4 or 8)

            -- Focus highlight вЂ” reuse stroke instead of creating new ones
            box.Focused:Connect(function()
                TweenObject(boxStroke,{Color=Theme.Accent},0.15)
                TweenObject(box,{BackgroundColor3=Theme.InputHoverBg},0.15)
            end)
            box.FocusLost:Connect(function()
                TweenObject(boxStroke,{Color=Theme.Border},0.15)
                TweenObject(box,{BackgroundColor3=Theme.InputBg},0.15)
                if cb then cb(box.Text) end
            end)

            local tdata = {_Box=box, Set=function(_,t) box.Text=t end, Get=function() return box.Text end}
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return box.Text end,
                    function(v) box.Text = tostring(v or "") end,
                    "textbox"
                )
            end
            registerCommand(nm, "Text", function()
                selectTab()
                task.defer(function()
                    if box and box.Parent then box:CaptureFocus() end
                end)
            end, "textbox input edit")
            return tdata
        end

        --// ADDCOLORPICKER (popup)
        function td:AddColorPicker(cc)
            cc = cc or {}; local nm=cc.Name or "Color"; local def=cc.Default or Theme.Accent; local cb=cc.Callback; local cfgFlag=cc.Flag
            local item=Create("Frame",{Size=UDim2.new(1,0,0,CompactStyle.RowHeight),BackgroundColor3=Theme.Surface2,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.Surface2, Theme.Surface3, true)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,-44,1,0),BackgroundTransparency=1,Parent=ic})
            local cBtn=Create("TextButton",{Text="",Size=UDim2.new(0,30,0,rowControlH),Position=UDim2.new(1,-30,0.5,rowControlY),BackgroundColor3=def,BorderSizePixel=0,Parent=ic})
            ApplyCorner(cBtn,4); ApplyStroke(cBtn,Theme.BorderSoft,1,0.2)
            local data={_Value=def}
            cBtn.MouseButton1Click:Connect(function()
                MIDNIGHT:_OpenColorPicker({
                    ButtonPos=item.AbsolutePosition,Current=cBtn.BackgroundColor3,
                    OnColor=function(c) cBtn.BackgroundColor3=c; data._Value=c; if cb then cb(c) end end,
                })
            end)
            function data:Set(c) cBtn.BackgroundColor3=c; data._Value=c; if cb then cb(c) end end
            -- Config system
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) if typeof(v)=="Color3" then data:Set(v) end end,
                    "color"
                )
            end
            registerCommand(nm, "Color", function()
                MIDNIGHT:_OpenColorPicker({
                    ButtonPos=item.AbsolutePosition,Current=cBtn.BackgroundColor3,
                    OnColor=function(c) cBtn.BackgroundColor3=c; data._Value=c; if cb then cb(c) end end,
                })
            end, "color picker")
            return data
        end

        --// ADDINLINECOLORPICKER (inline in tab, no popup)
        function td:AddInlineColorPicker(cc)
            cc = cc or {}; local nm=cc.Name or "Color"; local def=cc.Default or Theme.Accent; local cb=cc.Callback; local cfgFlag=cc.Flag

            local presets = {
                Color3.fromRGB(239,68,68),  Color3.fromRGB(245,158,11), Color3.fromRGB(234,179,8),
                Color3.fromRGB(34,197,94),  Color3.fromRGB(6,182,212),  Color3.fromRGB(96,190,255),
                Color3.fromRGB(56,128,255), Color3.fromRGB(255,255,255),Color3.fromRGB(188,194,204),
                Color3.fromRGB(116,123,136),Color3.fromRGB(66,72,82),   Color3.fromRGB(24,26,30),
            }
            local totalH = 138
            local item=Create("Frame",{
                Size=UDim2.new(1,0,0,totalH),BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.BorderSoft,1,0.24); ApplyPadding(item,4,4,10,10)

            Create("TextLabel",{Text=nm,Font=Font,TextSize=CompactStyle.BodyTextSize,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Parent=item})

            local grid=Create("Frame",{Size=UDim2.new(1,0,0,68),Position=UDim2.new(0,0,0,20),BackgroundTransparency=1,Parent=item})
            -- BUG-4 FIX: RelativeXX with X=0 makes cells zero-width (invisible/unclickable).
            -- Use absolute pixel size: 4 columns Г— 30px + 3 Г— 4px gap = 132px вЂ” fits the item width.
            Create("UIGridLayout",{CellSize=UDim2.new(0,28,0,20),CellPadding=UDim2.new(0,4,0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=grid})

            local currentColor = def
            local previewBtn
            local data={_Value=def}
            local rB, gB, bB

            local function syncInputs(c)
                if not c then return end
                if rB then rB.Text = tostring(math.floor(c.R*255 + 0.5)) end
                if gB then gB.Text = tostring(math.floor(c.G*255 + 0.5)) end
                if bB then bB.Text = tostring(math.floor(c.B*255 + 0.5)) end
            end

            local function applyColor(c, fireCb)
                currentColor = c
                data._Value = c
                syncInputs(c)
                if previewBtn then previewBtn.BackgroundColor3 = c end
                if fireCb and cb then cb(c) end
            end

            for i, c in ipairs(presets) do
                local pb=Create("TextButton",{Text="",BackgroundColor3=c,BorderSizePixel=0,LayoutOrder=i,Parent=grid})
                ApplyCorner(pb,3); ApplyStroke(pb,Theme.BorderLight,1)
                pb.MouseButton1Click:Connect(function()
                    applyColor(c, true)
                end)
            end

            local inputRow=Create("Frame",{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,92),BackgroundTransparency=1,Parent=item})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3),Parent=inputRow})

            local function mkInput(lbl,val,clr,lo)
                local ct=Create("Frame",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,LayoutOrder=lo,Parent=inputRow})
                Create("TextLabel",{Text=lbl,Font=FontBold,TextSize=8,TextColor3=clr,Size=UDim2.new(0,10,0,10),BackgroundTransparency=1,Parent=ct})
                local bx=Create("TextBox",{Text=tostring(val),Font=Font,TextSize=9,TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,Size=UDim2.new(0,34,0,18),Position=UDim2.new(0,12,0,0),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=ct})
                ApplyCorner(bx,3); ApplyStroke(bx,Theme.BorderSoft,1,0.22); return bx
            end

            rB=mkInput("R",math.floor(def.R*255),Color3.fromRGB(255,80,80),1)
            gB=mkInput("G",math.floor(def.G*255),Color3.fromRGB(80,255,80),2)
            bB=mkInput("B",math.floor(def.B*255),Color3.fromRGB(80,80,255),3)

            previewBtn=Create("TextButton",{
                Text="",Size=UDim2.new(0,24,0,18),
                BackgroundColor3=def,BorderSizePixel=0,LayoutOrder=4,Parent=inputRow,
            })
            ApplyCorner(previewBtn,4); ApplyStroke(previewBtn,Theme.BorderLight,1)

            local applyBtn2=Create("TextButton",{Text="Apply",Font=FontBold,TextSize=9,TextColor3=Theme.TextAccent,Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,118),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=item})
            ApplyCorner(applyBtn2,4); ApplyStroke(applyBtn2,Theme.BorderSoft,1,0.22)
            applyBtn2.MouseButton1Click:Connect(function()
                local r=math.clamp(math.floor(tonumber(rB.Text) or 0),0,255)
                local g=math.clamp(math.floor(tonumber(gB.Text) or 0),0,255)
                local b=math.clamp(math.floor(tonumber(bB.Text) or 0),0,255)
                local c=Color3.fromRGB(r,g,b)
                applyColor(c, true)
            end)

            function data:Set(c) applyColor(c, true) end
            if cfgFlag then
                MIDNIGHT:_RegCfgWidget(cfgFlag,
                    function() return data._Value end,
                    function(v) if typeof(v)=="Color3" then applyColor(v, false) end end,
                    "color"
                )
            end
            return data
        end

        --// ADDINPUT (legacy alias for AddTextBox)
        function td:AddInput(ic2)
            ic2 = ic2 or {}
            return self:AddTextBox({
                Name=ic2.Name, Placeholder=ic2.Placeholder, Callback=ic2.Callback,
                Default=ic2.Default or "", MultiLine=false,
            })
        end

        --// ADDTABLE  (v7.1)
        --[[
            DataGrid widget with sortable columns, optional search, and pagination.

            Config fields:
              Name        string          Widget label (shown as section header)
              Columns     {string,...}    Column header names (required)
              Rows        {{string,...}}  Initial row data (optional)
              RowHeight   number          Pixel height per row (default 24)
              MaxVisible  number          Rows visible without scrolling (default 8)
              Searchable  bool            Show search box above table (default false)
              Flag        string          Config system flag key (optional)

            Returned object methods:
              :SetRows(rows)             Replace all rows
              :AddRow(row)               Append one row
              :RemoveRow(index)          Remove row by 1-based index
              :GetRows()                 Return current rows table
              :SetColumnWidth(col, px)   Override column pixel width
              :Clear()                   Remove all rows
        ]]
        function td:AddTable(tc)
            tc = tc or {}
            local nm        = tc.Name       or "Table"
            local cols      = tc.Columns    or {"Col1","Col2"}
            local initRows  = tc.Rows       or {}
            local rowH      = tc.RowHeight  or 24
            local maxVis    = tc.MaxVisible or 8
            local searchable= tc.Searchable or false
            local flag      = tc.Flag

            local ncols = #cols
            local colWidths = {}  -- px overrides; nil = equal distribution
            for i=1,ncols do colWidths[i] = nil end

            -- Helper: compute absolute col widths given container px width
            local function resolveWidths(totalPx)
                local fixed, flexCount = 0, 0
                for i=1,ncols do
                    if colWidths[i] then fixed=fixed+colWidths[i] else flexCount=flexCount+1 end
                end
                local flexW = flexCount>0 and math.floor((totalPx-fixed)/flexCount) or 0
                local ws = {}
                for i=1,ncols do ws[i] = colWidths[i] or flexW end
                return ws
            end

            -- в”Ђв”Ђ outer frame в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local totalH = 28
                + (searchable and 34 or 0)
                + 30
                + rowH * maxVis
                + 10

            local outer = Create("Frame",{
                Size=UDim2.new(1,0,0,totalH),
                BackgroundColor3=Theme.Surface1,
                BorderSizePixel=0,
                LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(outer, 6)
            ApplyStroke(outer, Theme.BorderSoft, 1, 0.22)

            -- Section label
            local sLbl = Create("TextLabel",{
                Text=nm, Font=FontBold, TextSize=CompactStyle.SectionTextSize,
                TextColor3=Theme.TextSecondary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,-16,0,14),
                Position=UDim2.new(0,8,0,8),
                BackgroundTransparency=1, Parent=outer,
            })

            local yOff = 26

            -- Search box
            local searchText = ""
            local rebuild
            if searchable then
                local sBox = Create("TextBox",{
                    Text="", PlaceholderText="рџ”Ќ  Search...",
                    Font=Font, TextSize=CompactStyle.FieldTextSize, TextColor3=Theme.TextPrimary,
                    PlaceholderColor3=Theme.TextMuted,
                    Size=UDim2.new(1,-16,0,24),
                    Position=UDim2.new(0,8,0,yOff),
                    BackgroundColor3=Theme.Surface2, BorderSizePixel=0,
                    ClearTextOnFocus=false, Parent=outer,
                })
                StyleInputField(sBox, 4, Theme.BorderSoft)
                ApplyPadding(sBox,0,0,8,8)
                sBox.PlaceholderText = "Search..."
                sBox:GetPropertyChangedSignal("Text"):Connect(function()
                    searchText=sBox.Text:lower()
                    rebuild()
                end)
                yOff = yOff + 32
            end

            -- в”Ђв”Ђ header row в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local headerFrame = Create("Frame",{
                Size=UDim2.new(1,-16,0,28),
                Position=UDim2.new(0,8,0,yOff),
                BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0, Parent=outer,
            })
            ApplyCorner(headerFrame,6)
            ApplyStroke(headerFrame,Theme.BorderSoft,1,0.2)

            -- в”Ђв”Ђ scrolling body в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local bodyScroll = Create("ScrollingFrame",{
                Size=UDim2.new(1,-16,0,rowH*maxVis),
                Position=UDim2.new(0,8,0,yOff+30),
                BackgroundColor3=Theme.Surface0,
                BorderSizePixel=0,
                ScrollBarThickness=3,
                ScrollBarImageColor3=Theme.ScrollBarColor,
                AutomaticCanvasSize=Enum.AutomaticSize.Y,
                ZIndex=ZIndex.CONTENT, Parent=outer,
            })
            ApplyCorner(bodyScroll,6)
            ApplyStroke(bodyScroll,Theme.BorderSoft,1,0.18)
            ApplyPadding(bodyScroll,2,2,2,2)

            -- в”Ђв”Ђ data state в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local allRows     = {}  -- master copy
            local sortCol     = nil -- 1-based or nil
            local sortAsc     = true
            local headerCells = {}  -- TextLabel refs for sort indicators

            -- Shallow-copy + filter + sort into display list
            local function getDisplayRows()
                local disp = {}
                for _, row in ipairs(allRows) do
                    if searchText == "" then
                        disp[#disp+1] = row
                    else
                        for _, cell in ipairs(row) do
                            if tostring(cell):lower():find(searchText, 1, true) then
                                disp[#disp+1] = row; break
                            end
                        end
                    end
                end
                if sortCol then
                    table.sort(disp, function(a,b)
                        local av = tostring(a[sortCol] or "")
                        local bv = tostring(b[sortCol] or "")
                        -- numeric-aware compare
                        local na, nb = tonumber(av), tonumber(bv)
                        if na and nb then
                            return sortAsc and na<nb or na>nb
                        end
                        return sortAsc and av<bv or av>bv
                    end)
                end
                return disp
            end

            -- в”Ђв”Ђ row rendering в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local rowFrames = {}

            rebuild = function()  -- upvalue; referenced by search box closure above
                -- Clear old row frames
                for _, rf in ipairs(rowFrames) do
                    pcall(function() rf:Destroy() end)
                end
                rowFrames = {}

                local disp   = getDisplayRows()
                local contW  = bodyScroll.AbsoluteSize.X
                if contW < 10 then contW = 400 end -- fallback before first layout
                local ws     = resolveWidths(contW)

                for ri, row in ipairs(disp) do
                    local even = (ri % 2 == 0)
                    local rf = Create("Frame",{
                        Size=UDim2.new(1,0,0,rowH),
                        BackgroundColor3=even and Theme.Surface1 or Theme.Surface2,
                        BorderSizePixel=0,
                        LayoutOrder=ri, Parent=bodyScroll,
                    })
                    ApplyCorner(rf,4)
                    rowFrames[ri] = rf

                    -- Hover effect
                    rf.MouseEnter:Connect(function()
                        TweenObject(rf,{BackgroundColor3=Theme.Surface3},0.1)
                    end)
                    rf.MouseLeave:Connect(function()
                        TweenObject(rf,{BackgroundColor3=even and Theme.Surface1 or Theme.Surface2},0.1)
                    end)

                    local xOff = 0
                    for ci=1,ncols do
                        local cw = ws[ci]
                        local cellVal = tostring(row[ci] or "")
                        Create("TextLabel",{
                            Text=cellVal,
                            Font=Font, TextSize=CompactStyle.MetaTextSize,
                            TextColor3=Theme.TextPrimary,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd,
                            Size=UDim2.new(0,cw-10,1,0),
                            Position=UDim2.new(0,xOff+5,0,0),
                            BackgroundTransparency=1,
                            ZIndex=ZIndex.CONTENT+1, Parent=rf,
                        })
                        -- Column divider (except last)
                        if ci < ncols then
                            Create("Frame",{
                                Size=UDim2.new(0,1,0,rowH-8),
                                Position=UDim2.new(0,xOff+cw-1,0,4),
                                BackgroundColor3=Theme.BorderSoft,
                                BorderSizePixel=0, Parent=rf,
                            })
                        end
                        xOff = xOff + cw
                    end
                end

                -- Also update header sort indicators
                for ci, lbl in ipairs(headerCells) do
                    if sortCol == ci then
                        lbl.Text = cols[ci]..(sortAsc and " в†‘" or " в†“")
                        lbl.Text = cols[ci]..(sortAsc and " ^" or " v")
                        lbl.TextColor3 = Theme.TextAccent
                    else
                        lbl.Text = cols[ci]
                        lbl.TextColor3 = Theme.TextSecondary
                    end
                end
            end

            -- в”Ђв”Ђ build header cells в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            -- We defer actual width calc until after frame exists;
            -- use equal UDim2 fractions for header (always correct)
            local fracW = 1/ncols
            for ci=1,ncols do
                local hBtn = Create("TextButton",{
                    Text=cols[ci],
                    Font=FontBold, TextSize=CompactStyle.MetaTextSize,
                    TextColor3=Theme.TextSecondary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(fracW, ci==ncols and 0 or -1, 1, 0),
                    Position=UDim2.new(fracW*(ci-1),6,0,0),
                    BackgroundTransparency=1,
                    ZIndex=ZIndex.CONTENT+1, Parent=headerFrame,
                })
                headerCells[ci] = hBtn
                -- Column divider
                if ci < ncols then
                    Create("Frame",{
                        Size=UDim2.new(0,1,0,16),
                        Position=UDim2.new(fracW*ci,-1,0.5,-8),
                        BackgroundColor3=Theme.BorderSoft,
                        BorderSizePixel=0, Parent=headerFrame,
                    })
                end
                local col_ci = ci  -- capture
                hBtn.MouseButton1Click:Connect(function()
                    if sortCol == col_ci then
                        sortAsc = not sortAsc
                    else
                        sortCol = col_ci; sortAsc = true
                    end
                    rebuild()
                end)
                hBtn.MouseEnter:Connect(function()
                    TweenObject(hBtn,{TextColor3=Theme.AccentHover},0.1)
                end)
                hBtn.MouseLeave:Connect(function()
                    local c = sortCol==col_ci and Theme.Accent or Theme.TextSecondary
                    TweenObject(hBtn,{TextColor3=c},0.1)
                end)
            end

            -- Insert initial rows
            for _, row in ipairs(initRows) do
                allRows[#allRows+1] = row
            end

            -- First render (deferred so AbsoluteSize is valid)
            task.defer(rebuild)

            -- Rebuild on resize
            RegConn(bodyScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                task.defer(rebuild)
            end))

            -- в”Ђв”Ђ public API в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
            local tdata = {}

            function tdata:SetRows(rows)
                allRows = {}
                for _, r in ipairs(rows) do allRows[#allRows+1] = r end
                rebuild()
            end

            function tdata:AddRow(row)
                allRows[#allRows+1] = row
                rebuild()
            end

            function tdata:RemoveRow(index)
                table.remove(allRows, index)
                rebuild()
            end

            function tdata:GetRows()
                local copy = {}
                for i,r in ipairs(allRows) do copy[i]=r end
                return copy
            end

            function tdata:Clear()
                allRows = {}; rebuild()
            end

            function tdata:SetColumnWidth(col, px)
                colWidths[col] = px
                task.defer(rebuild)
            end

            -- Config system integration
            if flag then
                MIDNIGHT:_RegCfgWidget(flag,
                    function() return tdata:GetRows() end,
                    function(v)
                        if type(v) == "table" then tdata:SetRows(v) end
                    end,
                    "table"
                )
            end

            return tdata
        end -- AddTable

        return td
    end -- end MakeTab

    --// FLOATING WINDOW
    function wd:MakeFloatingWindow(fc)
        fc = fc or {}; local nm=fc.Name or "Window"; local sz=fc.Size or {300,300}; local canResize=fc.Resizable
        local curFW, curFH = sz[1], sz[2]
        local fw=Create("Frame",{
            Name=_RandomGuiName(),Size=UDim2.new(0,sz[1],0,sz[2]),
            Position=UDim2.new(0.5,-sz[1]/2,0.5,-sz[2]/2),
            BackgroundColor3=Theme.OverlayBg,BorderSizePixel=0,ClipsDescendants=true,
            Visible=false,ZIndex=ZIndex.POPUP,Parent=MIDNIGHT._ScreenGui,
        })
        StyleUtilityOverlay(fw, Theme.Accent)

        local ftb=StyleQuietHeader(fw, CompactStyle.OverlayHeaderHeight, ZIndex.POPUP+1)
        Create("TextLabel",{Text=nm,Font=FontBold,TextSize=CompactStyle.FloatingTitleSize,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,-46,1,0),Position=UDim2.new(0,10,0,0),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=ZIndex.POPUP+2,Parent=ftb})

        local fwClose=Create("TextButton",{Text="",Size=UDim2.new(0,20,0,14),Position=UDim2.new(1,-24,0,7),BackgroundColor3=Theme.CloseNormal,BorderSizePixel=0,ZIndex=ZIndex.POPUP+3,Parent=ftb})
        ApplyCorner(fwClose,4)
        Create("Frame",{Size=UDim2.new(0,7,0,1),Position=UDim2.new(0.5,-3,0.5,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=45,Parent=fwClose})
        Create("Frame",{Size=UDim2.new(0,7,0,1),Position=UDim2.new(0.5,-3,0.5,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=fwClose})
        ApplyHoverEffect(fwClose,Theme.CloseNormal,Theme.CloseHover,false)

        local fScroll=Create("ScrollingFrame",{Size=UDim2.new(1,-10,1,-(CompactStyle.OverlayHeaderHeight+8)),Position=UDim2.new(0,5,0,CompactStyle.OverlayHeaderHeight+3),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=Theme.ScrollBarColor,AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=ZIndex.POPUP+1,Parent=fw})
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=fScroll})
        ApplyPadding(fScroll,4,4,5,5)

        MakeDraggable(fw,ftb,function() MIDNIGHT:_CloseAllPopups() end)

        local fData={
            _Frame=fw,
            _Scroll=fScroll,
            _Visible=false,
            _Destroyed=false,
            _OwnerWindow=self,
            _OnDestroyCallbacks={},
        }
        local destroyCallbacksRun = false
        local function runDestroyCallbacks()
            if destroyCallbacksRun then return end
            destroyCallbacksRun = true
            for _, cb in ipairs(fData._OnDestroyCallbacks) do
                pcall(cb)
            end
            fData._OnDestroyCallbacks = {}
        end

        function fData:IsAlive()
            return not self._Destroyed and self._Frame and self._Frame.Parent ~= nil
        end

        function fData:Show()
            if self._Destroyed or not self._Frame then return end
            self._Visible = true
            if not fw.Visible then
                fw.Size = UDim2.new(0, 0, 0, 0)
            end
            fw.Visible = true
            fw.BackgroundTransparency = 1
            TweenMotion(fw,{Size=UDim2.new(0,curFW,0,curFH)},"Panel")
            TweenMotion(fw,{BackgroundTransparency=0},"Soft")
        end

        function fData:Hide()
            if self._Destroyed or not self._Frame then return end
            if not self._Visible and not fw.Visible then return end
            self._Visible = false
            TweenObject(fw,{Size=UDim2.new(0,0,0,0)},Motion.OverlayOut.Duration,Motion.OverlayOut.Style,Motion.OverlayOut.Direction)
            TweenMotion(fw,{BackgroundTransparency=1},"OverlayOut")
            task.delay(0.25,function() if not self._Visible and fw.Parent then fw.Visible=false end end)
        end

        function fData:OnDestroy(cb)
            if typeof(cb) == "function" then
                self._OnDestroyCallbacks[#self._OnDestroyCallbacks + 1] = cb
            end
            return cb
        end

        function fData:Destroy()
            if self._Destroyed then return end
            self._Destroyed = true
            self._Visible = false
            runDestroyCallbacks()
            if self._OwnerWindow and self._OwnerWindow._FloatingWindows then
                for i = #self._OwnerWindow._FloatingWindows, 1, -1 do
                    if self._OwnerWindow._FloatingWindows[i] == self then
                        table.remove(self._OwnerWindow._FloatingWindows, i)
                        break
                    end
                end
            end
            if self._Frame then
                pcall(function() self._Frame:Destroy() end)
            end
            self._Frame = nil
            self._Scroll = nil
        end

        fw.Destroying:Connect(function()
            fData._Destroyed = true
            fData._Visible = false
            runDestroyCallbacks()
            if fData._OwnerWindow and fData._OwnerWindow._FloatingWindows then
                for i = #fData._OwnerWindow._FloatingWindows, 1, -1 do
                    if fData._OwnerWindow._FloatingWindows[i] == fData then
                        table.remove(fData._OwnerWindow._FloatingWindows, i)
                        break
                    end
                end
            end
            fData._Frame = nil
            fData._Scroll = nil
        end)

        fwClose.MouseButton1Click:Connect(function() fData:Hide() end)

        function fData:Toggle()
            if self._Visible then
                self:Hide()
            else
                self:Show()
            end
        end

        function fData:AddLine(text,color)
            local row=Create("Frame",{
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0,
                ZIndex=ZIndex.POPUP+2,
                Parent=fScroll
            })
            ApplyCorner(row,5)
            ApplyStroke(row,Theme.BorderSoft,1,0.34)
            ApplyPadding(row,6,6,8,8)
            Create("TextLabel",{
                Text=text or "",
                Font=FontRegular,
                TextSize=CompactStyle.FloatingLineSize,
                TextColor3=color or Theme.TextSecondary,
                TextXAlignment=Enum.TextXAlignment.Left,
                TextYAlignment=Enum.TextYAlignment.Top,
                TextWrapped=true,
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                ZIndex=ZIndex.POPUP+3,
                Parent=row
            })
            return row
        end
        function fData:AddRichLine(name,text,nameColor,textColor)
            local row=Create("Frame",{
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=Theme.Surface2,
                BorderSizePixel=0,
                ZIndex=ZIndex.POPUP+2,
                Parent=fScroll
            })
            ApplyCorner(row,5)
            ApplyStroke(row,Theme.BorderSoft,1,0.34)
            local rail = Create("Frame",{
                Size=UDim2.new(0,2,1,-10),
                Position=UDim2.new(0,5,0,5),
                BackgroundColor3=nameColor or Theme.UtilityAccent,
                BorderSizePixel=0,
                ZIndex=ZIndex.POPUP+3,
                Parent=row,
            })
            ApplyCorner(rail,1)
            local content=Create("Frame",{
                Size=UDim2.new(1,-16,0,0),
                Position=UDim2.new(0,12,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                ZIndex=ZIndex.POPUP+3,
                Parent=row
            })
            ApplyPadding(content,6,6,4,6)
            Create("UIListLayout",{
                SortOrder=Enum.SortOrder.LayoutOrder,
                Padding=UDim.new(0,2),
                Parent=content
            })
            Create("TextLabel",{
                Text=name,
                Font=FontBold,
                TextSize=CompactStyle.UtilityMetaSize,
                TextColor3=nameColor or Theme.UtilityAccent,
                Size=UDim2.new(1,0,0,12),
                TextXAlignment=Enum.TextXAlignment.Left,
                BackgroundTransparency=1,
                ZIndex=ZIndex.POPUP+4,
                Parent=content
            })
            Create("TextLabel",{
                Text=text,
                Font=FontRegular,
                TextSize=CompactStyle.FloatingLineSize,
                TextColor3=textColor or Theme.TextSecondary,
                TextXAlignment=Enum.TextXAlignment.Left,
                TextYAlignment=Enum.TextYAlignment.Top,
                TextWrapped=true,
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                ZIndex=ZIndex.POPUP+4,
                Parent=content
            })
            return row
        end
        function fData:Clear()
            for _,ch in ipairs(fScroll:GetChildren()) do
                if ch:IsA("Frame") or ch:IsA("TextLabel") then ch:Destroy() end
            end
        end

        if canResize then
            local rh=Create("TextButton",{Text="",Size=UDim2.new(0,16,0,16),Position=UDim2.new(1,-16,1,-16),BackgroundTransparency=1,ZIndex=ZIndex.POPUP+4,Parent=fw})
            Create("Frame",{Size=UDim2.new(0,8,0,1),Position=UDim2.new(0.5,-4,0.8,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=rh})
            Create("Frame",{Size=UDim2.new(0,5,0,1),Position=UDim2.new(0.5,-2,0.5,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=rh})
            local resDrag=false; local resStart,resStartSize; local resEndConn=nil
            rh.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                    if resEndConn then
                        resEndConn:Disconnect()
                        resEndConn = nil
                    end
                    resDrag=true; resStart=inp.Position; resStartSize=fw.Size
                    resEndConn = inp.Changed:Connect(function()
                        if inp.UserInputState==Enum.UserInputState.End then
                            resDrag=false
                            if resEndConn then
                                resEndConn:Disconnect()
                                resEndConn = nil
                            end
                        end
                    end)
                end
            end)
            RegConn(UserInputService.InputChanged:Connect(function(inp)
                if resDrag and inp.UserInputType==Enum.UserInputType.MouseMovement then
                    local d=inp.Position-resStart
                    curFW = math.max(200,resStartSize.X.Offset+d.X)
                    curFH = math.max(150,resStartSize.Y.Offset+d.Y)
                    fw.Size=UDim2.new(0,curFW,0,curFH)
                end
            end))
        end

        table.insert(self._FloatingWindows,fData)
        return fData
    end

    function wd:CreateCommandPalette(config)
        if self._CommandPalette and self._CommandPalette.IsAlive and self._CommandPalette:IsAlive() then
            return self._CommandPalette
        end

        config = config or {}
        MIDNIGHT:_InitScreenGui()

        local paletteW = math.max(360, math.floor(tonumber(config.Width) or 420))
        local paletteH = math.max(260, math.floor(tonumber(config.Height) or 320))
        local scrim = Create("Frame",{
            Name=_RandomGuiName(),
            Size=UDim2.new(1,0,1,0),
            BackgroundColor3=Theme.Shadow,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Visible=false,
            ZIndex=ZIndex.OVERLAY + 10,
            Parent=MIDNIGHT._ScreenGui,
        })
        local pf = Create("Frame",{
            Name=_RandomGuiName(),
            Size=UDim2.new(0,paletteW,0,paletteH),
            Position=UDim2.new(0.5,-paletteW/2,0.5,-paletteH/2),
            BackgroundColor3=Theme.OverlayBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Visible=false,
            ZIndex=ZIndex.OVERLAY + 12,
            Parent=MIDNIGHT._ScreenGui,
        })
        StyleUtilityOverlay(pf, Theme.Accent)
        local pfScale = Create("UIScale",{Scale=0.985,Parent=pf})

        local header = StyleQuietHeader(pf, CompactStyle.OverlayHeaderHeight, ZIndex.OVERLAY + 13)
        CreateIconOrText(header,"search",nil,UDim2.new(0,12,0,12),UDim2.new(0,10,0.5,-6),Theme.UtilityAccent,FontBold,10)
        Create("TextLabel",{
            Text="Command Palette",
            Font=FontBold,
            TextSize=11,
            TextColor3=Theme.TextPrimary,
            Size=UDim2.new(1,-20,1,0),
            Position=UDim2.new(0,28,0,0),
            TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1,
            ZIndex=ZIndex.OVERLAY + 14,
            Parent=header,
        })

        local body = Create("Frame",{
            Size=UDim2.new(1,-12,1,-(CompactStyle.OverlayHeaderHeight+10)),
            Position=UDim2.new(0,6,0,CompactStyle.OverlayHeaderHeight+4),
            BackgroundTransparency=1,
            ZIndex=ZIndex.OVERLAY + 13,
            Parent=pf,
        })

        local searchBox = Create("TextBox",{
            Text="",
            PlaceholderText="Search tabs, buttons, toggles...",
            Font=Font,
            TextSize=CompactStyle.FieldTextSize,
            TextColor3=Theme.TextPrimary,
            PlaceholderColor3=Theme.TextMuted,
            Size=UDim2.new(1,0,0,26),
            BackgroundColor3=Theme.Surface2,
            BorderSizePixel=0,
            ClearTextOnFocus=false,
            ZIndex=ZIndex.OVERLAY + 14,
            Parent=body,
        })
        local searchStroke = StyleInputField(searchBox, 5, Theme.BorderSoft)
        ApplyPadding(searchBox,0,0,10,10)

        local list = Create("ScrollingFrame",{
            Size=UDim2.new(1,0,1,-52),
            Position=UDim2.new(0,0,0,34),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ScrollBarThickness=3,
            ScrollBarImageColor3=Theme.ScrollBarColor,
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ZIndex=ZIndex.OVERLAY + 13,
            Parent=body,
        })
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=list})
        ApplyPadding(list,0,4,0,0)

        Create("TextLabel",{
            Text="ENTER run   ESC close   ; toggle",
            Font=FontRegular,
            TextSize=CompactStyle.UtilityMetaSize,
            TextColor3=Theme.TextMuted,
            TextXAlignment=Enum.TextXAlignment.Right,
            Size=UDim2.new(1,0,0,12),
            Position=UDim2.new(0,0,1,-12),
            BackgroundTransparency=1,
            ZIndex=ZIndex.OVERLAY + 14,
            Parent=body,
        })

        local emptyLabel = Create("TextLabel",{
            Text="No matching commands",
            Font=FontRegular,
            TextSize=CompactStyle.BodyTextSize,
            TextColor3=Theme.TextMuted,
            Size=UDim2.new(1,0,0,18),
            BackgroundTransparency=1,
            Visible=false,
            ZIndex=ZIndex.OVERLAY + 14,
            Parent=list,
        })

        local palette = {
            _Frame=pf,
            _Scrim=scrim,
            _Body=body,
            _Search=searchBox,
            _List=list,
            _Visible=false,
            _Destroyed=false,
            _OwnerWindow=self,
            _Key=Enum.KeyCode.Semicolon,
            _BindConn=nil,
            _OutsideConn=nil,
            _FirstCommand=nil,
        }
        self._CommandPalette = palette

        local function clearRows()
            for _, ch in ipairs(list:GetChildren()) do
                if ch:IsA("Frame") then
                    ch:Destroy()
                end
            end
        end

        local function scoreCommand(cmd, query)
            local hay = string.lower((cmd.Title or "") .. " " .. (cmd.Subtitle or "") .. " " .. (cmd.Search or ""))
            if query == "" then return 1 end
            local pos = hay:find(query, 1, true)
            if not pos then return nil end
            return pos
        end

        function palette:IsAlive()
            return not self._Destroyed and self._Frame and self._Frame.Parent ~= nil
        end

        function palette:Refresh(query)
            if self._Destroyed then return end
            query = string.lower(tostring(query or ""))
            self._FirstCommand = nil
            clearRows()

            local matches = {}
            for _, cmd in ipairs(self._OwnerWindow:_CollectCommands()) do
                local score = scoreCommand(cmd, query)
                if score then
                    matches[#matches + 1] = {Cmd = cmd, Score = score}
                end
            end
            table.sort(matches, function(a, b)
                if a.Score == b.Score then
                    return tostring(a.Cmd.Title or "") < tostring(b.Cmd.Title or "")
                end
                return a.Score < b.Score
            end)

            emptyLabel.Visible = #matches == 0
            if #matches == 0 then return end

            for index, entry in ipairs(matches) do
                if index > 30 then break end
                local cmd = entry.Cmd
                if index == 1 then
                    self._FirstCommand = cmd
                end
                local row = Create("Frame",{
                    Size=UDim2.new(1,0,0,40),
                    BackgroundColor3=index == 1 and AccentTint(Theme.Accent,0.12) or Theme.Surface2,
                    BorderSizePixel=0,
                    LayoutOrder=index,
                    ZIndex=ZIndex.OVERLAY + 14,
                    Parent=list,
                })
                ApplyCorner(row,6)
                ApplyStroke(row, index == 1 and Theme.AccentMuted or Theme.BorderSoft, 1, index == 1 and 0.22 or 0.38)

                Create("TextLabel",{
                    Text=cmd.Title or "Command",
                    Font=FontBold,
                    TextSize=CompactStyle.BodyTextSize,
                    TextColor3=Theme.TextPrimary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,-18,0,16),
                    Position=UDim2.new(0,9,0,6),
                    BackgroundTransparency=1,
                    ZIndex=ZIndex.OVERLAY + 15,
                    Parent=row,
                })
                Create("TextLabel",{
                    Text=cmd.Subtitle or "",
                    Font=FontRegular,
                    TextSize=CompactStyle.UtilityMetaSize,
                    TextColor3=Theme.TextMuted,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(1,-18,0,12),
                    Position=UDim2.new(0,9,0,22),
                    BackgroundTransparency=1,
                    ZIndex=ZIndex.OVERLAY + 15,
                    Parent=row,
                })
                local click = Create("TextButton",{
                    Text="",
                    Size=UDim2.new(1,0,1,0),
                    BackgroundTransparency=1,
                    ZIndex=ZIndex.OVERLAY + 16,
                    Parent=row,
                })
                click.MouseEnter:Connect(function()
                    TweenObject(row,{BackgroundColor3=AccentTint(Theme.Accent,0.16)},0.12)
                end)
                click.MouseLeave:Connect(function()
                    TweenObject(row,{BackgroundColor3=index == 1 and AccentTint(Theme.Accent,0.12) or Theme.Surface2},0.14)
                end)
                click.MouseButton1Click:Connect(function()
                    self:Close()
                    if cmd.Action then cmd.Action() end
                end)
            end
        end

        function palette:Open(prefill)
            if self._Destroyed then return end
            self._Visible = true
            if scrim then
                scrim.Visible = true
                scrim.BackgroundTransparency = 1
            end
            pf.Visible = true
            pf.BackgroundTransparency = 1
            pfScale.Scale = 0.985
            if prefill ~= nil then
                searchBox.Text = tostring(prefill)
            end
            self:Refresh(searchBox.Text)
            if scrim then
                TweenObject(scrim,{BackgroundTransparency=0.44},0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
            end
            TweenMotion(pf,{BackgroundTransparency=0},"OverlayIn")
            TweenMotion(pfScale,{Scale=1},"OverlayIn")
            if searchStroke then TweenObject(searchStroke,{Transparency=0.22},0.18) end
            task.defer(function()
                if searchBox and searchBox.Parent then
                    searchBox:CaptureFocus()
                end
            end)
            if self._OutsideConn then
                SafeDisconnect(self._OutsideConn)
            end
            self._OutsideConn = RegConn(UserInputService.InputBegan:Connect(function(input, gp)
                if gp or not self._Visible then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and pf and pf.Parent then
                    local mp = UserInputService:GetMouseLocation()
                    local pp, ps = pf.AbsolutePosition, pf.AbsoluteSize
                    if mp.X < pp.X or mp.X > pp.X + ps.X or mp.Y < pp.Y or mp.Y > pp.Y + ps.Y then
                        self:Close()
                    end
                elseif input.KeyCode == Enum.KeyCode.Escape then
                    self:Close()
                elseif input.KeyCode == Enum.KeyCode.Return and self._FirstCommand and UserInputService:GetFocusedTextBox() == searchBox then
                    local cmd = self._FirstCommand
                    self:Close()
                    if cmd.Action then cmd.Action() end
                end
            end))
        end

        function palette:Close()
            if self._Destroyed or not self._Visible then return end
            self._Visible = false
            SafeDisconnect(self._OutsideConn)
            self._OutsideConn = nil
            if scrim then
                TweenObject(scrim,{BackgroundTransparency=1},0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
            end
            TweenMotion(pf,{BackgroundTransparency=1},"OverlayOut")
            TweenMotion(pfScale,{Scale=0.985},"OverlayOut")
            task.delay(0.2,function()
                if not self._Visible and scrim and scrim.Parent then
                    scrim.Visible = false
                end
                if not self._Visible and pf.Parent then
                    pf.Visible = false
                end
            end)
        end

        function palette:Toggle()
            if self._Visible then
                self:Close()
            else
                self:Open("")
            end
        end

        function palette:Bind(keyStr)
            self._Key = ParseKeyCode(keyStr or "Semicolon")
            SafeDisconnect(self._BindConn)
            self._BindConn = RegConn(UserInputService.InputBegan:Connect(function(input, gp)
                if gp or self._Destroyed then return end
                if input.KeyCode == self._Key then
                    self:Toggle()
                end
            end))
            return self
        end

        function palette:Destroy()
            if self._Destroyed then return end
            self._Destroyed = true
            self._Visible = false
            SafeDisconnect(self._BindConn)
            SafeDisconnect(self._OutsideConn)
            self._BindConn = nil
            self._OutsideConn = nil
            if self._OwnerWindow and self._OwnerWindow._CommandPalette == self then
                self._OwnerWindow._CommandPalette = nil
            end
            if pf then
                pcall(function() pf:Destroy() end)
            end
            if scrim then
                pcall(function() scrim:Destroy() end)
            end
            self._Frame = nil
        end

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            palette:Refresh(searchBox.Text)
        end)

        if config.Key then
            palette:Bind(config.Key)
        end
        return palette
    end

    function wd:BindCommandPalette(keyStr)
        local palette = self:CreateCommandPalette()
        palette:Bind(keyStr or "Semicolon")
        return palette
    end

    function wd:CreateAdminPresenceWidget(config)
        if self._AdminPresenceWidget and self._AdminPresenceWidget.IsAlive and self._AdminPresenceWidget:IsAlive() then
            if config and config.LogsWindow then
                self._AdminPresenceWidget:SetLogsWindow(config.LogsWindow)
            end
            return self._AdminPresenceWidget
        end

        config = config or {}
        MIDNIGHT:_InitScreenGui()

        local widgetW = math.max(348, math.floor(tonumber(config.Width) or 368))
        local widgetH = math.max(352, math.floor(tonumber(config.Height) or 356))
        local marginX = math.floor(tonumber(config.MarginX) or 18)
        local marginY = math.floor(tonumber(config.MarginY) or 76)
        local shownPos = UDim2.new(1, -marginX, 0, marginY)
        local hiddenPos = UDim2.new(1, widgetW + 28, 0, marginY)

        local wf = Create("Frame",{
            Name = _RandomGuiName(),
            Size = UDim2.new(0, widgetW, 0, widgetH),
            Position = hiddenPos,
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Theme.WindowBg,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            Active = true,
            ZIndex = ZIndex.OVERLAY + 20,
            Parent = MIDNIGHT._ScreenGui,
        })
        ApplyCorner(wf, 8)
        local wfStroke = ApplyStroke(wf, Theme.Border, 1, 1)
        local wfScale = Create("UIScale",{Scale=0.97,Parent=wf})

        local shadow = Create("ImageLabel",{
            Size=UDim2.new(1,26,1,26),
            Position=UDim2.new(0,-13,0,-11),
            BackgroundTransparency=1,
            Image="rbxassetid://6015897843",
            ImageColor3=Theme.Shadow,
            ImageTransparency=1,
            ScaleType=Enum.ScaleType.Slice,
            SliceCenter=Rect.new(49,49,450,450),
            ZIndex=wf.ZIndex-1,
            Parent=wf,
        })

        local tint = Create("Frame",{
            Size=UDim2.new(1,0,1,0),
            BackgroundColor3=AccentTint(Theme.Accent,0.05),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex,
            Parent=wf,
        })
        ApplyCorner(tint, 8)

        local header = Create("Frame",{
            Size=UDim2.new(1,0,0,32),
            BackgroundColor3=Theme.TitleBarBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+1,
            Parent=wf,
        })
        ApplyCorner(header, 8)
        Create("Frame",{
            Size=UDim2.new(1,0,0,8),
            Position=UDim2.new(0,0,1,-8),
            BackgroundColor3=Theme.TitleBarBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Parent=header,
        })
        local headerDivider = Create("Frame",{
            Size=UDim2.new(1,0,0,1),
            Position=UDim2.new(0,0,1,-1),
            BackgroundColor3=Theme.Border,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+2,
            Parent=header,
        })
        local headerTitle = Create("TextLabel",{
            Text="Admin Presence",
            Font=FontBold,
            TextSize=12,
            TextColor3=Theme.TextPrimary,
            TextTransparency=1,
            Size=UDim2.new(1,-44,1,0),
            Position=UDim2.new(0,12,0,0),
            TextXAlignment=Enum.TextXAlignment.Left,
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=header,
        })

        local closeBtn = Create("TextButton",{
            Text="",
            Size=UDim2.new(0,20,0,16),
            Position=UDim2.new(1,-24,0,8),
            BackgroundColor3=Theme.InputBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            AutoButtonColor=false,
            ZIndex=wf.ZIndex+3,
            Parent=header,
        })
        ApplyCorner(closeBtn,4)
        local closeStroke = ApplyStroke(closeBtn, Theme.Border, 1, 1)
        local closeIcon = CreateIconOrText(closeBtn,"x",nil,UDim2.new(0,10,0,10),UDim2.new(0.5,-5,0.5,-5),Theme.TextMuted,FontBold,9)
        if closeIcon and closeIcon:IsA("TextLabel") then
            closeIcon.TextXAlignment = Enum.TextXAlignment.Center
            closeIcon.TextYAlignment = Enum.TextYAlignment.Center
            closeIcon.TextTransparency = 1
        elseif closeIcon and closeIcon:IsA("ImageLabel") then
            closeIcon.ImageTransparency = 1
        end

        local body = Create("Frame",{
            Size=UDim2.new(1,-16,1,-48),
            Position=UDim2.new(0,8,0,36),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+1,
            Parent=wf,
        })

        local avatarWrap = Create("Frame",{
            Size=UDim2.new(0,56,0,56),
            Position=UDim2.new(0,0,0,0),
            BackgroundColor3=Theme.InputBg,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        ApplyCorner(avatarWrap,8)
        local avatarStroke = ApplyStroke(avatarWrap, Theme.BorderLight, 1, 1)
        local avatarImg = Create("ImageLabel",{
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            Image="",
            ImageTransparency=0,
            ZIndex=wf.ZIndex+3,
            Parent=avatarWrap,
        })
        ApplyCorner(avatarImg,7)
        local avatarFallback = CreateIconOrText(avatarWrap,"shield",nil,UDim2.new(0,22,0,22),UDim2.new(0.5,-11,0.5,-11),Theme.TextMuted,FontBold,16)

        local countBadge = Create("Frame",{
            Size=UDim2.new(0,44,0,18),
            Position=UDim2.new(1,-44,0,0),
            BackgroundColor3=Theme.InputBg,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        ApplyCorner(countBadge,8)
        local countStroke = ApplyStroke(countBadge, Theme.Border, 1, 1)
        local countLabel = Create("TextLabel",{
            Text="1 / 1",
            Font=FontBold,
            TextSize=9,
            TextColor3=Theme.TextMuted,
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+3,
            Parent=countBadge,
        })

        local nameLabel = Create("TextLabel",{
            Text="No admins detected",
            Font=FontBold,
            TextSize=14,
            TextColor3=Theme.TextPrimary,
            TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top,
            Size=UDim2.new(1,-112,0,18),
            Position=UDim2.new(0,66,0,0),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        local handleLabel = Create("TextLabel",{
            Text="@waiting",
            Font=FontRegular,
            TextSize=11,
            TextColor3=Theme.TextMuted,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,-112,0,13),
            Position=UDim2.new(0,66,0,20),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        local metaLabel = Create("TextLabel",{
            Text="Waiting for the first admin event",
            Font=FontRegular,
            TextSize=9,
            TextColor3=Theme.TextMuted,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,-112,0,12),
            Position=UDim2.new(0,66,0,35),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })

        local roleBadge = Create("Frame",{
            Size=UDim2.new(0,0,0,18),
            AutomaticSize=Enum.AutomaticSize.X,
            Position=UDim2.new(0,66,0,50),
            BackgroundColor3=AccentTint(Theme.Accent,0.14),
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        ApplyCorner(roleBadge,8)
        ApplyPadding(roleBadge,0,0,8,8)
        local roleStroke = ApplyStroke(roleBadge, Theme.Accent, 1, 1)
        local roleLabel = Create("TextLabel",{
            Text="Observer",
            Font=FontBold,
            TextSize=9,
            TextColor3=Theme.TextAccent,
            Size=UDim2.new(0,0,1,0),
            AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+3,
            Parent=roleBadge,
        })

        local stateBadge = Create("Frame",{
            Size=UDim2.new(0,0,0,18),
            AutomaticSize=Enum.AutomaticSize.X,
            Position=UDim2.new(1,-82,0,50),
            BackgroundColor3=AccentTint(Theme.Success,0.12),
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+2,
            Parent=body,
        })
        ApplyCorner(stateBadge,8)
        ApplyPadding(stateBadge,0,0,8,8)
        local stateStroke = ApplyStroke(stateBadge, Theme.Success, 1, 1)
        local stateLabel = Create("TextLabel",{
            Text="ONLINE",
            Font=FontBold,
            TextSize=9,
            TextColor3=Theme.Success,
            Size=UDim2.new(0,0,1,0),
            AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+3,
            Parent=stateBadge,
        })

        local statusCard = Create("Frame",{
            Size=UDim2.new(1,0,0,60),
            Position=UDim2.new(0,0,0,80),
            BackgroundColor3=Theme.ItemBg,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+1,
            Parent=body,
        })
        ApplyCorner(statusCard,7)
        local statusStroke = ApplyStroke(statusCard, Theme.Border, 1, 1)
        local statusHead = Create("TextLabel",{
            Text="LAST ACTION",
            Font=FontBold,
            TextSize=9,
            TextColor3=Theme.TextMuted,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,-14,0,12),
            Position=UDim2.new(0,7,0,7),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=statusCard,
        })
        local statusText = Create("TextLabel",{
            Text="Waiting for activity",
            Font=FontRegular,
            TextSize=10,
            TextColor3=Theme.TextSecondary,
            TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top,
            Size=UDim2.new(1,-14,0,34),
            Position=UDim2.new(0,7,0,21),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=statusCard,
        })

        local commandCard = Create("Frame",{
            Size=UDim2.new(1,0,0,56),
            Position=UDim2.new(0,0,0,148),
            BackgroundColor3=Theme.ItemBg,
            BorderSizePixel=0,
            ZIndex=wf.ZIndex+1,
            Parent=body,
        })
        ApplyCorner(commandCard,7)
        local commandStroke = ApplyStroke(commandCard, Theme.Border, 1, 1)
        local commandHead = Create("TextLabel",{
            Text="LAST COMMAND",
            Font=FontBold,
            TextSize=9,
            TextColor3=Theme.TextMuted,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,-14,0,12),
            Position=UDim2.new(0,7,0,7),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=commandCard,
        })
        local commandText = Create("TextLabel",{
            Text="No commands captured yet",
            Font=FontRegular,
            TextSize=10,
            TextColor3=Theme.TextSecondary,
            TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top,
            Size=UDim2.new(1,-14,0,30),
            Position=UDim2.new(0,7,0,21),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=commandCard,
        })

        local confirmBar = Create("Frame",{
            Size=UDim2.new(1,0,0,30),
            Position=UDim2.new(0,0,0,212),
            BackgroundColor3=Theme.InputBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Visible=false,
            ZIndex=wf.ZIndex+1,
            Parent=body,
        })
        ApplyCorner(confirmBar,6)
        local confirmStroke = ApplyStroke(confirmBar, Theme.Warning, 1, 1)
        local confirmLabel = Create("TextLabel",{
            Text="Teleport to admin?",
            Font=FontRegular,
            TextSize=10,
            TextColor3=Theme.TextSecondary,
            TextTransparency=1,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(1,-106,1,0),
            Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+2,
            Parent=confirmBar,
        })
        local confirmYes = Create("TextButton",{
            Text="Yes",
            Font=FontBold,
            TextSize=10,
            TextColor3=Theme.TextPrimary,
            TextTransparency=1,
            Size=UDim2.new(0,42,0,18),
            Position=UDim2.new(1,-84,0.5,-9),
            BackgroundColor3=Theme.Accent,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            AutoButtonColor=false,
            ZIndex=wf.ZIndex+2,
            Parent=confirmBar,
        })
        ApplyCorner(confirmYes,4)
        local confirmNo = Create("TextButton",{
            Text="No",
            Font=FontBold,
            TextSize=10,
            TextColor3=Theme.TextSecondary,
            TextTransparency=1,
            Size=UDim2.new(0,36,0,18),
            Position=UDim2.new(1,-38,0.5,-9),
            BackgroundColor3=Theme.WindowBg,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            AutoButtonColor=false,
            ZIndex=wf.ZIndex+2,
            Parent=confirmBar,
        })
        ApplyCorner(confirmNo,4)
        local confirmNoStroke = ApplyStroke(confirmNo, Theme.Border, 1, 1)

        local buttonGrid = Create("Frame",{
            Size=UDim2.new(1,0,0,56),
            Position=UDim2.new(0,0,0,250),
            BackgroundTransparency=1,
            ZIndex=wf.ZIndex+1,
            Parent=body,
        })
        Create("UIGridLayout",{
            CellSize=UDim2.new(0,math.floor((widgetW-24)/3),0,26),
            CellPadding=UDim2.new(0,4,0,4),
            FillDirectionMaxCells=3,
            SortOrder=Enum.SortOrder.LayoutOrder,
            Parent=buttonGrid,
        })

        local function makeActionButton(text, order)
            local btn = Create("TextButton",{
                Text="",
                Size=UDim2.new(0,0,0,26),
                BackgroundColor3=Theme.ItemBg,
                BorderSizePixel=0,
                LayoutOrder=order,
                AutoButtonColor=false,
                ZIndex=wf.ZIndex+2,
                Parent=buttonGrid,
            })
            ApplyCorner(btn,4)
            local stroke = ApplyStroke(btn, Theme.Border, 1, 1)
            local lbl = Create("TextLabel",{
                Text=text,
                Font=FontBold,
                TextSize=10,
                TextColor3=Theme.TextPrimary,
                Size=UDim2.new(1,-8,1,0),
                Position=UDim2.new(0,4,0,0),
                TextXAlignment=Enum.TextXAlignment.Center,
                BackgroundTransparency=1,
                ZIndex=wf.ZIndex+3,
                Parent=btn,
            })
            local data = {Button=btn, Label=lbl, Stroke=stroke, Enabled=true, Accent=false}
            btn.MouseEnter:Connect(function()
                if not data.Enabled then return end
                TweenObject(btn,{BackgroundColor3=data.Accent and AccentTint(Theme.Accent,0.18) or Theme.ItemHoverBg},0.12)
                if stroke then TweenObject(stroke,{Color=data.Accent and Theme.Accent or Theme.BorderLight,Transparency=0.18},0.12) end
            end)
            btn.MouseLeave:Connect(function()
                local bg = data.Accent and AccentTint(Theme.Accent,0.1) or Theme.ItemBg
                local color = data.Accent and Theme.Accent or Theme.Border
                TweenObject(btn,{BackgroundColor3=bg},0.14)
                if stroke then TweenObject(stroke,{Color=color,Transparency=data.Enabled and 0.3 or 0.55},0.14) end
            end)
            return data
        end

        local spectateBtn = makeActionButton("Spectate", 1)
        local teleportBtn = makeActionButton("Teleport", 2)
        local logsBtn = makeActionButton("Chat Logs", 3)
        local prevBtn = makeActionButton("Prev", 4)
        local nextBtn = makeActionButton("Next", 5)
        local dismissBtn = makeActionButton("Dismiss", 6)

        local data = {
            _Frame = wf,
            _LogsWindow = config.LogsWindow,
            _Admins = {},
            _AdminMap = {},
            _Index = 0,
            _Visible = false,
            _Destroyed = false,
            _CurrentAvatarUserId = nil,
            _AvatarToken = 0,
            _PendingConfirm = nil,
            _PendingHideThread = nil,
            _SpectateUserId = nil,
            _PreviousCameraSubject = nil,
            _PreviousCameraType = nil,
        }

        self._AdminPresenceWidget = data

        local function setButtonState(btnData, enabled, accent)
            btnData.Enabled = enabled ~= false
            btnData.Accent = accent == true
            local bg = accent and AccentTint(Theme.Accent,0.1) or Theme.ItemBg
            local borderColor = accent and Theme.Accent or Theme.Border
            local textColor = btnData.Enabled and (accent and Theme.TextAccent or Theme.TextPrimary) or Theme.TextMuted
            TweenObject(btnData.Button,{BackgroundColor3=bg},0.1)
            if btnData.Stroke then
                TweenObject(btnData.Stroke,{
                    Color=borderColor,
                    Transparency=btnData.Enabled and 0.3 or 0.55
                },0.1)
            end
            TweenObject(btnData.Label,{TextColor3=textColor},0.1)
        end

        local function setConfirmVisible(visible, labelText, action)
            data._PendingConfirm = visible and action or nil
            if visible then
                confirmLabel.Text = labelText or "Confirm action?"
                confirmBar.Visible = true
                TweenObject(confirmBar,{BackgroundTransparency=0.08},0.14)
                if confirmStroke then TweenObject(confirmStroke,{Transparency=0.28},0.14) end
                TweenObject(confirmLabel,{TextTransparency=0},0.14)
                TweenObject(confirmYes,{BackgroundTransparency=0,TextTransparency=0},0.14)
                TweenObject(confirmNo,{BackgroundTransparency=0,TextTransparency=0},0.14)
                if confirmNoStroke then TweenObject(confirmNoStroke,{Transparency=0.32},0.14) end
            else
                TweenObject(confirmBar,{BackgroundTransparency=1},0.12)
                if confirmStroke then TweenObject(confirmStroke,{Transparency=1},0.12) end
                TweenObject(confirmLabel,{TextTransparency=1},0.12)
                TweenObject(confirmYes,{BackgroundTransparency=1,TextTransparency=1},0.12)
                TweenObject(confirmNo,{BackgroundTransparency=1,TextTransparency=1},0.12)
                if confirmNoStroke then TweenObject(confirmNoStroke,{Transparency=1},0.12) end
                local token = os.clock()
                data._ConfirmHideToken = token
                task.delay(0.14,function()
                    if data._Destroyed then return end
                    if data._ConfirmHideToken ~= token then return end
                    confirmBar.Visible = false
                end)
            end
        end

        local function getCurrentEntry()
            return data._Admins[data._Index]
        end

        local function getLocalFocusParts()
            local char = LocalPlayer and LocalPlayer.Character
            if not char then return nil, nil end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
            return hum, root
        end

        local function resolveTargetParts(player)
            if not player or not player.Character then return nil, nil, nil end
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
            return hum, root, char
        end

        local function moveEntryToFront(entry)
            for i, existing in ipairs(data._Admins) do
                if existing == entry then
                    table.remove(data._Admins, i)
                    break
                end
            end
            table.insert(data._Admins, 1, entry)
        end

        local function updateCount()
            local total = #data._Admins
            countBadge.Visible = total > 1
            if total > 1 then
                countLabel.Text = tostring(math.max(1, data._Index)) .. " / " .. tostring(total)
            else
                countLabel.Text = "1 / 1"
            end
        end

        local function setVisible(visible)
            SafeCancelThread(data._PendingHideThread)
            data._PendingHideThread = nil
            data._Visible = visible == true
            if visible then
                wf.Visible = true
                wf.Position = hiddenPos
                wfScale.Scale = 0.97
                TweenObject(wf,{Position=shownPos,BackgroundTransparency=0},0.24,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                TweenObject(wfScale,{Scale=1},0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
                if wfStroke then TweenObject(wfStroke,{Transparency=0.16},0.18) end
                TweenObject(header,{BackgroundTransparency=0},0.18)
                TweenObject(headerDivider,{BackgroundTransparency=0},0.18)
                TweenObject(headerTitle,{TextTransparency=0},0.16)
                if shadow then TweenObject(shadow,{ImageTransparency=0.8},0.22) end
                if tint then TweenObject(tint,{BackgroundTransparency=0.52},0.2) end
                if closeStroke then TweenObject(closeStroke,{Transparency=0.4},0.16) end
                if closeIcon then
                    if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextTransparency=0},0.16)
                    elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageTransparency=0},0.16) end
                end
            else
                TweenObject(wf,{Position=hiddenPos,BackgroundTransparency=1},0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
                TweenObject(wfScale,{Scale=0.97},0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
                if wfStroke then TweenObject(wfStroke,{Transparency=1},0.16) end
                TweenObject(header,{BackgroundTransparency=1},0.16)
                TweenObject(headerDivider,{BackgroundTransparency=1},0.16)
                TweenObject(headerTitle,{TextTransparency=1},0.14)
                if shadow then TweenObject(shadow,{ImageTransparency=1},0.16) end
                if tint then TweenObject(tint,{BackgroundTransparency=1},0.16) end
                if closeStroke then TweenObject(closeStroke,{Transparency=1},0.14) end
                if closeIcon then
                    if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextTransparency=1},0.14)
                    elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageTransparency=1},0.14) end
                end
                data._PendingHideThread = task.delay(0.22,function()
                    if not data._Visible and wf.Parent then
                        wf.Visible = false
                    end
                end)
            end
        end

        local function updateButtons()
            local current = getCurrentEntry()
            local hasAdmin = current ~= nil
            local logsAlive = data._LogsWindow and data._LogsWindow.IsAlive and data._LogsWindow:IsAlive()
            local isSpectatingCurrent = hasAdmin and data._SpectateUserId == current.UserId

            spectateBtn.Label.Text = isSpectatingCurrent and "Unspectate" or "Spectate"
            setButtonState(spectateBtn, hasAdmin, isSpectatingCurrent)
            setButtonState(teleportBtn, hasAdmin, false)
            setButtonState(logsBtn, logsAlive, false)
            setButtonState(prevBtn, #data._Admins > 1, false)
            setButtonState(nextBtn, #data._Admins > 1, false)
            setButtonState(dismissBtn, true, false)
        end

        local function loadAvatar(entry)
            data._AvatarToken = data._AvatarToken + 1
            local token = data._AvatarToken
            data._CurrentAvatarUserId = entry and entry.UserId or nil
            avatarImg.Image = ""
            if avatarFallback then avatarFallback.Visible = true end
            if not entry then return end
            task.spawn(function()
                local ok, image = pcall(function()
                    return Players:GetUserThumbnailAsync(
                        entry.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size60x60
                    )
                end)
                if not ok or not image or data._Destroyed then return end
                if token ~= data._AvatarToken then return end
                local current = getCurrentEntry()
                if not current or current.UserId ~= entry.UserId then return end
                avatarImg.Image = image
                if avatarFallback then avatarFallback.Visible = false end
            end)
        end

        local function render(entry)
            if not entry then
                nameLabel.Text = "No admins detected"
                handleLabel.Text = "@waiting"
                metaLabel.Text = "Waiting for the first admin event"
                roleLabel.Text = "Observer"
                roleBadge.BackgroundColor3 = AccentTint(Theme.Accent,0.14)
                if roleStroke then roleStroke.Color = Theme.Accent end
                stateLabel.Text = "IDLE"
                stateLabel.TextColor3 = Theme.TextMuted
                stateBadge.BackgroundColor3 = Theme.InputBg
                if stateStroke then stateStroke.Color = Theme.Border end
                statusText.Text = "No admin activity detected yet."
                commandText.Text = "No commands captured yet."
                commandText.TextColor3 = Theme.TextMuted
                updateCount()
                updateButtons()
                loadAvatar(nil)
                return
            end

            local displayName = entry.DisplayName or entry.Name or "Unknown"
            local roleColor = entry.RankColor or Theme.TextAccent
            nameLabel.Text = displayName
            handleLabel.Text = "@" .. tostring(entry.Name or "unknown")
            metaLabel.Text = "Last update " .. tostring(entry.LastSeen or os.date("%H:%M:%S"))
            roleLabel.Text = tostring(entry.RankName or "Admin")
            roleLabel.TextColor3 = roleColor
            roleBadge.BackgroundColor3 = AccentTint(roleColor,0.14)
            if roleStroke then roleStroke.Color = roleColor end
            stateLabel.Text = "ONLINE"
            stateLabel.TextColor3 = Theme.Success
            stateBadge.BackgroundColor3 = AccentTint(Theme.Success,0.12)
            if stateStroke then stateStroke.Color = Theme.Success end
            statusText.Text = tostring(entry.LatestAction or "Watching the server")
            commandText.Text = tostring(entry.LastCommand or "No commands captured yet")
            commandText.TextColor3 = (entry.LastCommand and entry.LastCommand ~= "" and entry.LastCommand ~= "No commands captured yet") and Theme.TextPrimary or Theme.TextMuted
            if data._CurrentAvatarUserId ~= entry.UserId then
                loadAvatar(entry)
            end
            updateCount()
            updateButtons()
        end

        function data:IsAlive()
            return not self._Destroyed and self._Frame and self._Frame.Parent ~= nil
        end

        function data:SetLogsWindow(window)
            self._LogsWindow = window
            updateButtons()
            return self
        end

        function data:Show()
            if self._Destroyed then return end
            setVisible(true)
        end

        function data:Hide()
            if self._Destroyed then return end
            setConfirmVisible(false)
            setVisible(false)
        end

        function data:FocusAdmin(playerOrUserId)
            local userId = typeof(playerOrUserId) == "Instance" and playerOrUserId.UserId or tonumber(playerOrUserId)
            if not userId then return end
            for i, entry in ipairs(self._Admins) do
                if entry.UserId == userId then
                    self._Index = i
                    render(entry)
                    return entry
                end
            end
        end

        function data:Cycle(direction)
            if #self._Admins == 0 then return end
            local step = direction == "prev" and -1 or 1
            local nextIndex = self._Index + step
            if nextIndex < 1 then nextIndex = #self._Admins end
            if nextIndex > #self._Admins then nextIndex = 1 end
            self._Index = nextIndex
            render(getCurrentEntry())
        end

        function data:StopSpectate(skipNotify)
            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraType = self._PreviousCameraType or Enum.CameraType.Custom
                if self._PreviousCameraSubject and self._PreviousCameraSubject.Parent then
                    camera.CameraSubject = self._PreviousCameraSubject
                else
                    local hum, root = getLocalFocusParts()
                    if hum then
                        camera.CameraSubject = hum
                    elseif root then
                        camera.CameraSubject = root
                    end
                    camera.CameraType = Enum.CameraType.Custom
                end
            end
            self._SpectateUserId = nil
            self._PreviousCameraSubject = nil
            self._PreviousCameraType = nil
            render(getCurrentEntry())
            if not skipNotify then
                MIDNIGHT:Notify({Title="Admin Widget",Content="Spectate disabled",Type="info",Duration=3})
            end
        end

        function data:StartSpectate(entry)
            if not entry or not entry.Player then return end
            local hum, root = resolveTargetParts(entry.Player)
            local target = hum or root
            if not target then
                MIDNIGHT:Notify({Title="Admin Widget",Content="Admin character is not available",Type="warning",Duration=4})
                return
            end
            local camera = workspace.CurrentCamera
            if not camera then return end
            if self._SpectateUserId == entry.UserId then
                self:StopSpectate()
                return
            end
            self._PreviousCameraSubject = camera.CameraSubject
            self._PreviousCameraType = camera.CameraType
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = target
            self._SpectateUserId = entry.UserId
            render(entry)
            MIDNIGHT:Notify({Title="Admin Widget",Content="Spectating "..tostring(entry.DisplayName or entry.Name),Type="info",Duration=3})
        end

        function data:TeleportTo(entry)
            if not entry or not entry.Player then return end
            local _, localRoot = getLocalFocusParts()
            local _, targetRoot = resolveTargetParts(entry.Player)
            if not localRoot or not targetRoot then
                MIDNIGHT:Notify({Title="Admin Widget",Content="Teleport target is not available",Type="warning",Duration=4})
                return
            end
            local offset = targetRoot.CFrame.LookVector * -3
            local teleportPos = targetRoot.Position + offset + Vector3.new(0,1,0)
            localRoot.CFrame = CFrame.new(teleportPos, targetRoot.Position)
            MIDNIGHT:Notify({Title="Admin Widget",Content="Teleported near "..tostring(entry.DisplayName or entry.Name),Type="success",Duration=3})
        end

        function data:OpenLogs()
            local logsWindow = self._LogsWindow
            if not (logsWindow and logsWindow.IsAlive and logsWindow:IsAlive()) then
                MIDNIGHT:Notify({Title="Admin Widget",Content="Admin logs window is not available",Type="warning",Duration=4})
                return
            end
            if not logsWindow._Visible or not logsWindow._Frame.Visible then
                if logsWindow.Show then
                    logsWindow:Show()
                elseif logsWindow.Toggle then
                    if logsWindow._Frame and not logsWindow._Frame.Visible then
                        logsWindow._Visible = false
                    end
                    logsWindow:Toggle()
                end
            end
            task.defer(function()
                if logsWindow._Scroll and logsWindow._Scroll.Parent then
                    logsWindow._Scroll.CanvasPosition = Vector2.new(0, logsWindow._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        function data:TrackAdmin(player, rankName, rankColor, actionText, commandTextValue, options)
            if self._Destroyed or not player then return end
            options = type(options) == "table" and options or {}
            local entry = self._AdminMap[player.UserId]
            if not entry then
                entry = {
                    UserId = player.UserId,
                    Player = player,
                    DisplayName = player.DisplayName,
                    Name = player.Name,
                    RankName = rankName or "Admin",
                    RankColor = rankColor or Theme.TextAccent,
                    LatestAction = actionText or "Joined the server",
                    LastCommand = commandTextValue or "No commands captured yet",
                    LastSeen = os.date("%H:%M:%S"),
                }
                self._AdminMap[player.UserId] = entry
                table.insert(self._Admins, 1, entry)
                self._Index = 1
            else
                entry.Player = player
                entry.DisplayName = player.DisplayName
                entry.Name = player.Name
                entry.RankName = rankName or entry.RankName
                entry.RankColor = rankColor or entry.RankColor
                if actionText and actionText ~= "" then
                    entry.LatestAction = actionText
                end
                if commandTextValue and commandTextValue ~= "" then
                    entry.LastCommand = commandTextValue
                end
                entry.LastSeen = os.date("%H:%M:%S")
            end

            if options.Focus then
                moveEntryToFront(entry)
                self._Index = 1
            elseif self._Index == 0 then
                self._Index = 1
            end

            if getCurrentEntry() == entry or options.Focus or #self._Admins == 1 then
                render(entry)
            else
                updateCount()
                updateButtons()
            end

            if options.Reveal then
                self:Show()
            end
            return entry
        end

        function data:RemoveAdmin(player)
            if self._Destroyed or not player then return end
            local entry = self._AdminMap[player.UserId]
            if not entry then return end
            if self._SpectateUserId == player.UserId then
                self:StopSpectate(true)
            end
            self._AdminMap[player.UserId] = nil
            for i, existing in ipairs(self._Admins) do
                if existing == entry then
                    table.remove(self._Admins, i)
                    if self._Index > i then
                        self._Index = self._Index - 1
                    end
                    break
                end
            end
            if #self._Admins == 0 then
                self._Index = 0
                render(nil)
                self:Hide()
            else
                if self._Index < 1 then self._Index = 1 end
                if self._Index > #self._Admins then self._Index = #self._Admins end
                render(getCurrentEntry())
            end
        end

        function data:Destroy()
            if self._Destroyed then return end
            self._Destroyed = true
            SafeCancelThread(self._PendingHideThread)
            self._PendingHideThread = nil
            pcall(function() self:StopSpectate(true) end)
            if self._Frame then
                pcall(function() self._Frame:Destroy() end)
            end
            self._Frame = nil
            if self._OwnerWindow and self._OwnerWindow._AdminPresenceWidget == self then
                self._OwnerWindow._AdminPresenceWidget = nil
            end
        end

        data._OwnerWindow = self

        confirmYes.MouseButton1Click:Connect(function()
            local action = data._PendingConfirm
            setConfirmVisible(false)
            if action then
                pcall(action)
            end
        end)
        confirmNo.MouseButton1Click:Connect(function()
            setConfirmVisible(false)
        end)

        spectateBtn.Button.MouseButton1Click:Connect(function()
            if not spectateBtn.Enabled then return end
            local current = getCurrentEntry()
            if not current then return end
            data:StartSpectate(current)
        end)
        teleportBtn.Button.MouseButton1Click:Connect(function()
            if not teleportBtn.Enabled then return end
            local current = getCurrentEntry()
            if not current then return end
            setConfirmVisible(true, "Teleport to "..tostring(current.DisplayName or current.Name).."?", function()
                data:TeleportTo(current)
            end)
        end)
        logsBtn.Button.MouseButton1Click:Connect(function()
            if logsBtn.Enabled then
                data:OpenLogs()
            end
        end)
        prevBtn.Button.MouseButton1Click:Connect(function()
            if prevBtn.Enabled then
                data:Cycle("prev")
            end
        end)
        nextBtn.Button.MouseButton1Click:Connect(function()
            if nextBtn.Enabled then
                data:Cycle("next")
            end
        end)
        dismissBtn.Button.MouseButton1Click:Connect(function()
            data:Hide()
        end)

        closeBtn.MouseButton1Click:Connect(function()
            data:Hide()
        end)
        closeBtn.MouseEnter:Connect(function()
            TweenObject(closeBtn,{BackgroundTransparency=0.06,BackgroundColor3=Theme.CloseHover},0.12)
            if closeStroke then TweenObject(closeStroke,{Transparency=0.2,Color=Theme.CloseHover},0.12) end
            if closeIcon then
                if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextColor3=Color3.fromRGB(255,255,255),TextTransparency=0},0.12)
                elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageColor3=Color3.fromRGB(255,255,255),ImageTransparency=0},0.12) end
            end
        end)
        closeBtn.MouseLeave:Connect(function()
            TweenObject(closeBtn,{BackgroundTransparency=1,BackgroundColor3=Theme.InputBg},0.12)
            if closeStroke then TweenObject(closeStroke,{Transparency=0.4,Color=Theme.Border},0.12) end
            if closeIcon then
                if closeIcon:IsA("TextLabel") then TweenObject(closeIcon,{TextColor3=Theme.TextMuted,TextTransparency=0},0.12)
                elseif closeIcon:IsA("ImageLabel") then TweenObject(closeIcon,{ImageColor3=Theme.TextMuted,ImageTransparency=0},0.12) end
            end
        end)

        if avatarStroke then avatarStroke.Transparency = 0.28 end
        if countStroke then countStroke.Transparency = 0.38 end
        if roleStroke then roleStroke.Transparency = 0.48 end
        if stateStroke then stateStroke.Transparency = 0.48 end
        if statusStroke then statusStroke.Transparency = 0.38 end
        if commandStroke then commandStroke.Transparency = 0.38 end
        if confirmStroke then confirmStroke.Transparency = 1 end
        if confirmNoStroke then confirmNoStroke.Transparency = 1 end
        if closeStroke then closeStroke.Transparency = 1 end

        MakeDraggable(wf, header, function() MIDNIGHT:_CloseAllPopups() end)
        render(nil)
        return data
    end
    function wd:CreateAdminWidget(config) return self:CreateAdminPresenceWidget(config) end

    function wd:CreateAdminLogs(config)
        if self._AdminLogsWindow and self._AdminLogsWindow.IsAlive and self._AdminLogsWindow:IsAlive() then
            if not self._AdminLogsWindow._Visible or not self._AdminLogsWindow._Frame.Visible then
                if self._AdminLogsWindow.Show then
                    pcall(function() self._AdminLogsWindow:Show() end)
                elseif self._AdminLogsWindow.Toggle then
                    pcall(function()
                        if self._AdminLogsWindow._Frame and not self._AdminLogsWindow._Frame.Visible then
                            self._AdminLogsWindow._Visible = false
                        end
                        self._AdminLogsWindow:Toggle()
                    end)
                end
            end
            return self._AdminLogsWindow
        end

        config=config or {}
        local groupId = config.GroupId or 0
        local ranks   = config.Ranks or {}
        local midnight = MIDNIGHT

        local aw = self:MakeFloatingWindow({Name="Admin Logs", Size={300,380}, Resizable=true})
        if not aw then return nil end
        self._AdminLogsWindow = aw

        local adminWidget = nil
        if config.WidgetEnabled ~= false then
            local widgetConfig = type(config.Widget) == "table" and config.Widget or {}
            widgetConfig.LogsWindow = aw
            adminWidget = self:CreateAdminPresenceWidget(widgetConfig)
            if adminWidget and adminWidget.SetLogsWindow then
                adminWidget:SetLogsWindow(aw)
            end
        end

        local ownedConns = {}
        local ownedThreads = {}
        local function bindConn(conn)
            if conn then
                ownedConns[#ownedConns + 1] = conn
                RegConn(conn)
            end
            return conn
        end
        local function bindThread(th)
            if th then
                ownedThreads[#ownedThreads + 1] = th
            end
            return th
        end
        local function canUseWindow()
            return aw and aw.IsAlive and aw:IsAlive()
        end
        local function canUseWidget()
            return adminWidget and adminWidget.IsAlive and adminWidget:IsAlive()
        end

        aw:OnDestroy(function()
            if self._AdminLogsWindow == aw then
                self._AdminLogsWindow = nil
            end
            if adminWidget and adminWidget.SetLogsWindow then
                adminWidget:SetLogsWindow(nil)
            end
            for _, conn in ipairs(ownedConns) do
                SafeDisconnect(conn)
            end
            ownedConns = {}
            for _, th in ipairs(ownedThreads) do
                SafeCancelThread(th)
            end
            ownedThreads = {}
        end)

        -- РЎРєСЂС‹С‚ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ вЂ” РѕС‚РєСЂРѕРµС‚СЃСЏ СЃР°Рј РїСЂРё РїРµСЂРІРѕРј СЃРѕР±С‹С‚РёРё
        aw._Visible = false
        aw._Frame.Visible = false

        local logOrder = 0
        local autoOpenLogs = config.AutoOpenLogs == true
        local function addLog(tag, text, tagColor, textColor, skipAutoOpen)
            if not canUseWindow() then return end
            -- РђРІС‚Рѕ-РѕС‚РєСЂС‹С‚РёРµ РїСЂРё РїРµСЂРІРѕРј Р»РѕРіРµ
            if autoOpenLogs and not skipAutoOpen and (not aw._Visible or not aw._Frame.Visible) then
                aw:Show()
            end
            logOrder = logOrder + 1
            local time = os.date("%H:%M:%S")
            aw:AddRichLine("["..time.."] "..tag, text, tagColor or Theme.TextMuted, textColor or Theme.TextSecondary)
            -- РЎРєСЂРѕР»Р»РёРј РІРЅРёР·
            task.defer(function()
                if aw._Scroll and aw._Scroll.Parent then
                    aw._Scroll.CanvasPosition = Vector2.new(0, aw._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        -- РџСЂРѕРІРµСЂРєР° СЏРІР»СЏРµС‚СЃСЏ Р»Рё РёРіСЂРѕРє Р°РґРјРёРЅРѕРј
        local rankColor
        local function trackWidget(player, rankName, actionText, commandTextValue, options)
            if not canUseWidget() or not player then return end
            local okColor, colorValue = pcall(rankColor, player)
            local badgeColor = okColor and colorValue or Theme.TextAccent
            pcall(function()
                adminWidget:TrackAdmin(player, tostring(rankName or "Admin"), badgeColor, actionText, commandTextValue, options)
            end)
        end

        local function removeFromWidget(player)
            if not canUseWidget() or not player then return end
            pcall(function()
                adminWidget:RemoveAdmin(player)
            end)
        end

        local adminCache = {}
        local function isAdmin(player)
            if adminCache[player.UserId] ~= nil then return adminCache[player.UserId], adminCache[player.UserId .. "_rank"] end
            local ok, rank = pcall(function() return player:GetRankInGroup(groupId) end)
            if ok and rank > 0 and ranks[rank] then
                adminCache[player.UserId] = true
                adminCache[player.UserId .. "_rank"] = ranks[rank]
                return true, ranks[rank]
            end
            adminCache[player.UserId] = false
            return false
        end

        -- Р¦РІРµС‚ РїРѕ СЂР°РЅРіСѓ
        rankColor = function(player)
            local ok, rank = pcall(function() return player:GetRankInGroup(groupId) end)
            if not ok then return Theme.TextAccent end
            return rank>=200 and Theme.Error or rank>=100 and Theme.Warning or rank>=50 and Theme.Success or Theme.TextAccent
        end

        -- РџРѕРґРїРёСЃРєР° РЅР° С‡Р°С‚ РёРіСЂРѕРєР°
        local chatConns = {}
        local teamConns = {}
        local spawnConns = {}
        local function watchChat(player)
            if chatConns[player.UserId] then return end
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local conn = player.Chatted:Connect(function(msg)
                if not canUseWindow() then return end
                local nc = rankColor(player)
                addLog(player.DisplayName, msg, nc, Theme.TextSecondary)
                local isCommand = type(msg) == "string" and (msg:sub(1,1) == "!" or msg:sub(1,1) == "/")
                if isCommand then
                    trackWidget(player, rankName, "Issued a command in chat", msg, {Focus=false, Reveal=false})
                else
                    trackWidget(player, rankName, "Spoke in chat", nil, {Focus=false, Reveal=false})
                end
            end)
            chatConns[player.UserId] = conn
            bindConn(conn)
        end

        -- РџРѕРґРїРёСЃРєР° РЅР° СЃРїР°РІРЅ/РґРµСЃРїР°РІРЅ
        local function watchTeam(player)
            if teamConns[player.UserId] then return end
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local conn = player:GetPropertyChangedSignal("Team"):Connect(function()
                if not canUseWindow() then return end
                local teamName = player.Team and player.Team.Name or "No Team"
                local nc = rankColor(player)
                addLog(player.DisplayName, "switched team -> "..teamName, nc, Theme.Warning)
                trackWidget(player, rankName, "Switched team to "..teamName, nil, {Focus=false, Reveal=false})
            end)
            teamConns[player.UserId] = conn
            bindConn(conn)
        end

        local function watchSpawn(player)
            if spawnConns[player.UserId] then return end
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local nc = rankColor(player)
            local addedConn = player.CharacterAdded:Connect(function()
                if not canUseWindow() then return end
                addLog(player.DisplayName, "spawned ["..tostring(rankName).."]", nc, Theme.Success)
                trackWidget(player, rankName, "Spawned in the server", nil, {Focus=false, Reveal=false})
                midnight:Notify({Title="Admin Spawned", Content=player.DisplayName.." ("..tostring(rankName)..")", Type="warning", Duration=6})
            end)
            local removingConn = player.CharacterRemoving:Connect(function()
                if not canUseWindow() then return end
                addLog(player.DisplayName, "despawned", nc, Theme.TextMuted)
                trackWidget(player, rankName, "Character despawned", nil, {Focus=false, Reveal=false})
            end)
            spawnConns[player.UserId] = {addedConn, removingConn}
            bindConn(addedConn)
            bindConn(removingConn)
        end

        -- РћР±СЂР°Р±РѕС‚РєР° РІС…РѕРґР° РёРіСЂРѕРєР°
        local function onPlayerAdded(player)
            bindThread(task.delay(2, function()
                if not canUseWindow() then return end
                if not player or not player.Parent then return end
                local ok2, admin, rankName = pcall(isAdmin, player)
                if not (ok2 and admin) then return end
                local nc = rankColor(player)
                addLog(player.DisplayName, "joined ["..tostring(rankName).."]", nc, Theme.Warning)
                midnight:Notify({
                    Title = "вљ  Admin Joined",
                    Content = player.DisplayName .. " вЂ” " .. tostring(rankName),
                    Type = "warning",
                    Duration = 8,
                })
                -- РћС‚РєСЂС‹С‚СЊ РѕРєРЅРѕ Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРё
                trackWidget(player, rankName, "Joined the server", nil, {Focus=true, Reveal=true})
                if autoOpenLogs and (not aw._Visible or not aw._Frame.Visible) then aw:Show() end
                watchChat(player)
                watchTeam(player)
                watchSpawn(player)
            end))
        end

        -- РћР±СЂР°Р±РѕС‚РєР° РІС‹С…РѕРґР°
        local function onPlayerRemoving(player)
            local ok2, admin, rankName = pcall(isAdmin, player)
            if ok2 and admin then
                local nc = rankColor(player)
                if canUseWindow() then
                    addLog(player.DisplayName, "left ["..tostring(rankName).."]", nc, Theme.Error)
                    midnight:Notify({
                        Title = "Admin Left",
                        Content = player.DisplayName .. " disconnected",
                        Type = "info",
                        Duration = 5,
                    })
                end
                removeFromWidget(player)
            end
            SafeDisconnect(chatConns[player.UserId])
            chatConns[player.UserId] = nil
            SafeDisconnect(teamConns[player.UserId])
            teamConns[player.UserId] = nil
            local playerSpawnConns = spawnConns[player.UserId]
            if playerSpawnConns then
                for _, conn in ipairs(playerSpawnConns) do
                    SafeDisconnect(conn)
                end
            end
            spawnConns[player.UserId] = nil
            adminCache[player.UserId] = nil
            adminCache[player.UserId .. "_rank"] = nil
        end

        -- РРЅРёС†РёР°Р»РёР·Р°С†РёСЏ С‚РµРєСѓС‰РёС… РёРіСЂРѕРєРѕРІ
        addLog("SYSTEM", "Admin monitor started", Theme.Accent, Theme.TextSecondary, true)
        local revealedExistingAdmin = false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local ok2, admin, rankName = pcall(isAdmin, p)
                if ok2 and admin then
                    local nc = rankColor(p)
                    addLog(p.DisplayName, "online ["..tostring(rankName).."]", nc, Theme.TextAccent, true)
                    trackWidget(p, rankName, "Already online in the server", nil, {
                        Focus = not revealedExistingAdmin,
                        Reveal = not revealedExistingAdmin,
                    })
                    revealedExistingAdmin = true
                    watchChat(p)
                    watchTeam(p)
                    watchSpawn(p)
                end
            end
        end

        bindConn(Players.PlayerAdded:Connect(onPlayerAdded))
        bindConn(Players.PlayerRemoving:Connect(onPlayerRemoving))
        return aw
    end
    function wd:CreateAdminChecker(c) return self:CreateAdminLogs(c) end

    function wd:TestAdmin(config)
        config = config or {}
        local midnight = MIDNIGHT

        local previous = self._TestAdminState
        if previous then
            previous.Token = nil
            for _, th in ipairs(previous.Threads or {}) do
                SafeCancelThread(th)
            end
            if previous.Widget and previous.Widget.IsAlive and previous.Widget:IsAlive() and previous.Player then
                pcall(function()
                    previous.Widget:RemoveAdmin(previous.Player)
                end)
            end
            if previous.OwnedLogs and previous.LogsWindow and previous.LogsWindow.IsAlive and previous.LogsWindow:IsAlive() then
                pcall(function()
                    previous.LogsWindow:Destroy()
                end)
            end
            self._TestAdminState = nil
        end

        local rolePool = config.Roles or {
            {Name = "Contributor", Color = Theme.TextAccent},
            {Name = "Moderator", Color = Theme.Success},
            {Name = "Head Admin", Color = Theme.Warning},
            {Name = "Lead Developer", Color = Color3.fromRGB(255, 140, 0)},
            {Name = "Owner", Color = Theme.Error},
        }
        local chatPool = config.ChatMessages or {
            "checking the server",
            "all good here",
            "anyone calling staff?",
            "watching reports",
            "keep it clean",
        }
        local commandPool = config.Commands or {
            "!spectate "..string.lower(LocalPlayer and LocalPlayer.Name or "player"),
            "!bring "..string.lower(LocalPlayer and LocalPlayer.Name or "player"),
            "!logs recent",
            "/check suspicious_player",
            "/warn random_player",
        }
        local teamPool = config.Teams or {
            "Spectators",
            "Rapid Response Team",
            "Site Staff",
            "Control Room",
        }

        local function normalizeRole(roleData)
            if type(roleData) == "string" then
                return {Name = roleData, Color = Theme.TextAccent}
            end
            roleData = type(roleData) == "table" and roleData or {}
            return {
                Name = tostring(roleData.Name or roleData.Role or roleData.rank or "Admin"),
                Color = roleData.Color or roleData.rankColor or Theme.TextAccent,
            }
        end

        local function collectCandidates(skipTracked)
            local tracked = self._AdminPresenceWidget and self._AdminPresenceWidget._AdminMap or nil
            local pool = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if (config.IncludeLocalPlayer or plr ~= LocalPlayer)
                and (not skipTracked or not (tracked and tracked[plr.UserId])) then
                    pool[#pool + 1] = plr
                end
            end
            return pool
        end

        local target = config.Player
        if not target then
            local candidates = collectCandidates(true)
            if #candidates == 0 then
                candidates = collectCandidates(false)
            end
            if #candidates == 0 and LocalPlayer then
                candidates = {LocalPlayer}
            end
            if #candidates > 0 then
                target = candidates[math.random(1, #candidates)]
            end
        end

        if not target then
            midnight:Notify({
                Title = "Admin Test",
                Content = "No players available for the preview",
                Type = "warning",
                Duration = 4,
            })
            return nil
        end

        local role = normalizeRole(rolePool[math.random(1, #rolePool)])
        local displayName = tostring(target.DisplayName or target.Name or "Unknown")

        local logsWindow = config.LogsWindow
        local ownedLogs = false
        if config.WithLogs ~= false then
            local alive = logsWindow and logsWindow.IsAlive and logsWindow:IsAlive()
            if not alive then
                logsWindow = self:MakeFloatingWindow({
                    Name = "Admin Logs [TEST]",
                    Size = {320, 360},
                    Resizable = true,
                })
                ownedLogs = logsWindow ~= nil
            end
        end

        local widgetConfig = type(config.Widget) == "table" and config.Widget or {}
        widgetConfig.LogsWindow = logsWindow
        local widget = self:CreateAdminPresenceWidget(widgetConfig)
        if not widget then return nil end
        if logsWindow and widget.SetLogsWindow then
            widget:SetLogsWindow(logsWindow)
        end

        local state = {
            Token = os.clock(),
            Player = target,
            Widget = widget,
            LogsWindow = logsWindow,
            OwnedLogs = ownedLogs,
            Threads = {},
        }
        self._TestAdminState = state

        local function addLog(tag, text, tagColor, textColor)
            if not (logsWindow and logsWindow.IsAlive and logsWindow:IsAlive()) then return end
            local time = os.date("%H:%M:%S")
            logsWindow:AddRichLine("["..time.."] "..tag, text, tagColor or Theme.TextMuted, textColor or Theme.TextSecondary)
            task.defer(function()
                if logsWindow._Scroll and logsWindow._Scroll.Parent then
                    logsWindow._Scroll.CanvasPosition = Vector2.new(0, logsWindow._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        local function queue(delaySec, fn)
            local token = state.Token
            local th = task.delay(delaySec, function()
                local current = self._TestAdminState
                if not current or current.Token ~= token then return end
                if not (widget and widget.IsAlive and widget:IsAlive()) then return end
                fn()
            end)
            state.Threads[#state.Threads + 1] = th
            return th
        end

        local function updateAdmin(actionText, commandText, opts)
            widget:TrackAdmin(target, role.Name, role.Color, actionText, commandText, opts or {
                Focus = true,
                Reveal = false,
            })
        end

        updateAdmin("Joined the server", nil, {Focus = true, Reveal = true})
        addLog(displayName, "joined ["..role.Name.."]", role.Color, Theme.Warning)
        midnight:Notify({
            Title = "Admin Joined [TEST]",
            Content = displayName .. " - " .. role.Name,
            Type = "warning",
            Duration = 6,
        })

        if config.AutoOpenLogs == true and logsWindow and (not logsWindow._Visible or not logsWindow._Frame.Visible) then
            if logsWindow.Show then
                logsWindow:Show()
            elseif logsWindow.Toggle then
                if logsWindow._Frame and not logsWindow._Frame.Visible then
                    logsWindow._Visible = false
                end
                logsWindow:Toggle()
            end
        end

        queue(1.5, function()
            local teamName = teamPool[math.random(1, #teamPool)] or "Spectators"
            updateAdmin("Switched team to "..teamName, nil, {Focus = true, Reveal = false})
            addLog(displayName, "switched team -> "..teamName, role.Color, Theme.Warning)
            midnight:Notify({
                Title = "Team Switch [TEST]",
                Content = displayName .. " -> " .. teamName,
                Type = "warning",
                Duration = 4,
            })
        end)

        queue(3.2, function()
            local msg = chatPool[math.random(1, #chatPool)] or "checking the server"
            updateAdmin("Spoke in chat", nil, {Focus = true, Reveal = false})
            addLog(displayName, msg, role.Color, Theme.TextSecondary)
            midnight:Notify({
                Title = "Admin Chat [TEST]",
                Content = displayName .. ": " .. msg,
                Type = "info",
                Duration = 4,
            })
        end)

        queue(5.0, function()
            local cmd = commandPool[math.random(1, #commandPool)] or "!spectate player"
            updateAdmin("Issued a command in chat", cmd, {Focus = true, Reveal = false})
            addLog(displayName, cmd, role.Color, Theme.Warning)
            midnight:Notify({
                Title = "Admin Command [TEST]",
                Content = displayName .. " used " .. cmd,
                Type = "warning",
                Duration = 5,
            })
        end)

        if config.AutoRemove == true then
            queue(8.0, function()
                addLog(displayName, "left ["..role.Name.."]", role.Color, Theme.Error)
                midnight:Notify({
                    Title = "Admin Left [TEST]",
                    Content = displayName .. " disconnected",
                    Type = "info",
                    Duration = 4,
                })
                widget:RemoveAdmin(target)
            end)
        end

        return widget
    end

    function wd:TestAdminLogs()
        local midnight = MIDNIGHT

        -- РћС‚РєСЂС‹РІР°РµРј РѕРєРЅРѕ Admin Logs
        local aw = self:MakeFloatingWindow({Name="Admin Logs [TEST]", Size={300,380}, Resizable=true})
        if not aw then return nil end

        aw:Show()

        local function addLog(tag, text, tagColor, textColor)
            local time = os.date("%H:%M:%S")
            aw:AddRichLine("["..time.."] "..tag, text, tagColor or Theme.TextMuted, textColor or Theme.TextSecondary)
            task.defer(function()
                if aw._Scroll and aw._Scroll.Parent then
                    aw._Scroll.CanvasPosition = Vector2.new(0, aw._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        -- Р¤РµР№РєРѕРІС‹Рµ РґР°РЅРЅС‹Рµ РґР»СЏ С‚РµСЃС‚Р°
        local fakeAdmins = {
            { name = "xX_ServerOwner_Xx", rank = "Owner",     rankColor = Theme.Error },
            { name = "CoolModerator99",   rank = "Moderator", rankColor = Theme.Warning },
            { name = "HeadAdmin_Dan",     rank = "HeadAdmin", rankColor = Color3.fromRGB(255, 140, 0) },
        }
        local fakeMessages = {
            "anyone cheating rn?",
            "clean the server",
            "!ban suspicious_player",
            "checking logs",
            "all good here",
        }

        local admin = fakeAdmins[math.random(1, #fakeAdmins)]

        -- РЁР°Рі 1: РЅРѕС‚РёС„РёРєР°С†РёСЏ вЂ” Join
        midnight:Notify({
            Title   = "вљ  Admin Joined [TEST]",
            Content = admin.name .. " вЂ” " .. admin.rank,
            Type    = "warning",
            Duration = 8,
        })
        addLog("SYSTEM", "Test sequence started", Theme.Accent, Theme.TextSecondary)
        addLog(admin.name, "joined ["..admin.rank.."]", admin.rankColor, Theme.Warning)

        -- РЁР°Рі 2: РЎРјРµРЅР° РєРѕРјР°РЅРґС‹
        task.delay(1.8, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            midnight:Notify({
                Title   = "вљ  Team Switch [TEST]",
                Content = admin.name .. " switched team",
                Type    = "warning",
                Duration = 5,
            })
            addLog(admin.name, "switched to Spectators", admin.rankColor, Theme.Warning)
        end)

        -- РЁР°Рі 3: РЎРѕРѕР±С‰РµРЅРёРµ РІ С‡Р°С‚Рµ
        task.delay(3.8, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            local msg = fakeMessages[math.random(1, #fakeMessages)]
            midnight:Notify({
                Title   = "вљ  Admin Chat [TEST]",
                Content = admin.name .. ": " .. msg,
                Type    = "warning",
                Duration = 5,
            })
            addLog(admin.name, msg, admin.rankColor, Theme.TextSecondary)
        end)

        -- РЁР°Рі 4: Р•С‰С‘ РѕРґРЅРѕ СЃРѕРѕР±С‰РµРЅРёРµ
        task.delay(5.5, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            addLog(admin.name, "!spectate localplayer", admin.rankColor, Theme.Warning)
            midnight:Notify({
                Title   = "вљ  Admin Command [TEST]",
                Content = admin.name .. " used a command",
                Type    = "warning",
                Duration = 5,
            })
        end)

        -- РЁР°Рі 5: Р’С‹С…РѕРґ
        task.delay(8.0, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            midnight:Notify({
                Title   = "Admin Left [TEST]",
                Content = admin.name .. " disconnected",
                Type    = "info",
                Duration = 5,
            })
            addLog(admin.name, "left ["..admin.rank.."]", admin.rankColor, Theme.Error)
            addLog("SYSTEM", "Test sequence complete", Theme.Accent, Theme.TextSecondary)
        end)

        return aw
    end

    --// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
    --// TARGET HUD EXAMPLE BUTTON
    --// Р”РѕР±Р°РІР»СЏРµС‚ РєРЅРѕРїРєСѓ Toggle Target HUD РІ СѓРєР°Р·Р°РЅРЅС‹Р№ С‚Р°Р±.
    --// РџСЂРё РІРєР»СЋС‡РµРЅРёРё вЂ” Р·Р°РїСѓСЃРєР°РµС‚ С†РёРєР», РєРѕС‚РѕСЂС‹Р№ РєР°Р¶РґС‹Рµ 0.1s РЅР°С…РѕРґРёС‚
    --// РёРіСЂРѕРєР°, С‡СЊСЏ РјРѕРґРµР»СЊ Р±Р»РёР¶Рµ РІСЃРµРіРѕ Рє С†РµРЅС‚СЂСѓ СЌРєСЂР°РЅР° (РєСѓСЂСЃРѕСЂСѓ РјС‹С€Рё),
    --// Рё РїРѕРєР°Р·С‹РІР°РµС‚ Target HUD РґР»СЏ РЅРµРіРѕ. РџСЂРё РІС‹РєР»СЋС‡РµРЅРёРё вЂ” РѕС‡РёС‰Р°РµС‚ HUD.
    --//
    --// Usage:
    --//   local hud = MIDNIGHT:CreateTargetHUD({ Position = "BottomLeft" })
    --//   window:AddTargetHUDExample(someTab, hud)
    --// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
    function wd:AddTargetHUDExample(tab, hud)
        if not tab or not hud then return end

        tab:AddSection({ Name = "Target HUD" })

        -- Dropdown: РїРѕР·РёС†РёСЏ HUD
        local posDropdown = tab:AddInlineDropdown({
            Name = "HUD Position",
            Options = { "CenterLow", "BottomLeft", "BottomRight", "BottomCenter", "TopLeft", "TopRight" },
            Default = "CenterLow",
            Callback = function(val)
                hud:ResetPosition(val)
            end,
        })
        -- Callback РЅРµ СЃС‚СЂРµР»СЏРµС‚ РїСЂРё СЃРѕР·РґР°РЅРёРё вЂ” РїСЂРёРјРµРЅСЏРµРј РґРµС„РѕР»С‚ РІСЂСѓС‡РЅСѓСЋ
        task.defer(function() hud:ResetPosition(posDropdown._Value or "CenterLow") end)

        -- РљРЅРѕРїРєР° СЃР±СЂРѕСЃР° РїРѕР·РёС†РёРё (РµСЃР»Рё РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ РїРµСЂРµС‚Р°С‰РёР» HUD Рё С…РѕС‡РµС‚ РІРµСЂРЅСѓС‚СЊ)
        tab:AddButton({
            Name = "Reset HUD Position",
            Callback = function()
                hud:ResetPosition(posDropdown._Value or "CenterLow")
                MIDNIGHT:Notify({ Title = "Target HUD", Content = "Position reset", Type = "info", Duration = 2 })
            end,
        })

        local trackLoop = nil  -- Connection (RunService.Heartbeat), РЅРµ РїРѕС‚РѕРє

        local function stopTracking(skipClear)
            if trackLoop then
                -- РўРµРїРµСЂСЊ СЌС‚Рѕ Connection, РЅРµ thread вЂ” РЅР°РґС‘Р¶РЅС‹Р№ Disconnect РЅР° Р»СЋР±РѕРј СЌРєР·РµРєСЊСЋС‚РѕСЂРµ
                pcall(function() trackLoop:Disconnect() end)
                trackLoop = nil
            end
            if hud._TrackJoinConn then
                pcall(function() hud._TrackJoinConn:Disconnect() end)
                hud._TrackJoinConn = nil
            end
            if hud._TrackLeaveConn then
                pcall(function() hud._TrackLeaveConn:Disconnect() end)
                hud._TrackLeaveConn = nil
            end
            for p, conn in pairs(hud._TrackCharConns or {}) do
                if conn then pcall(function() conn:Disconnect() end) end
                hud._TrackCharConns[p] = nil
            end
            hud._TrackCharConns = {}
            hud._TrackCharCache = {}
            if not skipClear then
                hud:ClearTarget()
            end
        end

        function hud:StopTracking(skipClear)
            stopTracking(skipClear)
        end

        local function startTracking()
            stopTracking()

            -- Р РµР·РѕР»РІРёРј СЃРµСЂРІРёСЃС‹ РѕРґРёРЅ СЂР°Р· РґРѕ РїРѕРґРєР»СЋС‡РµРЅРёСЏ вЂ” РЅРµ Р°Р»Р»РѕС†РёСЂСѓРµРј РІРЅСѓС‚СЂРё С…РѕС‚-РїР°С‚Р°
            local UIS    = game:GetService("UserInputService")
            local camera = workspace.CurrentCamera
            local plrs   = game:GetService("Players")
            local lp     = plrs.LocalPlayer

            -- #9 FIX: per-player cache for HumanoidRootPart and Humanoid.
            -- FindFirstChild / FindFirstChildOfClass walk the instance tree every call вЂ”
            -- on a full server (20 players) at 10Hz that's 40вЂ“60 tree-walks per second.
            -- We cache the results and only invalidate when the character changes.
            local charCache = {}   -- [player] = { char, root, hum }
            local charConns = {}   -- [player] = CharacterAdded connection
            local trackedPlayers = {}
            hud._TrackCharCache = charCache
            hud._TrackCharConns = charConns

            local function cachePlayer(p)
                if charConns[p] then pcall(function() charConns[p]:Disconnect() end) end
                charCache[p] = nil
                charConns[p] = p.CharacterAdded:Connect(function()
                    charCache[p] = nil  -- invalidate on respawn
                end)
            end

            local function addTrackedPlayer(p)
                if p == lp then return end
                trackedPlayers[#trackedPlayers + 1] = p
                cachePlayer(p)
            end

            local function removeTrackedPlayer(p)
                for i = #trackedPlayers, 1, -1 do
                    if trackedPlayers[i] == p then
                        table.remove(trackedPlayers, i)
                        break
                    end
                end
                if charConns[p] then pcall(function() charConns[p]:Disconnect() end) end
                charCache[p] = nil
                charConns[p] = nil
            end

            local function getCache(p)
                if charCache[p] then return charCache[p] end
                local char = p.Character
                if not char then return nil end
                local root = char:FindFirstChild("HumanoidRootPart")
                          or char:FindFirstChildWhichIsA("BasePart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if not root then return nil end
                local entry = { char = char, root = root, hum = hum }
                charCache[p] = entry
                return entry
            end

            -- Seed cache for players already in game
            for _, p in ipairs(plrs:GetPlayers()) do
                addTrackedPlayer(p)
            end

            -- Track new joiners
            local joinConn = plrs.PlayerAdded:Connect(function(p)
                addTrackedPlayer(p)
            end)
            -- Clean up when players leave
            local leaveConn = plrs.PlayerRemoving:Connect(function(p)
                removeTrackedPlayer(p)
            end)
            hud._TrackJoinConn = joinConn
            hud._TrackLeaveConn = leaveConn

            -- Throttle-Р°РєРєСѓРјСѓР»СЏС‚РѕСЂ: РѕР±РЅРѕРІР»СЏРµРј ~10 СЂР°Р·/СЃРµРє (0.1s), РЅРµ РєР°Р¶РґС‹Р№ С„СЂРµР№Рј
            local accum = 0

            trackLoop = RunService.Heartbeat:Connect(function(dt)
                accum = accum + dt
                if accum < 0.1 then return end
                accum = 0

                local mousePos   = UIS:GetMouseLocation()
                local mX, mY     = mousePos.X, mousePos.Y
                local bestPlayer = nil
                local cam = workspace.CurrentCamera or camera
                if not cam then
                    hud:ClearTarget()
                    return
                end
                local bestDistSq = math.huge  -- СЃСЂР°РІРЅРёРІР°РµРј РєРІР°РґСЂР°С‚С‹, sqrt РЅРµ РЅСѓР¶РµРЅ

                for i = 1, #trackedPlayers do
                    local p = trackedPlayers[i]

                    local entry = getCache(p)
                    if not entry then continue end

                    local hum = entry.hum
                    if hum and hum.Health <= 0 then
                        charCache[p] = nil  -- dead вЂ” invalidate so we re-check on respawn
                        continue
                    end

                    if not entry.root or not entry.root.Parent then
                        charCache[p] = nil
                        continue
                    end
                    local sp, onScreen = cam:WorldToViewportPoint(entry.root.Position)
                    if not onScreen then continue end

                    local dx, dy = sp.X - mX, sp.Y - mY
                    local dSq = dx*dx + dy*dy
                    if dSq < bestDistSq then
                        bestDistSq = dSq
                        bestPlayer = p
                    end
                end

                if bestPlayer then
                    if hud._CurrentPlayer ~= bestPlayer
                    or hud._CurrentCharacter ~= bestPlayer.Character
                    or not hud._Visible then
                        hud:SetTarget(bestPlayer)
                    end
                else
                    hud:ClearTarget()
                end
            end)
        end

        local toggle = tab:AddToggle({
            Name    = "Track Nearest Player",
            Default = false,
            Callback = function(val)
                if val then
                    startTracking()
                    MIDNIGHT:Notify({
                        Title   = "Target HUD",
                        Content = "Tracking nearest player to cursor",
                        Type    = "info",
                        Duration = 3,
                    })
                else
                    stopTracking()
                end
            end,
        })

        return toggle
    end

    function wd:CreateChatLogger()
        if self._ChatLoggerWindow and self._ChatLoggerWindow.IsAlive and self._ChatLoggerWindow:IsAlive() then
            if not self._ChatLoggerWindow._Visible or not self._ChatLoggerWindow._Frame.Visible then
                if self._ChatLoggerWindow.Show then
                    pcall(function() self._ChatLoggerWindow:Show() end)
                elseif self._ChatLoggerWindow.Toggle then
                    pcall(function()
                        if self._ChatLoggerWindow._Frame and not self._ChatLoggerWindow._Frame.Visible then
                            self._ChatLoggerWindow._Visible = false
                        end
                        self._ChatLoggerWindow:Toggle()
                    end)
                end
            end
            return self._ChatLoggerWindow
        end

        local cw = self:MakeFloatingWindow({Name="Chat Logger", Size={320,350}, Resizable=true})
        if not cw then return nil end
        self._ChatLoggerWindow = cw

        local ownedConns = {}
        local function bindConn(conn)
            if conn then
                ownedConns[#ownedConns + 1] = conn
                RegConn(conn)
            end
            return conn
        end
        local function canUseWindow()
            return cw and cw.IsAlive and cw:IsAlive()
        end

        cw:OnDestroy(function()
            if self._ChatLoggerWindow == cw then
                self._ChatLoggerWindow = nil
            end
            for _, conn in ipairs(ownedConns) do
                SafeDisconnect(conn)
            end
            ownedConns = {}
        end)

        local function onChat(player, message)
            if not canUseWindow() then return end
            local time = os.date("%H:%M:%S")
            local nc = Theme.TextSecondary
            pcall(function() if player.TeamColor then nc = player.TeamColor.Color end end)
            cw:AddRichLine("["..time.."] "..player.DisplayName, message, nc, Theme.TextSecondary)
            task.defer(function()
                if cw._Scroll and cw._Scroll.Parent then
                    cw._Scroll.CanvasPosition = Vector2.new(0, cw._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        -- Р›РѕРІРёРј С‡Р°С‚ РІСЃРµС… РІРєР»СЋС‡Р°СЏ LocalPlayer
        bindConn(LocalPlayer.Chatted:Connect(function(msg) onChat(LocalPlayer, msg) end))
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                bindConn(p.Chatted:Connect(function(msg) onChat(p, msg) end))
            end
        end
        bindConn(Players.PlayerAdded:Connect(function(p)
            bindConn(p.Chatted:Connect(function(msg) onChat(p, msg) end))
        end))
        return cw
    end

    return wd
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// DESTROY
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
function MIDNIGHT:Destroy()
    if self._TargetHUD and self._TargetHUD.StopTracking then
        pcall(function() self._TargetHUD:StopTracking() end)
    elseif self._TargetHUD and self._TargetHUD._DisconnectHPConn then
        pcall(self._TargetHUD._DisconnectHPConn)
    end
    if self._lagspikeBlinkStop then
        self._lagspikeBlinkStop()
        self._lagspikeBlinkStop = nil
    end
    if self._TargetHUDHideThread then
        SafeCancelThread(self._TargetHUDHideThread)
        self._TargetHUDHideThread = nil
    end
    if self._LoadingOverlayStop then
        pcall(self._LoadingOverlayStop)
        self._LoadingOverlayStop = nil
    end
    if self._LoadingOverlayFrame then
        pcall(function() self._LoadingOverlayFrame:Destroy() end)
        self._LoadingOverlayFrame = nil
    end
    for _, th in ipairs(self._MenuCloseThreads or {}) do
        SafeCancelThread(th)
    end
    self._MenuCloseThreads = {}
    _SliderClearDrag()
    -- Disconnect all tracked connections
    for _, conn in ipairs(self._Connections) do
        SafeDisconnect(conn)
    end
    self._Connections = {}

    if self._MenuToggleConn then SafeDisconnect(self._MenuToggleConn); self._MenuToggleConn=nil end
    if self._ActiveDropdownCloseConn then SafeDisconnect(self._ActiveDropdownCloseConn); self._ActiveDropdownCloseConn=nil end
    if self._ActiveColorPickerCloseConn then SafeDisconnect(self._ActiveColorPickerCloseConn); self._ActiveColorPickerCloseConn=nil end
    if self._KeybindSettingsCloseConn then SafeDisconnect(self._KeybindSettingsCloseConn); self._KeybindSettingsCloseConn=nil end
    if self._KeybindSettingsKeyConn then SafeDisconnect(self._KeybindSettingsKeyConn); self._KeybindSettingsKeyConn=nil end

    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end

    -- Clear state tables
    local toNil = {}
    for k in pairs(self) do
        if type(k)=="string" and k:sub(1,1)=="_" then toNil[#toNil+1]=k end
    end
    for _,k in ipairs(toNil) do self[k]=nil end
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// CONFIG SYSTEM  (v7.1)
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--[[
    API:
      MIDNIGHT:SetupConfig(key)           -- set save-file key (call once, before MakeWindow)
      MIDNIGHT:SaveConfig()               -- write current widget values to file
      MIDNIGHT:LoadConfig()               -- read file and push values back to widgets
      MIDNIGHT:ResetConfig()              -- delete saved file

    Each widget that participates in config must pass a Flag = "unique_string" in its
    config table. Supported widget types: Toggle, Slider, Dropdown, InlineDropdown,
    TextBox, ColorPicker, InlineColorPicker, Keybind, Table.

    Internal registration:
      MIDNIGHT:_RegCfgWidget(flag, getter, setter, wtype)
]]

function MIDNIGHT:SetupConfig(key)
    assert(type(key) == "string" and #key > 0, "SetupConfig: key must be a non-empty string")
    self._ConfigKey = key
    self._ConfigWidgets = self._ConfigWidgets or {}
end

-- Internal: called by each widget that has a Flag
function MIDNIGHT:_RegCfgWidget(flag, getter, setter, wtype)
    if not flag or flag == "" then return end
    self._ConfigWidgets = self._ConfigWidgets or {}
    self._ConfigWidgets[flag] = { get = getter, set = setter, wtype = wtype }
end

local function _cfgSerialize(val, wtype)
    if wtype == "toggle" then
        return val and "true" or "false"
    elseif wtype == "slider" then
        return tostring(val)
    elseif wtype == "dropdown" then
        if type(val) == "table" then
            -- multiselect: join with \n
            local parts = {}
            for _, v in ipairs(val) do parts[#parts+1] = tostring(v) end
            return "multi:"..table.concat(parts, "\n")
        end
        return tostring(val)
    elseif wtype == "textbox" then
        -- escape newlines so one entry = one line
        return (tostring(val):gsub("\n", "\\n"))
    elseif wtype == "color" then
        if typeof(val) == "Color3" then
            return string.format("%d,%d,%d",
                math.round(val.R*255),
                math.round(val.G*255),
                math.round(val.B*255))
        end
        return "96,190,255"
    elseif wtype == "keybind" then
        if typeof(val) == "EnumItem" then
            return KeyCodeToName(val)
        end
        return tostring(val or "Unknown")
    elseif wtype == "table" then
        if type(val) == "table" then
            local ok, encoded = pcall(function()
                return HttpService:JSONEncode(val)
            end)
            if ok and encoded then
                return "json:" .. encoded
            end
        end
        return "json:[]"
    end
    return tostring(val)
end

local function _cfgDeserialize(raw, wtype)
    if wtype == "toggle" then
        return raw == "true"
    elseif wtype == "slider" then
        return tonumber(raw)
    elseif wtype == "dropdown" then
        if raw:sub(1,6) == "multi:" then
            local list = {}
            for item in (raw:sub(7).."\n"):gmatch("([^\n]*)\n") do
                if item ~= "" then list[#list+1] = item end
            end
            return list
        end
        return raw
    elseif wtype == "textbox" then
        return raw:gsub("\\n", "\n")
    elseif wtype == "color" then
        local r,g,b = raw:match("(%d+),(%d+),(%d+)")
        if r then return Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b)) end
        return nil
    elseif wtype == "keybind" then
        return raw  -- pass the key name string; widget's Set() accepts it
    elseif wtype == "table" then
        local payload = raw:sub(1,5) == "json:" and raw:sub(6) or raw
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(payload)
        end)
        if ok and type(decoded) == "table" then
            return decoded
        end
        return nil
    end
    return raw
end

function MIDNIGHT:SaveConfig()
    if not self._ConfigKey then
        warn("MIDNIGHT:SaveConfig() called without SetupConfig(key)")
        return false
    end
    local lines = {}
    for flag, w in pairs(self._ConfigWidgets) do
        local ok, val = pcall(w.get)
        if ok and val ~= nil then
            local raw = _cfgSerialize(val, w.wtype)
            -- store as "flag=value" (flag may not contain '=')
            lines[#lines+1] = flag.."="..raw
        end
    end
    local content = table.concat(lines, "\n")
    local fname = "midnight_cfg_"..self._ConfigKey..".txt"
    local ok, err = pcall(function()
        if writefile then
            writefile(fname, content)
        else
            -- Fallback: store in hidden attribute on ScreenGui (session-only)
            if self._ScreenGui then
                self._ScreenGui:SetAttribute("_cfg_"..self._ConfigKey, content)
            end
        end
    end)
    if not ok then
        warn("MIDNIGHT:SaveConfig() write error: "..tostring(err))
        return false
    end
    return true
end

function MIDNIGHT:LoadConfig()
    if not self._ConfigKey then
        warn("MIDNIGHT:LoadConfig() called without SetupConfig(key)")
        return false
    end
    local fname = "midnight_cfg_"..self._ConfigKey..".txt"
    local content = nil
    pcall(function()
        if readfile then
            content = readfile(fname)
        elseif self._ScreenGui then
            content = self._ScreenGui:GetAttribute("_cfg_"..self._ConfigKey)
        end
    end)
    if not content or content == "" then return false end

    -- Parse key=value lines (value may contain '=')
    for line in (content.."\n"):gmatch("([^\n]*)\n") do
        if line ~= "" then
            local flag, raw = line:match("^([^=]+)=(.*)")
            if flag and raw and self._ConfigWidgets[flag] then
                local w = self._ConfigWidgets[flag]
                local val = _cfgDeserialize(raw, w.wtype)
                if val ~= nil then
                    pcall(w.set, val)
                end
            end
        end
    end
    return true
end

function MIDNIGHT:ResetConfig()
    if not self._ConfigKey then return false end
    local fname = "midnight_cfg_"..self._ConfigKey..".txt"
    pcall(function()
        if delfile then delfile(fname)
        elseif self._ScreenGui then
            self._ScreenGui:SetAttribute("_cfg_"..self._ConfigKey, nil)
        end
    end)
    return true
end

--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
--// EXPOSE KEY UTILS
--// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
MIDNIGHT.KeyUtils = KeyUtils
MIDNIGHT.LucideIcons = LucideIcons
MIDNIGHT.LucideBloxAssets = LucideBloxAssets

return MIDNIGHT
