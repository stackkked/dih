--[[
    MIDNIGHT UI Library v6.4.0 → v6.9.0
    Styled after the MIDNIGHT CS2 Cheat
    For Roblox Executors

    v6.9 Changelog:
    - FIX: _MenuOpen now starts as false — menu opens on first keypress (was requiring two presses)
    - FIX: _MenuOpen in Reset() was incorrectly set to true — now false (menu starts closed after reset)
    - FIX: _MenuOpen syncs with MakeWindow — set to true after creation since window IS visible
    - FIX: KeyCodeToName gsub order — ^Left/^Right now runs before Return→Enter, preventing "LEnter"
    - FIX: CreateWatermark now calls _UpdateWatermark() at end, so SetWatermarkText called before CreateWatermark works immediately
    - FIX: KeybindSettings key listener (conn2) now disconnected when panel closes without key selection
    - FIX: task.cancel now checks typeof(th)=="thread" before calling (executor compat)
    - FIX: Close button also uses typeof thread check for task.cancel
    - FIX: Menu open animation no longer resets Size to 0 — just fade in with BackgroundTransparency (prevents ClipsDescendants clipping content)
    - FIX: MakeWindow creation animation simplified to fade-in only (no Size=0 reset that clips all child content)
    - FIX: Menu close animation also uses fade-out only — no Size tween to 0 (prevents stuck 0x0 size on next open)
    - FIX: Window frame (wf) and TitleBar (tb) now have Active=true — Frames receive input, child buttons work
    - FIX: TitleBar ClipsDescendants=false — drag input works properly on empty title bar areas
    - FIX: Close button handler now cancels pending close threads before resetting _MenuCloseThreads (prevents orphaned threads)
    - FIX: MakeWindow sets BackgroundTransparency=0 explicitly before tween (executor safety net for unreliable TweenService)

    v6.8 Changelog:
    - FIX: _global_wait nil check in delay fallback — no crash if global wait unavailable
    - FIX: ThemeCallbacks cbIdx replaced with reference-based removal (prevents wrong callback deletion)
    - FIX: _RepositionNotifications passes real notification index instead of hardcoded 1
    - FIX: AddToggle OnModeChange now updates local bindMode variable
    - FIX: Menu double-tap race condition — pending close-delay threads are cancelled on reopen
    - FIX: Close button also tracks close-delay threads for proper cancellation

    v6.7 Changelog:
    - FIX: task.wait fallback — local `task` was nil during table init, causing no-op wait
    - FIX: AddInlineColorPicker — `data` declared after preset closures, caused nil error on preset click
    - FIX: _ShowKeybindSettings ThemeCallbacks accumulated on every open — now tracked and removed on close
    - FIX: AddKeybind modeLbl.Text not updating when mode changes externally (kd._Mode)
    - FIX: Notify dismiss could fire twice (timer + close button) — added dismissed guard flag
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
    - CRITICAL: Removed pcall(Instance.new, ...) — errors are visible now
    - ARCH: ZIndex constants table (ZIndex = { WINDOW, POPUP, OVERLAY, ... })
    - ARCH: Added MIDNIGHT:Reset() — full state reset without recreating GUI
    - ARCH: Added MIDNIGHT.Version = "6.4.0"
    - WIDGETS: AddTextBox — new widget
    - WIDGETS: AddButton — proper standalone widget
    - WIDGETS: AddDropdown inline (no popup) — for simple cases
    - WIDGETS: AddColorPicker inline in tab
    - WIDGETS: AddSeparator — visual separator with gradient fade
    - UX: Icon cache — icons loaded once, reused
    - UX: tab:SetVisible(bool) — hide/show tabs dynamically
    - UX: MIDNIGHT:SetWatermarkText(text) — custom watermark text
    - UX: Notifications — close (✕) button on each notification
    - MISC: ParseKeyCode / KeyCodeToName moved to top-level module (KeyUtils)
    - MISC: MIDNIGHT.Version for version checking
    - SLIDER: Manual value input on label click → TextBox
    - UI: Gradient accent line (darker edges → bright center)
    - UI: Hover left border (2px) on items
    - UI: Active tab — UIStroke glow
    - UI: Scrollbar auto-hide (appears on scroll, fades after 1.5s)
    - UI: Toggle flash animation on knob
    - UI: Slider knob tooltip on drag
    - UI: Notification icon scale 0→1 with Back easing
    - UI: Separator with gradient fade
    - TYPO: TextSecondary labels 12px (was 11px)
    - TYPO: Slider value right-aligned, fixed width
    - TYPO: Section name letter-spacing (spaces between chars)
    - TYPO: Keybind badge — InputBg bg, rounded corners
    - ANIM: Window open — BackgroundTransparency 1→0 simultaneously
    - ANIM: Popup close 0.1s (was 0.15s)
    - ANIM: Tab switch — slide content
    - ANIM: Watermark lagspike blink tween
    - STRUCT: Sidebar tab grouping separator if tabs > 6
    - STRUCT: Sidebar footer: version + ping/fps
    - STRUCT: Empty tab placeholder text "No items"
]]

--// ═══════════════════════════════════════════════════════════
--// SERVICES
--// ═══════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
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

--// ═══════════════════════════════════════════════════════════
--// Z-INDEX CONSTANTS
--// ═══════════════════════════════════════════════════════════
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

--// ═══════════════════════════════════════════════════════════
--// THEME
--// ═══════════════════════════════════════════════════════════
local Theme = {
    WindowBg       = Color3.fromRGB(18, 18, 23),
    SidebarBg      = Color3.fromRGB(20, 20, 26),
    ContentBg      = Color3.fromRGB(23, 23, 30),
    TabBg          = Color3.fromRGB(26, 26, 34),
    TabHoverBg     = Color3.fromRGB(32, 32, 42),
    TabActiveBg    = Color3.fromRGB(36, 36, 48),
    ItemBg         = Color3.fromRGB(26, 26, 34),
    ItemHoverBg    = Color3.fromRGB(32, 32, 42),
    InputBg        = Color3.fromRGB(30, 30, 38),
    DropdownBg     = Color3.fromRGB(24, 24, 31),
    TitleBarBg     = Color3.fromRGB(20, 20, 26),
    Accent         = Color3.fromRGB(139, 92, 246),
    AccentHover    = Color3.fromRGB(167, 139, 250),
    AccentDark     = Color3.fromRGB(109, 62, 216),
    TextPrimary    = Color3.fromRGB(240, 240, 245),
    TextSecondary  = Color3.fromRGB(165, 165, 180),
    TextMuted      = Color3.fromRGB(90, 90, 108),
    TextAccent     = Color3.fromRGB(167, 139, 250),
    Border         = Color3.fromRGB(42, 42, 54),
    BorderLight    = Color3.fromRGB(54, 54, 68),
    BorderAccent   = Color3.fromRGB(80, 60, 140),
    ToggleOn       = Color3.fromRGB(139, 92, 246),
    ToggleOff      = Color3.fromRGB(46, 46, 58),
    ToggleKnob     = Color3.fromRGB(255, 255, 255),
    SliderTrack    = Color3.fromRGB(38, 38, 50),
    SliderFill     = Color3.fromRGB(139, 92, 246),
    SliderKnob     = Color3.fromRGB(255, 255, 255),
    Success        = Color3.fromRGB(74, 222, 128),
    Warning        = Color3.fromRGB(250, 204, 21),
    Error          = Color3.fromRGB(248, 113, 113),
    Info           = Color3.fromRGB(139, 92, 246),
    WatermarkBg    = Color3.fromRGB(18, 18, 23),
    KeybindBg      = Color3.fromRGB(18, 18, 23),
    CloseNormal    = Color3.fromRGB(46, 46, 58),
    CloseHover     = Color3.fromRGB(180, 40, 40),
    MinNormal      = Color3.fromRGB(46, 46, 58),
    MinHover       = Color3.fromRGB(60, 60, 100),
    ScrollBarColor = Color3.fromRGB(62, 62, 76),
    ScrollBarBg    = Color3.fromRGB(32, 32, 38),
    Shadow         = Color3.fromRGB(0, 0, 0),
    SeparatorBg    = Color3.fromRGB(42, 42, 54),
}

local Font        = Enum.Font.GothamSemibold
local FontBold    = Enum.Font.GothamBold
local FontRegular = Enum.Font.Gotham

--// ═══════════════════════════════════════════════════════════
--// KEY UTILS MODULE
--// ═══════════════════════════════════════════════════════════
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

--// ═══════════════════════════════════════════════════════════
--// UTILITY FUNCTIONS
--// ═══════════════════════════════════════════════════════════

local function Create(className, props, children)
    local inst = Instance.new(className)
    local parent = nil
    if props then
        parent = props.Parent
        props.Parent = nil
        for k, v in pairs(props) do
            if type(k) == "string" then
                local ok, err = pcall(function() inst[k] = v end)
                if not ok then warn("[MIDNIGHT] Property '" .. tostring(k) .. "' on " .. className .. ": " .. tostring(err)) end
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
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 4), Parent = parent})
end

local function ApplyStroke(parent, color, thickness, transparency)
    if not parent then return nil end
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function ApplyPadding(parent, top, bottom, left, right)
    if not parent then return nil end
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 4),
        PaddingBottom = UDim.new(0, bottom or 4),
        PaddingLeft   = UDim.new(0, left   or 4),
        PaddingRight  = UDim.new(0, right  or 4),
        Parent = parent
    })
end

local function TweenObject(inst, props, duration, style, dir)
    if not inst or not inst.Parent then return nil end
    local ok, t = pcall(TweenService.Create, TweenService, inst,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props)
    if ok and t then t:Play(); return t end
    return nil
end

-- Gradient accent line (dark edges → bright center)
local function CreateAccentLine(parent, radius, color)
    if not parent then return nil end
    local inset = math.min(radius or 6, 4)
    local line = Create("Frame", {
        Size     = UDim2.new(1, -(inset * 2), 0, 2),
        Position = UDim2.new(0, inset, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
        ZIndex = ZIndex.CONTENT,
        Parent = parent,
    })
    local accent = color or Theme.Accent
    local dark   = Color3.fromRGB(
        math.floor(accent.R * 255 * 0.45),
        math.floor(accent.G * 255 * 0.45),
        math.floor(accent.B * 255 * 0.45)
    )
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   dark),
            ColorSequenceKeypoint.new(0.5, accent),
            ColorSequenceKeypoint.new(1,   dark),
        }),
        Rotation = 0,
        Parent = line,
    })
    pcall(function() parent.ClipsDescendants = true end)
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
    local dragging, dragInput, dragStart, startPos
    RegConn(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            if onDragStart then onDragStart() end
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
local function ApplyHoverEffect(frame, normalBg, hoverBg, withBorder)
    if not frame then return end
    local borderLine
    if withBorder then
        borderLine = Create("Frame", {
            Size = UDim2.new(0, 2, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = frame.ZIndex + 1,
            Parent = frame,
        })
        ApplyCorner(borderLine, 1)
    end
    frame.MouseEnter:Connect(function()
        TweenObject(frame, {BackgroundColor3 = hoverBg}, 0.18)
        if borderLine then TweenObject(borderLine, {BackgroundTransparency = 0}, 0.18) end
    end)
    frame.MouseLeave:Connect(function()
        TweenObject(frame, {BackgroundColor3 = normalBg}, 0.18)
        if borderLine then TweenObject(borderLine, {BackgroundTransparency = 1}, 0.18) end
    end)
end

local function LightenColor(color, amount)
    amount = amount or 28
    return Color3.fromRGB(
        math.min(255, math.floor(color.R * 255 + amount)),
        math.min(255, math.floor(color.G * 255 + amount)),
        math.min(255, math.floor(color.B * 255 + amount))
    )
end

local function DarkenColor(color, amount)
    amount = amount or 30
    return Color3.fromRGB(
        math.max(0, math.floor(color.R * 255 - amount)),
        math.max(0, math.floor(color.G * 255 - amount)),
        math.max(0, math.floor(color.B * 255 - amount))
    )
end

local function AccentTint(color, factor)
    factor = factor or 0.15
    return Color3.fromRGB(
        math.floor(color.R * 255 * factor),
        math.floor(color.G * 255 * factor),
        math.floor(color.B * 255 * factor)
    )
end

local function LetterSpace(text)
    -- Insert spaces between characters for section headings
    local result = {}
    for i = 1, #text do result[i] = text:sub(i,i) end
    return table.concat(result, " ")
end

--// ═══════════════════════════════════════════════════════════
--// ICON SYSTEM WITH CACHE + LUCIDE INTEGRATION
--// ═══════════════════════════════════════════════════════════
local IconCache     = {}  -- name → url (already resolved)
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
    ["chevron-right"]   = "›",
    ["chevron-down"]    = "∨",
    ["chevron-up"]      = "∧",
    ["chevron-left"]    = "‹",
    ["chevrons-right"]  = "»",
    ["chevrons-down"]   = "⇓",
    ["arrow-right"]     = "→",
    ["arrow-left"]      = "←",
    ["arrow-up"]        = "↑",
    ["arrow-down"]      = "↓",
    ["arrow-up-right"]  = "↗",
    ["move"]            = "✥",
    ["expand"]          = "⤢",
    ["shrink"]          = "⤡",
    ["maximize"]        = "⛶",
    ["minimize"]        = "─",
    ["x"]               = "✕",
    ["plus"]            = "+",
    ["minus"]           = "−",
    ["more-horizontal"] = "⋯",
    ["more-vertical"]   = "⋮",
    ["menu"]            = "☰",
    ["hash"]            = "#",
    ["search"]          = "⌕",
    ["filter"]          = "◅",
    ["sort-asc"]        = "↑",
    ["sort-desc"]       = "↓",

    -- Media / Objects
    ["moon"]            = "☾",
    ["sun"]             = "☀",
    ["star"]            = "★",
    ["heart"]           = "♥",
    ["eye"]             = "◉",
    ["eye-off"]         = "◈",
    ["lock"]            = "⊘",
    ["unlock"]          = "⊙",
    ["key"]             = "⚷",
    ["shield"]          = "◆",
    ["shield-check"]    = "✓",
    ["bell"]            = "🔔",
    ["bookmark"]        = "🔖",
    ["flag"]            = "⚑",
    ["zap"]             = "⚡",
    ["flame"]           = "🔥",
    ["sparkles"]        = "✦",
    ["crown"]           = "♛",
    ["gem"]             = "◈",
    ["trophy"]          = "🏆",
    ["target"]          = "◎",
    ["crosshair"]       = "⊕",
    ["circle-dot"]      = "⊘",
    ["scan"]            = "⌗",
    ["focus"]           = "◎",
    ["radar"]           = "◉",

    -- Settings / Tools
    ["settings"]        = "⚙",
    ["sliders"]         = "≡",
    ["wrench"]          = "🔧",
    ["hammer"]          = "🔨",
    ["tool"]            = "⚒",
    ["cpu"]             = "▣",
    ["gauge"]           = "⊘",
    ["activity"]        = "⁓",
    ["wifi"]            = "☋",
    ["radio"]           = "◉",
    ["terminal"]        = ">_",
    ["code"]            = "</>",

    -- Status / Feedback
    ["check"]           = "✓",
    ["check-circle"]    = "✓",
    ["x-circle"]        = "✕",
    ["alert-circle"]    = "!",
    ["alert-triangle"]  = "⚠",
    ["info"]            = "ⓘ",
    ["help-circle"]     = "?",
    ["ban"]             = "⊘",
    ["alert-octagon"]   = "⬡",

    -- Communication
    ["message-circle"]  = "💬",
    ["send"]            = "➤",
    ["mail"]            = "✉",
    ["volume-2"]        = "🔊",
    ["volume-x"]        = "🔇",
    ["mic"]             = "🎤",
    ["mic-off"]         = "🚫",

    -- Users / People
    ["user"]            = "👤",
    ["users"]           = "👥",
    ["user-plus"]       = "+👤",
    ["user-minus"]      = "−👤",
    ["user-check"]      = "✓👤",

    -- Map / World
    ["map"]             = "🗺",
    ["map-pin"]         = "📍",
    ["globe"]           = "🌐",
    ["compass"]         = "🧭",
    ["navigation"]      = "➤",

    -- Gaming
    ["swords"]          = "⚔",
    ["gamepad-2"]       = "🎮",
    ["joystick"]        = "🕹",
    ["puzzle"]          = "🧩",
    ["dice"]            = "🎲",

    -- Misc
    ["palette"]         = "🎨",
    ["paintbrush"]      = "🖌",
    ["image"]           = "🖼",
    ["camera"]          = "📷",
    ["music"]           = "♫",
    ["clock"]           = "🕐",
    ["timer"]           = "⏱",
    ["calendar"]        = "📅",
    ["file-text"]       = "📄",
    ["clipboard"]       = "📋",
    ["download"]        = "↓",
    ["upload"]          = "↑",
    ["link"]            = "🔗",
    ["external-link"]   = "↗",
    ["copy"]            = "⧉",
    ["trash"]           = "🗑",
    ["refresh-cw"]      = "↻",
    ["rotate-ccw"]      = "↺",
    ["power"]           = "⏻",
    ["log-out"]         = "⏻",
    ["home"]            = "⌂",
    ["database"]        = "⛁",
    ["server"]          = "◫",
    ["hard-drive"]      = "▦",
    ["folder"]          = "📁",
    ["package"]         = "📦",
    ["box"]             = "☐",
    ["layers"]          = "☰",
    ["grid"]            = "▦",
    ["layout"]          = "◧",
    ["sidebar"]         = "◧",
    ["panel-left"]      = "◧",
    ["panel-right"]     = "◧",

    -- Legacy aliases (old names → Lucide names)
    ["chevron_r"]       = "›",
    ["chevron_d"]       = "∨",
    ["warn"]            = "⚠",
}

--// ═══════════════════════════════════════════════════════════
--// LUCIDEBLOX ASSET MAP
--// Pre-uploaded Lucide icons as Roblox image assets (rbxassetid://)
--// Source: https://github.com/frappedevs/lucideblox
--// Call MIDNIGHT:UseLucideBlox() to activate these icons automatically
--// ═══════════════════════════════════════════════════════════
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

local function GetLucideFallback(iconName)
    if not iconName then return nil end
    -- Direct lookup
    if LucideIcons[iconName] then return LucideIcons[iconName] end
    -- Try kebab-case conversion: "chevronRight" → "chevron-right"
    local kebab = iconName:gsub("([a-z])([A-Z])", function(a,b) return a.."-"..b:lower() end):lower()
    if LucideIcons[kebab] then return LucideIcons[kebab] end
    return nil
end

local function GetIconURL(iconName)
    if not iconName then return "" end
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
        text = GetLucideFallback(iconName)
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
        Size = size or UDim2.new(0, 16, 0, 16),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = parent,
    })
end

--// ═══════════════════════════════════════════════════════════
--// MIDNIGHT LIBRARY
--// ═══════════════════════════════════════════════════════════
local MIDNIGHT = {
    Version = "6.9.0",

    _ScreenGui  = nil,
    _Windows    = {},
    _Notifications = {},
    _Keybinds   = {},
    _Connections = {},   -- ALL connections stored here for Destroy()

    _NotificationPosition = "TopRight",
    _MenuKey    = Enum.KeyCode.RightShift,
    _MenuKeyStr = "RShift",
    _MenuOpen   = false,
    _MenuToggleConn = nil,

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
    _KeybindSettingsCb      = nil,
    _MenuCloseThreads       = {},
}

--// Helper: register a connection for cleanup
RegConn = function(conn)
    if conn then
        table.insert(MIDNIGHT._Connections, conn)
    end
    return conn
end

--// ═══════════════════════════════════════════════════════════
--// ICON CONFIGURATION
--// ═══════════════════════════════════════════════════════════
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
    for k, v in pairs(iconTable) do
        if type(k) == "string" and type(v) == "string" then
            IconOverrides[k] = v
            IconCache[k] = v -- update cache immediately
        end
    end
end

--// ═══════════════════════════════════════════════════════════
--// LUCIDE ICON CONFIGURATION
--// ═══════════════════════════════════════════════════════════
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
    -- Returns the full LucideIcons map (icon name → fallback character)
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
    -- Returns the full LucideBloxAssets map (icon name → rbxassetid:// URL)
    -- Useful for reference or to selectively override specific icons
    return LucideBloxAssets
end

--// ═══════════════════════════════════════════════════════════
--// THEME
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:SetThemeColor(color)
    if not color then return end
    Theme.Accent       = color
    Theme.AccentHover  = LightenColor(color, 28)
    Theme.AccentDark   = DarkenColor(color, 30)
    Theme.ToggleOn     = color
    Theme.SliderFill   = color
    Theme.TextAccent   = LightenColor(color, 28)
    Theme.BorderAccent = Color3.fromRGB(
        math.floor(color.R * 255 * 0.57),
        math.floor(color.G * 255 * 0.43),
        math.floor(color.B * 255 * 0.8)
    )
    Theme.Info = color
    for _, cb in ipairs(self._ThemeCallbacks) do pcall(cb, color) end
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
end

--// ═══════════════════════════════════════════════════════════
--// SCREENGUI
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:_InitScreenGui()
    if self._ScreenGui and self._ScreenGui.Parent then return end
    self._ScreenGui = Create("ScreenGui", {
        Name = "MIDNIGHT_" .. tostring(tick()):gsub("%.", ""),
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

--// ═══════════════════════════════════════════════════════════
--// FPS + PING TRACKER
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:_InitFPSTracker()
    local conn = RunService.Heartbeat:Connect(function()
        self._FPSCounter = self._FPSCounter + 1
        local now = tick()
        if now - self._LastFPSTick >= 1 then
            self._FPS       = self._FPSCounter
            self._Lagspike  = self._FPS < 30
            self._FPSCounter = 0
            self._LastFPSTick = now
            pcall(function()
                self._Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            self:_UpdateWatermark()
            self:_UpdateSidebarFooters()
        end
    end)
    RegConn(conn)
end

--// ═══════════════════════════════════════════════════════════
--// SIDEBAR FOOTERS (version + fps/ping per window)
--// ═══════════════════════════════════════════════════════════
MIDNIGHT._SidebarFooters = {}

function MIDNIGHT:_UpdateSidebarFooters()
    for _, footer in ipairs(self._SidebarFooters) do
        if footer and footer.Parent then
            footer.Text = "v" .. self.Version .. "  |  " .. self._FPS .. " fps  " .. self._Ping .. "ms"
        end
    end
end

--// ═══════════════════════════════════════════════════════════
--// RESET
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:Reset()
    -- Disconnect all connections
    for _, conn in ipairs(self._Connections) do
        pcall(function() conn:Disconnect() end)
    end
    self._Connections = {}
    -- Destroy GUI
    if self._ScreenGui then
        pcall(function() self._ScreenGui:Destroy() end)
        self._ScreenGui = nil
    end
    -- Reset state
    self._Windows = {}; self._Notifications = {}; self._Keybinds = {}
    self._Initialized = false; self._MenuOpen = false
    self._WatermarkFrame = nil; self._KeybindListFrame = nil
    self._KeybindListContent = nil; self._RefreshKeybindList = nil
    self._ActiveDropdown = nil; self._ActiveColorPicker = nil
    self._KeybindSettingsFrame = nil; self._KeybindSettingsBg = nil
    self._SidebarFooters = {}
    self._ThemeCallbacks = {}
    -- Re-initialize
    self:_InitScreenGui()
end

--// ═══════════════════════════════════════════════════════════
--// POPUP MANAGER
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:_CloseAllPopups()
    self:_CloseDropdown()
    self:_CloseColorPicker()
    self:_CloseKeybindSettings()
end

--// ═══════════════════════════════════════════════════════════
--// KEYBIND SETTINGS PANEL
--// ═══════════════════════════════════════════════════════════
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

    local panelW, panelHFinal = 200, 158

    local vpSize = workspace.CurrentCamera.ViewportSize
    local posX = position.X + 4
    local posY = position.Y
    if posX + panelW > vpSize.X then posX = position.X - panelW - 4 end
    if posY + panelHFinal > vpSize.Y then posY = vpSize.Y - panelHFinal - 8 end
    if posY < 8 then posY = 8 end

    local bgFill = Create("Frame", {
        Name = "KeybindSettingsBg",
        Size = UDim2.new(0, panelW, 0, panelHFinal),
        Position = UDim2.new(0, posX, 0, posY),
        BackgroundColor3 = Theme.WindowBg,
        BorderSizePixel  = 0,
        BackgroundTransparency = 1,
        Active = false,
        ZIndex = ZIndex.POPUP,
        Parent = self._ScreenGui,
    })
    ApplyCorner(bgFill, 8)
    ApplyStroke(bgFill, Theme.BorderAccent, 1)

    local pf = Create("Frame", {
        Name = "KeybindSettings",
        Size = UDim2.new(0, panelW, 0, panelHFinal),
        Position = UDim2.new(0, posX, 0, posY),
        BackgroundColor3 = Theme.WindowBg,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = ZIndex.POPUP + 1,
        Parent = self._ScreenGui,
    })
    ApplyCorner(pf, 8)
    ApplyStroke(pf, Theme.BorderAccent, 1)

    local accentLine = CreateAccentLine(pf, 8)
    local accentCb = function(color)
        if accentLine then
            accentLine.BackgroundColor3 = color
        end
    end
    table.insert(self._ThemeCallbacks, accentCb)
    self._KeybindSettingsCb = accentCb

    ApplyPadding(pf, 10, 10, 10, 10)

    -- Title row
    local titleRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = ZIndex.POPUP + 2,
        Parent = pf,
    })
    CreateIconOrText(titleRow, "settings", nil, UDim2.new(0,12,0,12), UDim2.new(0,0,0,4), Theme.Accent, FontBold, 11)
    Create("TextLabel", {
        Text = "Keybind Settings", Font = FontBold, TextSize = 11,
        TextColor3 = Theme.Accent,
        Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0,16,0,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP + 2, Parent = titleRow,
    })

    local closeX = Create("TextButton", {
        Text = "✕", Font = FontBold, TextSize = 11,
        TextColor3 = Theme.TextMuted,
        Size = UDim2.new(0,22,0,18), Position = UDim2.new(1,-24,0,1),
        BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
        ZIndex = ZIndex.TOP, Active = true, Parent = pf,
    })
    ApplyCorner(closeX, 4)
    closeX.MouseEnter:Connect(function() TweenObject(closeX, {BackgroundColor3=Theme.CloseHover, TextColor3=Color3.fromRGB(255,255,255)}, 0.12) end)
    closeX.MouseLeave:Connect(function() TweenObject(closeX, {BackgroundColor3=Theme.InputBg, TextColor3=Theme.TextMuted}, 0.12) end)
    closeX.MouseButton1Click:Connect(function()
        self:_CloseKeybindSettings()
        if onClose then onClose() end
    end)

    -- KEY label
    Create("TextLabel", {
        Text = "KEY", Font = FontBold, TextSize = 8,
        TextColor3 = Theme.TextMuted, Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,24),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })

    local keyBtn = Create("TextButton", {
        Text = "[ " .. currentKeyStr .. " ]",
        Font = FontBold, TextSize = 11,
        TextColor3 = Theme.Accent,
        Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,36),
        BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
        ZIndex = ZIndex.POPUP+2, Parent = pf,
    })
    ApplyCorner(keyBtn, 5); ApplyStroke(keyBtn, Theme.Border, 1)

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
                keyBtn.Text = "[ " .. ns .. " ]"; keyBtn.TextColor3 = Theme.Accent
                listening = false; conn2:Disconnect()
                if onKeyChange then onKeyChange(inp.KeyCode, ns) end
            end
        end)
        RegConn(conn2)
        -- Auto-cleanup if panel is destroyed while listening
        if pf and pf.Destroying then
            pf.Destroying:Connect(function() if conn2 then conn2:Disconnect() end; listening = false end)
        end
        -- Store conn2 reference so _CloseKeybindSettings can disconnect it
        self._KeybindSettingsKeyConn = conn2
        self._KeybindSettingsListening = true
    end)

    -- MODE label
    Create("TextLabel", {
        Text = "MODE", Font = FontBold, TextSize = 8,
        TextColor3 = Theme.TextMuted, Size = UDim2.new(1,0,0,12),
        Position = UDim2.new(0,0,0,68),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })

    local modeRow = Create("Frame", {
        Size = UDim2.new(1,0,0,26), Position = UDim2.new(0,0,0,80),
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+2, Parent = pf,
    })
    local pressBtn = Create("TextButton", {
        Text = "Press", Font = FontBold, TextSize = 10,
        TextColor3 = currentMode=="Press" and Color3.fromRGB(255,255,255) or Theme.TextSecondary,
        Size = UDim2.new(0.5,-2,1,0), Position = UDim2.new(0,0,0,0),
        BackgroundColor3 = currentMode=="Press" and Theme.Accent or Theme.InputBg,
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+3, Parent = modeRow,
    })
    ApplyCorner(pressBtn, 5)
    local holdBtn = Create("TextButton", {
        Text = "Hold", Font = FontBold, TextSize = 10,
        TextColor3 = currentMode=="Hold" and Color3.fromRGB(255,255,255) or Theme.TextSecondary,
        Size = UDim2.new(0.5,-2,1,0), Position = UDim2.new(0.5,2,0,0),
        BackgroundColor3 = currentMode=="Hold" and Theme.Accent or Theme.InputBg,
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+3, Parent = modeRow,
    })
    ApplyCorner(holdBtn, 5)

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
    ApplyCorner(visRow, 5); ApplyPadding(visRow,0,0,8,8)
    Create("TextLabel", {
        Text = "Show in Keybind List", Font = Font, TextSize = 10,
        TextColor3 = Theme.TextSecondary, Size = UDim2.new(0.65,0,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = ZIndex.POPUP+3, Parent = visRow,
    })
    local visToggle = Create("Frame", {
        Size = UDim2.new(0,32,0,16), Position = UDim2.new(1,-36,0.5,-8),
        BackgroundColor3 = currentVisible and Theme.Accent or Theme.ToggleOff,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = ZIndex.POPUP+3, Parent = visRow,
    })
    ApplyCorner(visToggle, 8)
    local visKnob = Create("Frame", {
        Size = UDim2.new(0,12,0,12),
        Position = UDim2.new(0, currentVisible and 18 or 2, 0.5,-6),
        BackgroundColor3 = Color3.fromRGB(230,230,240),
        BorderSizePixel = 0, ZIndex = ZIndex.POPUP+4, Parent = visToggle,
    })
    ApplyCorner(visKnob, 6)
    local visState = currentVisible
    -- Use a transparent TextButton overlay so clicks work in all executors
    local visBtn = Create("TextButton", {
        Text = "", Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Active = true, ZIndex = ZIndex.POPUP+5, Parent = visRow,
    })
    visBtn.MouseButton1Click:Connect(function()
        visState = not visState
        TweenObject(visToggle,{BackgroundColor3=visState and Theme.Accent or Theme.ToggleOff},0.22)
        TweenObject(visKnob,{Position=UDim2.new(0,visState and 18 or 2,0.5,-6)},0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
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

--// ═══════════════════════════════════════════════════════════
--// DROPDOWN POPUP
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:_CloseDropdown()
    if self._ActiveDropdown then
        local dd = self._ActiveDropdown
        self._ActiveDropdown = nil
        local w = dd.AbsoluteSize.X
        TweenObject(dd, {Size=UDim2.new(0,w,0,0)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.12, function() pcall(function() dd:Destroy() end) end)
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

    local absPos    = config.ButtonPos
    local absSize   = config.ButtonSize
    local opts      = config.Options
    local currentSel = config.Current
    local onSelect  = config.OnSelect
    local dropdownBtn = config.DropdownBtn
    local listH = #opts * 26 + 8

    local vpSize = workspace.CurrentCamera.ViewportSize
    local posX = absPos.X
    local posY = absPos.Y + absSize.Y
    if posX + absSize.X > vpSize.X then posX = vpSize.X - absSize.X - 8 end
    if posX < 8 then posX = 8 end
    if posY + listH > vpSize.Y then posY = absPos.Y - listH - 4 end
    if posY < 8 then posY = 8 end

    if dropdownBtn then TweenObject(dropdownBtn,{BackgroundColor3=Theme.AccentDark},0.15) end

    local dd = Create("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(0,absSize.X,0,0),
        Position = UDim2.new(0,posX,0,posY),
        BackgroundColor3 = Theme.DropdownBg,
        BorderSizePixel = 0, ClipsDescendants = true,
        ZIndex = ZIndex.DROPDOWN,
        Parent = self._ScreenGui,
    })
    ApplyCorner(dd,6); ApplyStroke(dd,Theme.BorderAccent,1)
    ApplyPadding(dd,4,4,4,4)
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=dd})

    for i, opt in ipairs(opts) do
        local isSel = opt == currentSel
        local ob = Create("TextButton",{
            Text = opt, Font = Font, TextSize = 12,
            TextColor3 = isSel and Theme.Accent or Theme.TextSecondary,
            Size = UDim2.new(1,0,0,22),
            BackgroundColor3 = isSel and Theme.TabActiveBg or Theme.InputBg,
            BorderSizePixel = 0, LayoutOrder = i, ZIndex = ZIndex.DROPDOWN+1,
            Parent = dd,
        })
        ApplyCorner(ob,4)
        ApplyHoverEffect(ob, isSel and Theme.TabActiveBg or Theme.InputBg, Theme.ItemHoverBg, false)
        ob.MouseButton1Click:Connect(function() onSelect(opt); self:_CloseDropdown() end)
    end

    TweenObject(dd,{Size=UDim2.new(0,absSize.X,0,listH)},0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
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

--// ═══════════════════════════════════════════════════════════
--// COLOR PICKER POPUP
--// ═══════════════════════════════════════════════════════════
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
    local curColor = config.Current or Color3.fromRGB(139,92,246)
    local onColor  = config.OnColor
    local pickerW, pickerH = 160, 154

    local vpSize = workspace.CurrentCamera.ViewportSize
    local posX = absPos.X
    local posY = absPos.Y + 30
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
    ApplyCorner(pf,8); ApplyStroke(pf,Theme.BorderAccent,1); ApplyPadding(pf,8,8,8,8)

    local presets = {
        Color3.fromRGB(248,113,113), Color3.fromRGB(251,146,60), Color3.fromRGB(250,204,21),
        Color3.fromRGB(74,222,128),  Color3.fromRGB(34,211,238), Color3.fromRGB(96,165,250),
        Color3.fromRGB(139,92,246),  Color3.fromRGB(232,121,249),Color3.fromRGB(255,255,255),
        Color3.fromRGB(160,160,175), Color3.fromRGB(80,80,95),   Color3.fromRGB(20,20,26),
    }
    local grid = Create("Frame",{Size=UDim2.new(1,0,0,80),BackgroundTransparency=1,ZIndex=ZIndex.OVERLAY+1,Parent=pf})
    Create("UIGridLayout",{CellSize=UDim2.new(0,32,0,22),CellPadding=UDim2.new(0,4,0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=grid})
    for i,c in ipairs(presets) do
        local cb = Create("TextButton",{Text="",BackgroundColor3=c,BorderSizePixel=0,LayoutOrder=i,ZIndex=ZIndex.OVERLAY+2,Parent=grid})
        ApplyCorner(cb,4); ApplyStroke(cb,Theme.BorderLight,1)
        cb.MouseButton1Click:Connect(function() onColor(c); self:_CloseColorPicker() end)
    end

    local customRow = Create("Frame",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,ZIndex=ZIndex.OVERLAY+1,Parent=pf})
    Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=customRow})

    local rVal = math.floor(curColor.R*255)
    local gVal = math.floor(curColor.G*255)
    local bVal = math.floor(curColor.B*255)

    local function makeColorInput(label, value, color, layoutOrder)
        local container = Create("Frame",{Size=UDim2.new(0.3,0,1,0),BackgroundTransparency=1,LayoutOrder=layoutOrder,ZIndex=ZIndex.OVERLAY+2,Parent=customRow})
        Create("TextLabel",{Text=label,Font=FontBold,TextSize=9,TextColor3=color,Size=UDim2.new(1,0,0,10),BackgroundTransparency=1,Parent=container})
        local box = Create("TextBox",{Text=tostring(value),Font=Font,TextSize=10,TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,12),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,ZIndex=ZIndex.OVERLAY+3,Parent=container})
        ApplyCorner(box,3)
        return box
    end

    local rBox = makeColorInput("R", rVal, Color3.fromRGB(255,80,80),  1)
    local gBox = makeColorInput("G", gVal, Color3.fromRGB(80,255,80),  2)
    local bBox = makeColorInput("B", bVal, Color3.fromRGB(80,80,255),  3)

    local applyBtn = Create("TextButton",{Text="Apply",Font=FontBold,TextSize=10,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,0,0,20),BackgroundColor3=Theme.Accent,BorderSizePixel=0,ZIndex=ZIndex.OVERLAY+2,Parent=pf})
    ApplyCorner(applyBtn,4)
    applyBtn.MouseButton1Click:Connect(function()
        local r = math.clamp(math.floor(tonumber(rBox.Text) or 0),0,255)
        local g = math.clamp(math.floor(tonumber(gBox.Text) or 0),0,255)
        local b = math.clamp(math.floor(tonumber(bBox.Text) or 0),0,255)
        onColor(Color3.fromRGB(r,g,b)); self:_CloseColorPicker()
    end)

    TweenObject(pf,{Size=UDim2.new(0,pickerW,0,pickerH)},0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
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

--// ═══════════════════════════════════════════════════════════
--// MENU TOGGLE
--// ═══════════════════════════════════════════════════════════
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
                    if th and typeof(th) == "thread" then pcall(function() task.cancel(th) end) end
                end
                self._MenuCloseThreads = {}
            end
            for _, w in ipairs(self._Windows) do
                if w._Frame then
                    if self._MenuOpen then
                        w._Frame.Visible = true
                        w._Frame.BackgroundTransparency = 1
                        TweenObject(w._Frame,{BackgroundTransparency=0},0.35)
                    else
                        TweenObject(w._Frame,{BackgroundTransparency=1},0.2)
                        local th = task.delay(0.25,function() if not self._MenuOpen then w._Frame.Visible=false end end)
                        table.insert(self._MenuCloseThreads, th)
                    end
                end
            end
        end
    end))
end

--// ═══════════════════════════════════════════════════════════
--// WATERMARK
--// ═══════════════════════════════════════════════════════════
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

    local wmFrame = Create("Frame",{
        Name = "Watermark", Size = UDim2.new(0,500,0,28),
        Position = UDim2.new(0,12,0,4),
        BackgroundColor3 = Theme.WatermarkBg,
        BorderSizePixel = 0, ClipsDescendants = true,
        ZIndex = ZIndex.NOTIFY,
        Parent = self._ScreenGui,
    })
    ApplyCorner(wmFrame,6); ApplyStroke(wmFrame,Theme.Border,1)
    CreateAccentLine(wmFrame,6)

    local content = Create("Frame",{
        Name="Content", Size=UDim2.new(1,-14,1,-4),
        Position=UDim2.new(0,7,0,4),
        BackgroundTransparency=1, Parent=wmFrame,
    })
    Create("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,6),
        VerticalAlignment=Enum.VerticalAlignment.Center,
        Parent=content,
    })

    local lo = 0
    local function addSep()
        lo = lo + 1
        Create("TextLabel",{
            Text="|",Font=FontRegular,TextSize=8,TextColor3=Theme.TextMuted,
            Size=UDim2.new(0,0,0,14),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,LayoutOrder=lo,Parent=content,
        })
    end
    local function addLabel(n, text, font, size, color, visible)
        lo = lo + 1
        return Create("TextLabel",{
            Name=n, Text=text, Font=font or FontRegular, TextSize=size or 10,
            TextColor3=color or Theme.TextSecondary,
            Size=UDim2.new(0,0,0,14), AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1, LayoutOrder=lo, Visible=visible~=false,
            Parent=content,
        })
    end

    if self._WatermarkConfig.ShowName then
        local mi = CreateIconOrText(content,"moon",nil,UDim2.new(0,12,0,12),UDim2.new(0,0,0,0),Theme.Accent,FontBold,11)
        lo=lo+1; if mi then mi.LayoutOrder=lo end
        addLabel("NameLabel", name, FontBold,11,Theme.Accent); addSep()
    end
    if self._WatermarkConfig.ShowUser then
        addLabel("UserLabel", LocalPlayer.DisplayName.."@"..LocalPlayer.Name); addSep()
    end
    if self._WatermarkConfig.ShowFPS  then addLabel("FPSLabel","0 fps"); addSep() end
    if self._WatermarkConfig.ShowPing then addLabel("PingLabel","0ms"); addSep() end
    if self._WatermarkConfig.ShowLagspike then
        addLabel("LagspikeLabel","LAGSPIKE",FontBold,10,Theme.Error,false)
    end
    if self._WatermarkConfig.ShowTime then addLabel("TimeLabel","") end
    -- Custom text label
    addLabel("CustomLabel","",FontRegular,10,Theme.TextSecondary,false)

    self._WatermarkFrame = wmFrame

    local function positionWM()
        if not wmFrame or not wmFrame.Parent then return end
        local pos = self._WatermarkPosition
        if pos == "TopLeft" then
            wmFrame.AnchorPoint = Vector2.new(0,0)
            wmFrame.Position = UDim2.new(0,12,0,4)
        elseif pos == "TopCenter" then
            wmFrame.AnchorPoint = Vector2.new(0.5,0)
            wmFrame.Position = UDim2.new(0.5,0,0,4)
        elseif pos == "TopRight" then
            wmFrame.AnchorPoint = Vector2.new(1,0)
            wmFrame.Position = UDim2.new(1,-12,0,4)
        end
    end

    local function updateSize()
        task.defer(function()
            if not wmFrame or not wmFrame.Parent then return end
            local tw = 14
            for _, child in ipairs(content:GetChildren()) do
                if (child:IsA("TextLabel") or child:IsA("ImageLabel")) and child.Visible then
                    local cw = child:IsA("TextLabel") and child.TextBounds.X or child.AbsoluteSize.X
                    if cw > 0 then
                        tw = tw + cw + 6
                    end
                end
            end
            -- Clamp minimum size so watermark doesn't collapse to zero
            if tw < 60 then tw = 500 end
            wmFrame.Size = UDim2.new(0,tw,0,28)
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
        while self._WatermarkFrame and self._WatermarkFrame.Parent do
            if timeLabel and timeLabel.Parent then
                timeLabel.Text = os.date("%H:%M:%S")
            end
            task.wait(1)
        end
    end)

    -- Calculate size after render so TextBounds are ready
    task.delay(0.1, updateSize)
    task.delay(0.5, updateSize)

    positionWM()
    -- Apply any pre-set custom watermark text immediately
    self:_UpdateWatermark()
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
        newPos = UDim2.new(0,12,0,4)
    elseif pos=="TopCenter" then
        newAP = Vector2.new(0.5,0)
        newPos = UDim2.new(0.5,0,0,4)
    elseif pos=="TopRight" then
        newAP = Vector2.new(1,0)
        newPos = UDim2.new(1,-12,0,4)
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

    local fpsL  = c:FindFirstChild("FPSLabel")
    local pingL = c:FindFirstChild("PingLabel")
    local lagL  = c:FindFirstChild("LagspikeLabel")
    local cusL  = c:FindFirstChild("CustomLabel")

    if fpsL  then fpsL.Text  = self._FPS.." fps";  fpsL.TextColor3  = self._Lagspike and Theme.Error or Theme.TextSecondary end
    if pingL then pingL.Text = self._Ping.."ms";   pingL.TextColor3 = self._Ping>150 and Theme.Warning or Theme.TextSecondary end

    if lagL then
        if self._Lagspike and not lagL.Visible then
            lagL.Visible = true
            lagL.TextTransparency = 0
            -- Blink tween back and forth
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
            -- Store stop function so we can stop blinking when lagspike ends
            self._lagspikeBlinkStop = function() blinking = false end
        elseif not self._Lagspike and lagL.Visible then
            if self._lagspikeBlinkStop then self._lagspikeBlinkStop(); self._lagspikeBlinkStop = nil end
            TweenObject(lagL,{TextTransparency=1},0.2)
            task.delay(0.25, function() if not self._Lagspike then lagL.Visible=false; lagL.TextTransparency=0 end end)
        end
    end

    if cusL then
        if self._WatermarkCustomText and self._WatermarkCustomText ~= "" then
            cusL.Text    = self._WatermarkCustomText
            cusL.Visible = true
        else
            cusL.Visible = false
        end
    end

    -- Reposition after content changes (for TopCenter/TopRight)
    task.defer(function()
        if not wf or not wf.Parent then return end
        local pos = self._WatermarkPosition
        if pos == "TopCenter" then
            wf.AnchorPoint = Vector2.new(0.5,0)
            wf.Position = UDim2.new(0.5,0,0,4)
        elseif pos == "TopRight" then
            wf.AnchorPoint = Vector2.new(1,0)
            wf.Position = UDim2.new(1,-12,0,4)
        end
    end)
end

--// ═══════════════════════════════════════════════════════════
--// NOTIFICATIONS
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:SetNotificationPosition(pos)
    self._NotificationPosition = pos
    self:_RepositionNotifications()
end

function MIDNIGHT:_GetNotifPos(idx, totalH)
    local pos = self._NotificationPosition
    local vs  = workspace.CurrentCamera.ViewportSize
    -- Offset Y down if watermark is at the top
    local wmOffset = 0
    if self._WatermarkFrame and self._WatermarkFrame.Parent then
        local wmPos = self._WatermarkPosition
        if (pos:find("Top") and (wmPos=="TopCenter" or wmPos=="TopLeft" or wmPos=="TopRight")) then
            wmOffset = 36
        end
    end
    local x, y
    if     pos=="TopCenter"    then x=vs.X/2-175;      y=wmOffset+4+totalH
    elseif pos=="TopLeft"      then x=12;              y=wmOffset+4+totalH
    elseif pos=="TopRight"     then x=vs.X-362;        y=wmOffset+4+totalH
    elseif pos=="BottomLeft"   then x=12;              y=vs.Y-84-totalH
    elseif pos=="BottomRight"  then x=vs.X-362;        y=vs.Y-84-totalH
    elseif pos=="BottomCenter" then x=vs.X/2-175;      y=vs.Y-84-totalH
    else                            x=vs.X-362;        y=wmOffset+4+totalH
    end
    return UDim2.new(0,x,0,y)
end

function MIDNIGHT:_GetNotifSlideOffset(pos)
    if pos=="TopRight"    or pos=="BottomRight"  then return UDim2.new(0,80,0,0)
    elseif pos=="TopLeft" or pos=="BottomLeft"   then return UDim2.new(0,-80,0,0)
    else return UDim2.new(0,0,0,-40) end
end

function MIDNIGHT:_RepositionNotifications()
    local totalH = 0
    for i, n in ipairs(self._Notifications) do
        if n._Frame and n._Frame.Parent then
            TweenObject(n._Frame,{Position=self:_GetNotifPos(i,totalH)},0.35)
            totalH = totalH + n._Frame.AbsoluteSize.Y + 8
        end
    end
end

function MIDNIGHT:Notify(config)
    config = config or {}
    local title       = config.Title    or "MIDNIGHT"
    local contentText = config.Content  or ""
    local notifType   = string.lower(config.Type or "info")
    local duration    = config.Duration or 5

    self:_InitScreenGui()

    local typeColors = {success=Theme.Success,warning=Theme.Warning,error=Theme.Error,info=Theme.Info}
    local typeColor  = typeColors[notifType] or Theme.Info

    local nf = Create("Frame",{
        Name="Notification", Size=UDim2.new(0,350,0,72),
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

    -- Icon circle — animated scale 0→1 with Back easing
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
    -- Animate icon scale: 0 → 32 with Back easing separately
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

    -- Close button (✕)
    local closeNBtn = Create("TextButton",{
        Text="✕", Font=FontBold, TextSize=10,
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
        TweenObject(nf,{Position=nf.Position+slideOut},0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        task.delay(0.4,function()
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
    local finalPos = self:_GetNotifPos(#self._Notifications, totalH - nf.AbsoluteSize.Y - 8)
    local slideOffset = self:_GetNotifSlideOffset(self._NotificationPosition)
    nf.Position = finalPos + slideOffset
    TweenObject(nf,{Position=finalPos},0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.defer(function() self:_RepositionNotifications() end)

    TweenObject(pFill,{Size=UDim2.new(0,0,1,0)},duration,Enum.EasingStyle.Linear)
    task.delay(duration, dismiss)

    return nd
end

--// ═══════════════════════════════════════════════════════════
--// KEYBIND LIST
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:CreateKeybindList(config)
    config = config or {}
    local title = config.Name or "Keybinds"
    self:_InitScreenGui()

    local kf = Create("Frame",{
        Name="KeybindList", Size=UDim2.new(0,200,0,30),
        Position=UDim2.new(1,-220,0,40),
        BackgroundColor3=Theme.KeybindBg, BorderSizePixel=0,
        ZIndex=ZIndex.WINDOW, Parent=self._ScreenGui,
    })
    ApplyCorner(kf,8); ApplyStroke(kf,Theme.Border,1)

    local tb2 = Create("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0,ClipsDescendants=true,Parent=kf})
    ApplyCorner(tb2,8)
    Create("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.new(0,0,1,-8),BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0,Parent=tb2})
    CreateAccentLine(tb2,8)

    local tc2 = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=tb2})
    Create("TextLabel",{Text=title,Font=FontBold,TextSize=10,TextColor3=Theme.Accent,Size=UDim2.new(1,0,1,0),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,BackgroundTransparency=1,Parent=tc2})

    local lc2 = Create("Frame",{Size=UDim2.new(1,0,1,-28),Position=UDim2.new(0,0,0,28),BackgroundTransparency=1,Parent=kf})
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
                    BackgroundColor3 = isActive and AccentTint(Theme.Accent,0.12) or Color3.fromRGB(0,0,0),
                    BackgroundTransparency = isActive and 0 or 1,
                    BorderSizePixel=0, LayoutOrder=count, Parent=lc2,
                })
                ApplyCorner(row,4)
                if isActive then
                    Create("Frame",{Size=UDim2.new(0,2,0.8,0),Position=UDim2.new(0,0,0.1,0),BackgroundColor3=Theme.Accent,BorderSizePixel=0,Parent=row})
                end
                Create("TextLabel",{
                    Text=kb._Name, Font=FontRegular, TextSize=10,
                    TextColor3=isActive and Theme.TextPrimary or Theme.TextSecondary,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    Size=UDim2.new(0.55,0,1,0), Position=UDim2.new(0,isActive and 6 or 4,0,0),
                    BackgroundTransparency=1, Parent=row,
                })
                -- Keybind badge: InputBg background, rounded corners
                local badge = Create("Frame",{
                    Size=UDim2.new(0,0,0,16),
                    AutomaticSize=Enum.AutomaticSize.X,
                    Position=UDim2.new(1,-4,0.5,-8),
                    AnchorPoint=Vector2.new(1,0),
                    BackgroundColor3=Theme.InputBg,
                    BorderSizePixel=0, Parent=row,
                })
                ApplyCorner(badge,4)
                ApplyPadding(badge,0,0,4,4)
                Create("TextLabel",{
                    Text=KeyCodeToName(kb._Key), Font=FontBold, TextSize=9,
                    TextColor3=isActive and Theme.Accent or Theme.TextMuted,
                    Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
                    BackgroundTransparency=1, Parent=badge,
                })
            end
        end
        kf.Size = UDim2.new(0,200,0,28+count*24+8)
    end

    self._RefreshKeybindList = refresh
    refresh()
    return kf
end

function MIDNIGHT:_AddKeybindToList(name, key, mode, callback, visible)
    local kd = {_Name=name,_Key=key,_Mode=mode or "Press",_Callback=callback,_Active=false,_Visible=visible~=false}
    table.insert(self._Keybinds, kd)
    if self._RefreshKeybindList then self._RefreshKeybindList() end

    RegConn(UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode == kd._Key then
            if kd._Mode == "Hold" then
                kd._Active=true; if kd._Callback then kd._Callback(true) end
            elseif kd._Mode == "Press" then
                kd._Active = not kd._Active; if kd._Callback then kd._Callback(kd._Active) end
            end
            if self._RefreshKeybindList then self._RefreshKeybindList() end
        end
    end))

    RegConn(UserInputService.InputEnded:Connect(function(input,gp)
        if input.KeyCode == kd._Key and kd._Mode == "Hold" then
            if kd._Active then
                kd._Active=false; if kd._Callback then kd._Callback(false) end
                if self._RefreshKeybindList then self._RefreshKeybindList() end
            end
        end
    end))

    return kd
end

--// ═══════════════════════════════════════════════════════════
--// WINDOW
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:MakeWindow(config)
    config = config or {}
    local windowName  = config.Name    or "MIDNIGHT"
    local menuKeyStr  = config.MenuKey or "RightShift"
    local menuKey     = ParseKeyCode(menuKeyStr)

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
        Name = "Window_"..windowName,
        Size = UDim2.new(0,600,0,440),
        Position = UDim2.new(0.5,-300,0.5,-220),
        BackgroundColor3 = Theme.WindowBg,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        ZIndex = ZIndex.WINDOW,
        Parent = self._ScreenGui,
    })
    ApplyCorner(wf,10)
    Create("ImageLabel",{
        Size=UDim2.new(1,30,1,30),Position=UDim2.new(0,-15,0,-15),
        BackgroundTransparency=1,Image="rbxassetid://6015897843",
        ImageColor3=Theme.Shadow,ImageTransparency=0.4,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),
        ZIndex=ZIndex.WINDOW-1,Parent=wf,
    })
    ApplyStroke(wf,Theme.Border,1)

    -- Animate in: fade only (no Size reset — avoids ClipsDescendants clipping content)
    wf.BackgroundTransparency = 0  -- Set immediately as safety net for executors with unreliable TweenService
    TweenObject(wf,{BackgroundTransparency=0},0.35)
    -- Window is visible after creation, sync state
    self._MenuOpen = true

    -- TITLE BAR
    local tb = Create("Frame",{
        Name="TitleBar", Size=UDim2.new(1,0,0,40),
        BackgroundColor3=Theme.TitleBarBg, BorderSizePixel=0,
        ClipsDescendants=false, Active=true, ZIndex=ZIndex.CONTENT, Parent=wf,
    })
    ApplyCorner(tb,10)
    Create("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),BackgroundColor3=Theme.TitleBarBg,BorderSizePixel=0,Parent=tb})
    CreateAccentLine(tb,10)
    CreateIconOrText(tb,"moon",nil,UDim2.new(0,16,0,16),UDim2.new(0,14,0,12),Theme.Accent,FontBold,14)
    Create("TextLabel",{
        Text=windowName,Font=FontBold,TextSize=13,TextColor3=Theme.TextPrimary,
        Size=UDim2.new(1,-120,1,0),Position=UDim2.new(0,36,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,
        ZIndex=ZIndex.CONTENT+1,Parent=tb,
    })

    -- Minimize
    local minBtn = Create("TextButton",{
        Name="MinBtn",Text="",Size=UDim2.new(0,28,0,20),
        Position=UDim2.new(1,-68,0,10),BackgroundColor3=Theme.MinNormal,
        BorderSizePixel=0,ZIndex=ZIndex.CONTENT+2,Parent=tb,
    })
    ApplyCorner(minBtn,5)
    Create("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Parent=minBtn})
    ApplyHoverEffect(minBtn,Theme.MinNormal,Theme.MinHover,false)

    -- Close
    local closeBtn = Create("TextButton",{
        Name="CloseBtn",Text="",Size=UDim2.new(0,28,0,20),
        Position=UDim2.new(1,-34,0,10),BackgroundColor3=Theme.CloseNormal,
        BorderSizePixel=0,ZIndex=ZIndex.CONTENT+2,Parent=tb,
    })
    ApplyCorner(closeBtn,5)
    Create("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=45,Parent=closeBtn})
    Create("Frame",{Size=UDim2.new(0,10,0,2),Position=UDim2.new(0.5,-5,0.5,-1),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=closeBtn})
    ApplyHoverEffect(closeBtn,Theme.CloseNormal,Theme.CloseHover,false)

    closeBtn.MouseButton1Click:Connect(function()
        self._MenuOpen = false
        -- Cancel any previously pending close threads first
        for _, th in ipairs(self._MenuCloseThreads) do
            if th and typeof(th) == "thread" then pcall(function() task.cancel(th) end) end
        end
        self._MenuCloseThreads = {}
        for _, w in ipairs(self._Windows) do
            if w._Frame then
                TweenObject(w._Frame,{BackgroundTransparency=1},0.2)
                local th = task.delay(0.25,function() if not self._MenuOpen then w._Frame.Visible=false end end)
                table.insert(self._MenuCloseThreads, th)
            end
        end
        self:Notify({Title="Menu Hidden",Content="Press ["..self._MenuKeyStr.."] to reopen",Type="info",Duration=4})
    end)

    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenObject(wf,{Size=UDim2.new(0,600,0,40)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        else
            TweenObject(wf,{Size=UDim2.new(0,600,0,440)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        end
    end)

    MakeDraggable(wf, tb, function() self:_CloseAllPopups() end)

    -- BODY
    local body = Create("Frame",{
        Name="Body",Size=UDim2.new(1,0,1,-40),Position=UDim2.new(0,0,0,40),
        BackgroundTransparency=1, Active=true, Parent=wf,
    })

    -- SIDEBAR
    local sidebar = Create("Frame",{
        Name="Sidebar",Size=UDim2.new(0,130,1,-28),  -- leave room for footer
        BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0,Parent=body,
    })
    Create("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=sidebar})

    local tabList = Create("ScrollingFrame",{
        Name="TabList",Size=UDim2.new(1,0,1,-4),Position=UDim2.new(0,0,0,4),
        BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=2,ScrollBarImageColor3=Theme.ScrollBarColor,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=ZIndex.CONTENT,Parent=sidebar,
    })
    Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=tabList})
    ApplyPadding(tabList,4,4,6,6)

    -- Sidebar footer: version + fps/ping
    local sidebarFooterBg = Create("Frame",{
        Size=UDim2.new(0,130,0,28),Position=UDim2.new(0,0,1,-28),
        BackgroundColor3=Theme.SidebarBg,BorderSizePixel=0,Parent=body,
    })
    Create("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=sidebarFooterBg})
    Create("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=sidebarFooterBg})
    local footerLabel = Create("TextLabel",{
        Text="v"..self.Version.."  |  0 fps  0ms",
        Font=FontRegular,TextSize=8,TextColor3=Theme.TextMuted,
        Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,6,0,0),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1,Parent=sidebarFooterBg,
    })
    table.insert(self._SidebarFooters, footerLabel)

    -- CONTENT AREA
    local contentFrame = Create("Frame",{
        Name="ContentFrame",Size=UDim2.new(1,-130,1,0),Position=UDim2.new(0,130,0,0),
        BackgroundColor3=Theme.ContentBg,BorderSizePixel=0,
        ZIndex=ZIndex.CONTENT,Parent=body,
    })
    ApplyCorner(contentFrame,10)
    Create("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,0),BackgroundColor3=Theme.ContentBg,BorderSizePixel=0,Parent=contentFrame})

    local wd = {
        _Frame=wf, _TitleBar=tb, _Body=body, _Sidebar=sidebar,
        _TabList=tabList, _ContentFrame=contentFrame,
        _Tabs={}, _ActiveTab=nil, _FloatingWindows={},
        _TabCount=0,
    }
    table.insert(self._Windows, wd)

    --// ═══ MAKE TAB ═══
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
            Size=UDim2.new(1,0,0,30),
            BackgroundColor3=Theme.TabBg,
            BorderSizePixel=0, Text="",
            LayoutOrder=self._TabCount,
            ZIndex=ZIndex.CONTENT+1,
            Parent=tabList,
        })
        ApplyCorner(btn,5)

        local btnContent = Create("Frame",{Size=UDim2.new(1,-10,1,0),Position=UDim2.new(0,5,0,0),BackgroundTransparency=1,Parent=btn})
        Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=btnContent})

        local tabIconEl = nil
        if tabIcon ~= "" then
            tabIconEl = CreateIconOrText(btnContent,tabIcon,nil,UDim2.new(0,14,0,14),UDim2.new(0,0,0,0),Theme.TextMuted,FontBold,10)
            if tabIconEl then tabIconEl.LayoutOrder=1 end
        end

        local tabLabel = Create("TextLabel",{
            Text=tabName,Font=Font,TextSize=11,TextColor3=Theme.TextSecondary,
            TextXAlignment=Enum.TextXAlignment.Left,
            Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1,LayoutOrder=2,Parent=btnContent,
        })

        local indicator = Create("Frame",{
            Size=UDim2.new(0,2,0,0),Position=UDim2.new(0,0,0.5,0),
            BackgroundColor3=Theme.Accent,BorderSizePixel=0,Parent=btn,
        })
        ApplyCorner(indicator,1)

        -- Active tab glow stroke
        local tabGlowStroke = Create("UIStroke",{
            Color=Theme.Accent,Thickness=1,Transparency=1,
            Parent=btn,
        })

        -- Scrollbar auto-hide per scrolling frame
        local function setupScrollbarAutoHide(scrollFrame)
            if not scrollFrame then return end
            local fadeTimer = nil
            scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                scrollFrame.ScrollBarThickness = 3
                scrollFrame.ScrollBarImageTransparency = 0
                if fadeTimer and typeof(fadeTimer) == "thread" then pcall(function() task.cancel(fadeTimer) end); fadeTimer = nil end
                fadeTimer = task.delay(1.5, function()
                    fadeTimer = nil
                    TweenObject(scrollFrame, {ScrollBarImageTransparency=1}, 0.4)
                    task.delay(0.45, function()
                        if scrollFrame and scrollFrame.Parent then
                            scrollFrame.ScrollBarThickness = 0
                            scrollFrame.ScrollBarImageTransparency = 0
                        end
                    end)
                end)
            end)
        end

        -- Page (tab content) — uses a ClipsDescendants frame for slide animation
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
        ApplyPadding(page,2,2,4,4)
        setupScrollbarAutoHide(page)

        -- Empty placeholder
        local placeholder = Create("TextLabel",{
            Text="No items",Font=FontRegular,TextSize=13,
            TextColor3=Theme.TextMuted,
            Size=UDim2.new(1,0,1,0),
            TextXAlignment=Enum.TextXAlignment.Center,
            TextYAlignment=Enum.TextYAlignment.Center,
            BackgroundTransparency=1,
            ZIndex=ZIndex.CONTENT+2,
            Parent=page,
        })

        local td = {
            _Button=btn, _Page=page, _PageClip=pageClip,
            _Layout=nil, _Window=wd, _ItemCount=0,
            _Indicator=indicator, _Label=tabLabel,
            _IconEl=tabIconEl, _GlowStroke=tabGlowStroke,
            _Placeholder=placeholder,
        }
        table.insert(self._Tabs, td)

        local function selectTab(fromTab)
            for _, t in ipairs(self._Tabs) do
                if t._PageClip then
                    if t == td then continue end
                    -- Slide old tab left
                    if t._PageClip.Visible then
                        TweenObject(t._Page,{Position=UDim2.new(-1,4,0,4)},0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
                        task.delay(0.25,function()
                            if t._PageClip then t._PageClip.Visible=false end
                            if t._Page then t._Page.Position=UDim2.new(0,4,0,4) end
                        end)
                    end
                end
                TweenObject(t._Button,{BackgroundColor3=Theme.TabBg},0.18)
                TweenObject(t._Indicator,{Size=UDim2.new(0,2,0,0)},0.18)
                if t._Label then TweenObject(t._Label,{TextColor3=Theme.TextSecondary},0.18) end
                if t._IconEl then
                    if t._IconEl:IsA("ImageLabel") then TweenObject(t._IconEl,{ImageColor3=Theme.TextMuted},0.18)
                    else TweenObject(t._IconEl,{TextColor3=Theme.TextMuted},0.18) end
                end
                if t._GlowStroke then TweenObject(t._GlowStroke,{Transparency=1},0.18) end
            end
            -- Slide new tab in from right
            pageClip.Visible=true
            page.Position = UDim2.new(1,4,0,4)
            TweenObject(page,{Position=UDim2.new(0,4,0,4)},0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
            TweenObject(btn,{BackgroundColor3=Theme.TabActiveBg},0.18)
            TweenObject(indicator,{Size=UDim2.new(0,2,0.7,0),Position=UDim2.new(0,0,0.15,0)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            if tabLabel then TweenObject(tabLabel,{TextColor3=Theme.TextAccent},0.18) end
            if tabIconEl then
                if tabIconEl:IsA("ImageLabel") then TweenObject(tabIconEl,{ImageColor3=Theme.Accent},0.18)
                else TweenObject(tabIconEl,{TextColor3=Theme.Accent},0.18) end
            end
            if tabGlowStroke then TweenObject(tabGlowStroke,{Transparency=0.6},0.25) end
            self._ActiveTab = td
        end

        btn.MouseButton1Click:Connect(selectTab)
        ApplyHoverEffect(btn, Theme.TabBg, Theme.TabHoverBg, false)
        if #self._Tabs == 1 then
            pageClip.Visible=true; page.Position=UDim2.new(0,4,0,4)
            TweenObject(btn,{BackgroundColor3=Theme.TabActiveBg},0.18)
            TweenObject(indicator,{Size=UDim2.new(0,2,0.7,0),Position=UDim2.new(0,0,0.15,0)},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            if tabLabel then tabLabel.TextColor3=Theme.TextAccent end
            if tabGlowStroke then tabGlowStroke.Transparency=0.6 end
            self._ActiveTab=td
        end

        -- tab:SetVisible
        function td:SetVisible(bool)
            btn.Visible = bool
            if not bool and self._Window._ActiveTab == td then
                -- Switch to first visible tab
                for _, t in ipairs(self._Window._Tabs) do
                    if t ~= td and t._Button.Visible then
                        t._Button.MouseButton1Click:Fire()
                        break
                    end
                end
            end
        end

        local function nextOrder()
            td._ItemCount = td._ItemCount + 1
            -- Hide placeholder once there's content
            if td._Placeholder then td._Placeholder.Visible = false end
            return td._ItemCount
        end

        --// ADDSECTION
        function td:AddSection(sc)
            sc = sc or {}; local nm = sc.Name or "Section"
            local sf = Create("Frame",{Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,LayoutOrder=nextOrder(),Parent=page})
            local sc2 = Create("Frame",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,0,0,2),BackgroundTransparency=1,Parent=sf})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=sc2})
            local chevEl = CreateIconOrText(sc2,"chevron-right",nil,UDim2.new(0,10,0,12),UDim2.new(0,0,0,0),Theme.Accent,FontBold,10)
            if chevEl then chevEl.LayoutOrder=1 end
            -- Letter-spaced section name
            Create("TextLabel",{
                Text=LetterSpace(nm:upper()),Font=FontBold,TextSize=10,
                TextColor3=Theme.Accent,TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundTransparency=1,LayoutOrder=2,Parent=sc2,
            })
            Create("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-3),BackgroundColor3=Theme.Border,BorderSizePixel=0,Parent=sf})
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
                Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextSecondary,
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

            local item = Create("Frame",{
                Size=UDim2.new(1,0,0,36),BackgroundColor3=Theme.ItemBg,
                BorderSizePixel=0,Active=true,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{
                Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(0.55,0,1,0),BackgroundTransparency=1,Parent=ic,
            })

            -- Keybind badge
            local keyBadge = Create("Frame",{
                Size=UDim2.new(0,0,0,16),AutomaticSize=Enum.AutomaticSize.X,
                Position=UDim2.new(0.55,0,0.5,-8),
                BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=ic,
            })
            ApplyCorner(keyBadge,4); ApplyPadding(keyBadge,0,0,4,4)
            local keyBadgeLabel = Create("TextLabel",{
                Text=bindKey~=Enum.KeyCode.Unknown and KeyCodeToName(bindKey) or "",
                Font=FontBold,TextSize=9,TextColor3=Theme.TextMuted,
                Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundTransparency=1,Parent=keyBadge,
            })

            local sw = Create("Frame",{Size=UDim2.new(0,36,0,18),Position=UDim2.new(1,-36,0.5,-9),BackgroundColor3=Theme.ToggleOff,BorderSizePixel=0,ClipsDescendants=true,Parent=ic})
            ApplyCorner(sw,9)
            local knob = Create("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,2,0.5,-7),BackgroundColor3=Theme.ToggleKnob,BorderSizePixel=0,Parent=sw})
            ApplyCorner(knob,7)

            local on = def
            local data = {_Value=on,_Key=bindKey,_Mode=bindMode,_KeyBadge=keyBadgeLabel}

            local function update(anim)
                if on then
                    if anim then
                        TweenObject(sw,{BackgroundColor3=col},0.22)
                        TweenObject(knob,{Position=UDim2.new(0,20,0.5,-7)},0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        -- Flash: bright white pulse, then back to white (knob stays visible on accent bg)
                        TweenObject(knob,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.08)
                        task.delay(0.1,function() TweenObject(knob,{BackgroundColor3=Color3.fromRGB(230,230,240)},0.18) end)
                    else
                        sw.BackgroundColor3=col; knob.Position=UDim2.new(0,20,0.5,-7)
                        knob.BackgroundColor3=Color3.fromRGB(230,230,240)
                    end
                else
                    if anim then
                        TweenObject(sw,{BackgroundColor3=Theme.ToggleOff},0.22)
                        TweenObject(knob,{Position=UDim2.new(0,2,0.5,-7)},0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                        TweenObject(knob,{BackgroundColor3=Theme.ToggleKnob},0.18)
                    else
                        sw.BackgroundColor3=Theme.ToggleOff; knob.Position=UDim2.new(0,2,0.5,-7)
                        knob.BackgroundColor3=Theme.ToggleKnob
                    end
                end
            end

            -- Transparent button overlay for reliable click handling
            local clickBtn = Create("TextButton",{
                Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                ZIndex=ZIndex.CONTENT+2,Parent=item,
            })
            clickBtn.MouseButton1Click:Connect(function()
                on=not on; data._Value=on; update(true); if cb then cb(on) end
            end)
            clickBtn.MouseButton2Click:Connect(function()
                local ap = item.AbsolutePosition; local as = item.AbsoluteSize
                local curVis = true
                for _, kk in ipairs(MIDNIGHT._Keybinds) do
                    if kk._Name==nm then curVis=kk._Visible; break end
                end
                MIDNIGHT:_ShowKeybindSettings({
                    Position=Vector2.new(ap.X+as.X,ap.Y),
                    Mode=data._Mode, Visible=curVis,
                    CurrentKeyStr=bindKey~=Enum.KeyCode.Unknown and KeyCodeToName(bindKey) or "None",
                    OnKeyChange=function(newKey,newKeyStr)
                        bindKey=newKey; keyBadgeLabel.Text=newKeyStr; data._Key=newKey
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do
                            if kk._Name==nm then kk._Key=newKey; if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end; break end
                        end
                        if isMenuKey then MIDNIGHT:SetMenuKey(newKeyStr) end
                    end,
                    OnModeChange=function(newMode)
                        data._Mode=newMode; bindMode=newMode
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do
                            if kk._Name==nm then
                                -- Reset active Hold state when switching away from Hold
                                if kk._Mode == "Hold" and kk._Active and newMode ~= "Hold" then
                                    kk._Active=false; if kk._Callback then kk._Callback(false) end
                                end
                                kk._Mode=newMode; break
                            end
                        end
                    end,
                    OnVisibleChange=function(vis)
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do if kk._Name==nm then kk._Visible=vis; break end end
                        if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                    end,
                })
            end)

            update(false)

            if bindKey ~= Enum.KeyCode.Unknown then
                local kd = MIDNIGHT:_AddKeybindToList(nm,bindKey,bindMode,function(active)
                    on=active; data._Value=on; update(true); if cb then cb(on) end
                end, not isMenuKey)
                data._KeybindData=kd
            end

            function data:Set(v) on=v; data._Value=v; update(true); if cb then cb(v) end end
            function data:SetKey(k)
                local nk=ParseKeyCode(k); if nk==Enum.KeyCode.Unknown then return end
                bindKey=nk; keyBadgeLabel.Text=KeyCodeToName(nk); data._Key=nk
                for _, kk in ipairs(MIDNIGHT._Keybinds) do
                    if kk._Name==nm then kk._Key=nk; if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end; break end
                end
                if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(nk)) end
            end
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

            local item = Create("Frame",{
                Size=UDim2.new(1,0,0,52),BackgroundColor3=Theme.ItemBg,
                BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,6,6,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{
                Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(0.65,0,0,16),BackgroundTransparency=1,Parent=ic,
            })

            -- Value label (right-aligned, fixed width so it doesn't jump)
            local vl = Create("TextLabel",{
                Text=pct and def.."%" or tostring(def),
                Font=FontBold,TextSize=12,TextColor3=Theme.Accent,
                TextXAlignment=Enum.TextXAlignment.Right,
                Size=UDim2.new(0,50,0,16),Position=UDim2.new(1,-50,0,0),
                BackgroundTransparency=1,Parent=ic,
            })

            local track = Create("Frame",{Size=UDim2.new(1,0,0,6),Position=UDim2.new(0,0,0,22),BackgroundColor3=Theme.SliderTrack,BorderSizePixel=0,Parent=ic})
            ApplyCorner(track,3)
            local r0 = (def-mn)/(mx-mn)
            local fill = Create("Frame",{Size=UDim2.new(r0,0,1,0),BackgroundColor3=Theme.SliderFill,BorderSizePixel=0,Parent=track})
            ApplyCorner(fill,3)
            local k = Create("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(r0,-7,0.5,-7),BackgroundColor3=Theme.SliderKnob,BorderSizePixel=0,Parent=track})
            ApplyCorner(k,7); Create("UIStroke",{Color=Theme.Accent,Thickness=1.5,Parent=k})

            -- Tooltip above knob
            local tooltip = Create("Frame",{
                Size=UDim2.new(0,36,0,18),
                Position=UDim2.new(r0,-18,0,-24),
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

            -- Manual value input (click value label → TextBox)
            local inputBox = Create("TextBox",{
                Text="",PlaceholderText=vl.Text,
                Font=FontBold,TextSize=12,TextColor3=Theme.Accent,
                TextXAlignment=Enum.TextXAlignment.Right,
                Size=UDim2.new(0,50,0,16),Position=UDim2.new(1,-50,0,0),
                BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
                Visible=false,ZIndex=ZIndex.CONTENT+3,Parent=ic,
            })
            ApplyCorner(inputBox,3); ApplyStroke(inputBox,Theme.Accent,1)

            local cur = def; local drag = false; local data = {_Value=cur}

            local function upd(v, anim, forceCb)
                v=math.clamp(v,mn,mx)
                v=math.floor((v-mn)/step+0.5)*step+mn
                v=math.clamp(v,mn,mx)
                local changed = v ~= cur
                cur=v; data._Value=v
                local rat=(v-mn)/(mx-mn)
                local txt = pct and string.format("%."..dec.."f%%",v) or string.format("%."..dec.."f",v)
                vl.Text=txt; tooltipLabel.Text=txt; inputBox.PlaceholderText=txt
                if anim then
                    TweenObject(fill,{Size=UDim2.new(rat,0,1,0)},0.1)
                    TweenObject(k,{Position=UDim2.new(rat,-7,0.5,-7)},0.1)
                    TweenObject(tooltip,{Position=UDim2.new(rat,-18,0,-24)},0.1)
                else
                    fill.Size=UDim2.new(rat,0,1,0)
                    k.Position=UDim2.new(rat,-7,0.5,-7)
                    tooltip.Position=UDim2.new(rat,-18,0,-24)
                end
                if cb and (changed or forceCb) then cb(v) end
            end

            local function onInp(inp)
                if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
                    local rl=math.clamp((inp.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                    upd(mn+rl*(mx-mn),false)
                end
            end

            track.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    drag=true; onInp(inp)
                    -- Show tooltip
                    TweenObject(tooltip,{BackgroundTransparency=0},0.15)
                    TweenObject(tooltipLabel,{TextTransparency=0},0.15)
                end
            end)
            k.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                    drag=true
                    TweenObject(tooltip,{BackgroundTransparency=0},0.15)
                    TweenObject(tooltipLabel,{TextTransparency=0},0.15)
                end
            end)
            RegConn(UserInputService.InputEnded:Connect(function(inp)
                if drag and (inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) then
                    drag=false
                    TweenObject(tooltip,{BackgroundTransparency=1},0.2)
                    TweenObject(tooltipLabel,{TextTransparency=1},0.2)
                end
            end))
            RegConn(UserInputService.InputChanged:Connect(function(inp) if drag then onInp(inp) end end))

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
            return data
        end

        --// ADDKEYBIND
        function td:AddKeybind(kc)
            kc = kc or {}
            local nm = kc.Name or "Keybind"; local key = ParseKeyCode(kc.Key or "Unknown")
            local mode = kc.Mode or "Press"; local cb = kc.Callback; local isMenuKey = kc.IsMenuKey or false

            local item = Create("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,Active=true,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)

            local ic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local nc = Create("Frame",{Size=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=1,Parent=ic})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,Parent=nc})
            local ki2 = CreateIconOrText(nc,"key",nil,UDim2.new(0,12,0,12),UDim2.new(0,0,0,0),Theme.TextPrimary,FontBold,11)
            if ki2 then ki2.LayoutOrder=1 end
            Create("TextLabel",{Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,LayoutOrder=2,Parent=nc})
            local modeLbl = Create("TextLabel",{Text="["..mode:upper().."]",Font=FontRegular,TextSize=9,TextColor3=Theme.TextMuted,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.5,0,0.5,0),Position=UDim2.new(0,0,0.5,0),BackgroundTransparency=1,Parent=ic})

            local function updateModeLabel(m)
                mode=m; modeLbl.Text="["..m:upper().."]"
            end

            -- Keybind badge button
            local kbBadge = Create("Frame",{
                Size=UDim2.new(0,0,0,22),AutomaticSize=Enum.AutomaticSize.X,
                Position=UDim2.new(1,-4,0.5,-11),AnchorPoint=Vector2.new(1,0),
                BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=ic,
            })
            ApplyCorner(kbBadge,5); ApplyStroke(kbBadge,Theme.Border,1); ApplyPadding(kbBadge,0,0,6,6)
            local kbLabel = Create("TextLabel",{
                Text=KeyCodeToName(key),Font=FontBold,TextSize=11,
                TextColor3=Theme.Accent,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,
                BackgroundTransparency=1,Parent=kbBadge,
            })
            local kbBtn = Create("TextButton",{Text="",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+2,Parent=kbBadge})

            local listening2 = false
            kbBtn.MouseButton1Click:Connect(function()
                if listening2 then return end
                listening2=true; kbLabel.Text="..."; kbLabel.TextColor3=Theme.Warning
                local conn; conn=UserInputService.InputBegan:Connect(function(inp,gp)
                    if gp then return end
                    if inp.KeyCode~=Enum.KeyCode.Unknown then
                        key=inp.KeyCode; kbLabel.Text=KeyCodeToName(key); kbLabel.TextColor3=Theme.Accent
                        listening2=false; conn:Disconnect()
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do
                            if kk._Name==nm then kk._Key=key; if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end; break end
                        end
                        if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(key)) end
                    end
                end)
                RegConn(conn)
                -- Auto-cleanup if item is destroyed while listening
                if item and item.Destroying then
                    item.Destroying:Connect(function() if conn then conn:Disconnect() end; listening2 = false end)
                end
            end)

            kbBtn.MouseButton2Click:Connect(function()
                local ap=kbBadge.AbsolutePosition; local as=kbBadge.AbsoluteSize
                local curVis=true
                for _, kk in ipairs(MIDNIGHT._Keybinds) do if kk._Name==nm then curVis=kk._Visible; break end end
                MIDNIGHT:_ShowKeybindSettings({
                    Position=Vector2.new(ap.X,ap.Y),Mode=mode,Visible=curVis,
                    CurrentKeyStr=key~=Enum.KeyCode.Unknown and KeyCodeToName(key) or "None",
                    OnKeyChange=function(nk,ns) key=nk; kbLabel.Text=ns
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do if kk._Name==nm then kk._Key=nk; if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end; break end end
                        if isMenuKey then MIDNIGHT:SetMenuKey(ns) end
                    end,
                    OnModeChange=function(nm2) updateModeLabel(nm2)
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do
                            if kk._Name==nm then
                                -- Reset active Hold state when switching away from Hold
                                if kk._Mode == "Hold" and kk._Active and nm2 ~= "Hold" then
                                    kk._Active=false; if kk._Callback then kk._Callback(false) end
                                end
                                kk._Mode=nm2; break
                            end
                        end
                    end,
                    OnVisibleChange=function(vis)
                        for _, kk in ipairs(MIDNIGHT._Keybinds) do if kk._Name==nm then kk._Visible=vis; break end end
                        if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end
                    end,
                })
            end)

            local kd = MIDNIGHT:_AddKeybindToList(nm,key,mode,cb,not isMenuKey)
            kd._Frame=item; kd._KeyLabel=kbLabel; kd._ModeLabel=modeLbl
            function kd:Set(k2)
                local nk=ParseKeyCode(k2); kbLabel.Text=KeyCodeToName(nk); key=nk
                for _, kk in ipairs(MIDNIGHT._Keybinds) do if kk._Name==nm then kk._Key=nk; if MIDNIGHT._RefreshKeybindList then MIDNIGHT._RefreshKeybindList() end; break end end
                if isMenuKey then MIDNIGHT:SetMenuKey(KeyCodeToName(nk)) end
            end
            function kd:SetMode(m)
                updateModeLabel(m)
                for _, kk in ipairs(MIDNIGHT._Keybinds) do
                    if kk._Name==nm then
                        if kk._Mode == "Hold" and kk._Active and m ~= "Hold" then
                            kk._Active=false; if kk._Callback then kk._Callback(false) end
                        end
                        kk._Mode=m; break
                    end
                end
            end
            return kd
        end

        --// ADDDROPDOWN (popup)
        function td:AddDropdown(dc)
            dc = dc or {}; local nm=dc.Name or "Dropdown"; local opts=dc.Options or {}; local def=dc.Default or opts[1]; local cb=dc.Callback
            local item=Create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,Parent=ic})
            local sb=Create("TextButton",{Text=def or "",Font=Font,TextSize=11,TextColor3=Theme.TextSecondary,Size=UDim2.new(0,100,0,24),Position=UDim2.new(1,-100,0.5,-12),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=ic})
            ApplyCorner(sb,5); ApplyStroke(sb,Theme.Border,1)
            CreateIconOrText(sb,"chevron-down",nil,UDim2.new(0,10,0,10),UDim2.new(1,-14,0.5,-5),Theme.TextMuted,FontBold,8)
            local sel=def
            local data={_Value=sel}
            sb.MouseButton1Click:Connect(function()
                MIDNIGHT:_OpenDropdown({
                    ButtonPos=item.AbsolutePosition,ButtonSize=item.AbsoluteSize,
                    Options=opts,Current=sel,DropdownBtn=sb,
                    OnSelect=function(opt) sel=opt; data._Value=opt; sb.Text=opt; if cb then cb(opt) end end,
                })
            end)
            function data:Set(v) sel=v; data._Value=v; sb.Text=v end
            function data:SetOptions(newOpts) opts=newOpts; if not table.find(opts,sel) then sel=opts[1]; data._Value=sel; sb.Text=sel or "" end end
            return data
        end

        --// ADDINLINEDROPDOWN (no popup, expands inline)
        function td:AddInlineDropdown(dc)
            dc = dc or {}; local nm=dc.Name or "Dropdown"; local opts=dc.Options or {}; local def=dc.Default or opts[1]; local cb=dc.Callback
            local sel = def
            local data = {_Value=sel}
            local expanded = false
            local baseH = 34
            local itemH = 22

            local wrapper = Create("Frame",{
                Size=UDim2.new(1,0,0,baseH),BackgroundColor3=Theme.ItemBg,
                BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page,
                ClipsDescendants=true,
            })
            ApplyCorner(wrapper,6); ApplyStroke(wrapper,Theme.Border,1)

            local header = Create("Frame",{Size=UDim2.new(1,0,0,baseH),BackgroundTransparency=1,Parent=wrapper})
            ApplyPadding(header,0,0,10,10)
            local hic = Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=header})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,Parent=hic})
            local selLabel = Create("TextLabel",{Text=sel or "",Font=FontBold,TextSize=11,TextColor3=Theme.Accent,TextXAlignment=Enum.TextXAlignment.Right,Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.55,0,0,0),BackgroundTransparency=1,Parent=hic})
            local chevLabel = Create("TextLabel",{Text="▼",Font=FontBold,TextSize=9,TextColor3=Theme.TextMuted,TextXAlignment=Enum.TextXAlignment.Right,Size=UDim2.new(0.05,0,1,0),Position=UDim2.new(0.95,0,0,0),BackgroundTransparency=1,Parent=hic})

            local listFrame = Create("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,baseH),BackgroundTransparency=1,Parent=wrapper})
            Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=listFrame})
            ApplyPadding(listFrame,2,2,4,4)

            local optBtns = {}
            for i,opt in ipairs(opts) do
                local ob = Create("TextButton",{
                    Text=opt,Font=Font,TextSize=11,
                    TextColor3=opt==sel and Theme.Accent or Theme.TextSecondary,
                    Size=UDim2.new(1,0,0,itemH),
                    BackgroundColor3=opt==sel and Theme.TabActiveBg or Theme.InputBg,
                    BorderSizePixel=0,LayoutOrder=i,Parent=listFrame,
                })
                ApplyCorner(ob,4)
                ob.MouseButton1Click:Connect(function()
                    sel=opt; data._Value=opt; selLabel.Text=opt
                    for _, b in ipairs(optBtns) do
                        TweenObject(b,{BackgroundColor3=Theme.InputBg},0.12)
                        TweenObject(b,{TextColor3=Theme.TextSecondary},0.12)
                    end
                    TweenObject(ob,{BackgroundColor3=Theme.TabActiveBg},0.12)
                    TweenObject(ob,{TextColor3=Theme.Accent},0.12)
                    if cb then cb(opt) end
                    -- auto-collapse
                    expanded=false
                    chevLabel.Text="▼"
                    TweenObject(wrapper,{Size=UDim2.new(1,0,0,baseH)},0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                end)
                table.insert(optBtns,ob)
            end

            local totalH = baseH + #opts * (itemH+2) + 8
            local headerBtn = Create("TextButton",{Text="",Size=UDim2.new(1,0,0,baseH),BackgroundTransparency=1,ZIndex=ZIndex.CONTENT+2,Parent=header})
            headerBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                chevLabel.Text = expanded and "▲" or "▼"
                if expanded then
                    TweenObject(wrapper,{Size=UDim2.new(1,0,0,totalH)},0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                else
                    TweenObject(wrapper,{Size=UDim2.new(1,0,0,baseH)},0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
                end
            end)

            function data:Set(v) sel=v; data._Value=v; selLabel.Text=v end
            return data
        end

        --// ADDBUTTON
        function td:AddButton(bc)
            bc = bc or {}; local nm=bc.Name or "Button"; local cb=bc.Callback
            local item=Create("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,0,0,10,10)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            local btn=Create("TextButton",{
                Text=nm,Font=FontBold,TextSize=12,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,0,1,0),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,Parent=ic,
            })
            ApplyCorner(btn,6)
            btn.MouseEnter:Connect(function() TweenObject(btn,{BackgroundColor3=Theme.ItemHoverBg},0.18) end)
            btn.MouseLeave:Connect(function() TweenObject(btn,{BackgroundColor3=Theme.ItemBg},0.18) end)
            btn.MouseButton1Click:Connect(function()
                TweenObject(btn,{BackgroundColor3=Theme.Accent},0.08)
                TweenObject(btn,{TextColor3=Color3.fromRGB(255,255,255)},0.08)
                task.delay(0.15,function()
                    TweenObject(btn,{BackgroundColor3=Theme.ItemBg},0.22)
                    TweenObject(btn,{TextColor3=Theme.TextPrimary},0.22)
                end)
                if cb then cb() end
            end)
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

            local h = multiLine and 54 or 36
            local item=Create("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,4,4,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)

            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{
                Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,
                TextXAlignment=Enum.TextXAlignment.Left,
                Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Parent=ic,
            })
            local box=Create("TextBox",{
                Text=def,PlaceholderText=ph,Font=Font,TextSize=11,
                TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,
                Size=UDim2.new(1,0,0,multiLine and 30 or 18),
                Position=UDim2.new(0,0,0,18),
                BackgroundColor3=Theme.InputBg,BorderSizePixel=0,
                ClearTextOnFocus=false,TextWrapped=multiLine,
                MultiLine=multiLine,Parent=ic,
            })
            ApplyCorner(box,5)
            local boxStroke = ApplyStroke(box,Theme.Border,1)
            ApplyPadding(box,2,2,4,4)

            -- Focus highlight — reuse stroke instead of creating new ones
            box.Focused:Connect(function() TweenObject(boxStroke,{Color=Theme.Accent},0.15) end)
            box.FocusLost:Connect(function()
                TweenObject(boxStroke,{Color=Theme.Border},0.15)
                if cb then cb(box.Text) end
            end)

            return {_Box=box, Set=function(_,t) box.Text=t end, Get=function() return box.Text end}
        end

        --// ADDCOLORPICKER (popup)
        function td:AddColorPicker(cc)
            cc = cc or {}; local nm=cc.Name or "Color"; local def=cc.Default or Color3.fromRGB(139,92,246); local cb=cc.Callback
            local item=Create("Frame",{Size=UDim2.new(1,0,0,36),BackgroundColor3=Theme.ItemBg,BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page})
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,0,0,10,10)
            ApplyHoverEffect(item, Theme.ItemBg, Theme.ItemHoverBg, true)
            local ic=Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Parent=item})
            Create("TextLabel",{Text=nm,Font=Font,TextSize=12,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,-52,1,0),BackgroundTransparency=1,Parent=ic})
            local cBtn=Create("TextButton",{Text="",Size=UDim2.new(0,32,0,22),Position=UDim2.new(1,-32,0.5,-11),BackgroundColor3=def,BorderSizePixel=0,Parent=ic})
            ApplyCorner(cBtn,6); ApplyStroke(cBtn,Theme.BorderLight,1)
            local data={_Value=def}
            cBtn.MouseButton1Click:Connect(function()
                MIDNIGHT:_OpenColorPicker({
                    ButtonPos=item.AbsolutePosition,Current=cBtn.BackgroundColor3,
                    OnColor=function(c) cBtn.BackgroundColor3=c; data._Value=c; if cb then cb(c) end end,
                })
            end)
            function data:Set(c) cBtn.BackgroundColor3=c; data._Value=c; if cb then cb(c) end end
            return data
        end

        --// ADDINLINECOLORPICKER (inline in tab, no popup)
        function td:AddInlineColorPicker(cc)
            cc = cc or {}; local nm=cc.Name or "Color"; local def=cc.Default or Color3.fromRGB(139,92,246); local cb=cc.Callback

            local presets = {
                Color3.fromRGB(248,113,113),Color3.fromRGB(251,146,60),Color3.fromRGB(250,204,21),
                Color3.fromRGB(74,222,128), Color3.fromRGB(34,211,238),Color3.fromRGB(96,165,250),
                Color3.fromRGB(139,92,246), Color3.fromRGB(232,121,249),Color3.fromRGB(255,255,255),
                Color3.fromRGB(160,160,175),Color3.fromRGB(80,80,95),  Color3.fromRGB(20,20,26),
            }
            local totalH = 12 + 3*26 + 4 + 30 + 8 + 26
            local item=Create("Frame",{
                Size=UDim2.new(1,0,0,totalH),BackgroundColor3=Theme.ItemBg,
                BorderSizePixel=0,LayoutOrder=nextOrder(),Parent=page,
            })
            ApplyCorner(item,6); ApplyStroke(item,Theme.Border,1); ApplyPadding(item,6,6,10,10)

            Create("TextLabel",{Text=nm,Font=FontBold,TextSize=12,TextColor3=Theme.TextPrimary,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Parent=item})

            local grid=Create("Frame",{Size=UDim2.new(1,0,0,80),Position=UDim2.new(0,0,0,20),BackgroundTransparency=1,Parent=item})
            Create("UIGridLayout",{CellSize=UDim2.new(0,0,0,22),SizeConstraint=Enum.SizeConstraint.RelativeXX,CellPadding=UDim2.new(0,4,0,4),SortOrder=Enum.SortOrder.LayoutOrder,Parent=grid})

            local currentColor = def
            local previewBtn
            local data={_Value=def}

            for i, c in ipairs(presets) do
                local pb=Create("TextButton",{Text="",BackgroundColor3=c,BorderSizePixel=0,LayoutOrder=i,Parent=grid})
                ApplyCorner(pb,4); ApplyStroke(pb,Theme.BorderLight,1)
                pb.MouseButton1Click:Connect(function()
                    currentColor=c; data._Value=c
                    if previewBtn then previewBtn.BackgroundColor3=c end
                    if cb then cb(c) end
                end)
            end

            local inputRow=Create("Frame",{Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,0,108),BackgroundTransparency=1,Parent=item})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=inputRow})

            local function mkInput(lbl,val,clr,lo)
                local ct=Create("Frame",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,LayoutOrder=lo,Parent=inputRow})
                Create("TextLabel",{Text=lbl,Font=FontBold,TextSize=9,TextColor3=clr,Size=UDim2.new(0,10,0,12),BackgroundTransparency=1,Parent=ct})
                local bx=Create("TextBox",{Text=tostring(val),Font=Font,TextSize=10,TextColor3=Theme.TextPrimary,PlaceholderColor3=Theme.TextMuted,Size=UDim2.new(0,32,0,22),Position=UDim2.new(0,12,0,2),BackgroundColor3=Theme.InputBg,BorderSizePixel=0,Parent=ct})
                ApplyCorner(bx,3); return bx
            end

            local rB=mkInput("R",math.floor(def.R*255),Color3.fromRGB(255,80,80),1)
            local gB=mkInput("G",math.floor(def.G*255),Color3.fromRGB(80,255,80),2)
            local bB=mkInput("B",math.floor(def.B*255),Color3.fromRGB(80,80,255),3)

            previewBtn=Create("TextButton",{
                Text="",Size=UDim2.new(0,26,0,22),
                BackgroundColor3=def,BorderSizePixel=0,LayoutOrder=4,Parent=inputRow,
            })
            ApplyCorner(previewBtn,5); ApplyStroke(previewBtn,Theme.BorderLight,1)

            local applyBtn2=Create("TextButton",{Text="Apply",Font=FontBold,TextSize=10,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,138),BackgroundColor3=Theme.Accent,BorderSizePixel=0,Parent=item})
            ApplyCorner(applyBtn2,4)
            applyBtn2.MouseButton1Click:Connect(function()
                local r=math.clamp(math.floor(tonumber(rB.Text) or 0),0,255)
                local g=math.clamp(math.floor(tonumber(gB.Text) or 0),0,255)
                local b=math.clamp(math.floor(tonumber(bB.Text) or 0),0,255)
                local c=Color3.fromRGB(r,g,b); currentColor=c; data._Value=c
                previewBtn.BackgroundColor3=c; if cb then cb(c) end
            end)

            function data:Set(c) currentColor=c; data._Value=c; previewBtn.BackgroundColor3=c; if cb then cb(c) end end
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

        return td
    end -- end MakeTab

    --// FLOATING WINDOW
    function wd:MakeFloatingWindow(fc)
        fc = fc or {}; local nm=fc.Name or "Window"; local sz=fc.Size or {300,300}; local canResize=fc.Resizable
        local fw=Create("Frame",{
            Name="FW_"..nm,Size=UDim2.new(0,sz[1],0,sz[2]),
            Position=UDim2.new(0.5,-sz[1]/2,0.5,-sz[2]/2),
            BackgroundColor3=Theme.WindowBg,BorderSizePixel=0,ClipsDescendants=true,
            Visible=false,ZIndex=ZIndex.POPUP,Parent=MIDNIGHT._ScreenGui,
        })
        ApplyCorner(fw,10); ApplyStroke(fw,Theme.Border,1)

        local ftb=Create("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Theme.TitleBarBg,BorderSizePixel=0,ClipsDescendants=true,ZIndex=ZIndex.POPUP+1,Parent=fw})
        ApplyCorner(ftb,10)
        Create("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.new(0,0,1,-8),BackgroundColor3=Theme.TitleBarBg,BorderSizePixel=0,Parent=ftb})
        CreateAccentLine(ftb,10)
        Create("TextLabel",{Text=nm,Font=FontBold,TextSize=11,TextColor3=Theme.TextPrimary,Size=UDim2.new(1,-50,1,0),Position=UDim2.new(0,10,0,0),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=ZIndex.POPUP+2,Parent=ftb})

        local fwClose=Create("TextButton",{Text="",Size=UDim2.new(0,22,0,16),Position=UDim2.new(1,-28,0,8),BackgroundColor3=Theme.CloseNormal,BorderSizePixel=0,ZIndex=ZIndex.POPUP+3,Parent=ftb})
        ApplyCorner(fwClose,4)
        Create("Frame",{Size=UDim2.new(0,8,0,1),Position=UDim2.new(0.5,-4,0.5,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=45,Parent=fwClose})
        Create("Frame",{Size=UDim2.new(0,8,0,1),Position=UDim2.new(0.5,-4,0.5,0),BackgroundColor3=Theme.TextMuted,BorderSizePixel=0,Rotation=-45,Parent=fwClose})
        ApplyHoverEffect(fwClose,Theme.CloseNormal,Theme.CloseHover,false)

        local fScroll=Create("ScrollingFrame",{Size=UDim2.new(1,-8,1,-40),Position=UDim2.new(0,4,0,36),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=Theme.ScrollBarColor,AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=ZIndex.POPUP+1,Parent=fw})
        Create("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2),Parent=fScroll})
        ApplyPadding(fScroll,4,4,4,4)

        MakeDraggable(fw,ftb,function() MIDNIGHT:_CloseAllPopups() end)

        local fData={_Frame=fw,_Scroll=fScroll,_Visible=false}
        fwClose.MouseButton1Click:Connect(function() fData:Toggle() end)

        function fData:Toggle()
            fData._Visible=not fData._Visible
            if fData._Visible then
                fw.Visible=true; fw.BackgroundTransparency=1; fw.Size=UDim2.new(0,0,0,0)
                TweenObject(fw,{Size=UDim2.new(0,sz[1],0,sz[2])},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                TweenObject(fw,{BackgroundTransparency=0},0.25)
            else
                TweenObject(fw,{Size=UDim2.new(0,0,0,0)},0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
                TweenObject(fw,{BackgroundTransparency=1},0.18)
                task.delay(0.25,function() if not fData._Visible then fw.Visible=false end end)
            end
        end

        function fData:AddLine(text,color)
            return Create("TextLabel",{Text=text or "",Font=FontRegular,TextSize=10,TextColor3=color or Theme.TextSecondary,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,Size=UDim2.new(1,0,0,16),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ZIndex=ZIndex.POPUP+2,Parent=fScroll})
        end
        function fData:AddRichLine(name,text,nameColor,textColor)
            local row=Create("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,ZIndex=ZIndex.POPUP+2,Parent=fScroll})
            Create("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=row})
            Create("TextLabel",{Text=name,Font=FontBold,TextSize=10,TextColor3=nameColor or Theme.Accent,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,ZIndex=ZIndex.POPUP+3,Parent=row})
            Create("TextLabel",{Text=text,Font=FontRegular,TextSize=10,TextColor3=textColor or Theme.TextSecondary,Size=UDim2.new(1,0,1,0),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,ZIndex=ZIndex.POPUP+3,Parent=row})
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
            local resDrag=false; local resStart,resStartSize
            rh.InputBegan:Connect(function(inp)
                if inp.UserInputType==Enum.UserInputType.MouseButton1 then
                    resDrag=true; resStart=inp.Position; resStartSize=fw.Size
                    inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then resDrag=false end end)
                end
            end)
            RegConn(UserInputService.InputChanged:Connect(function(inp)
                if resDrag and inp.UserInputType==Enum.UserInputType.MouseMovement then
                    local d=inp.Position-resStart
                    fw.Size=UDim2.new(0,math.max(200,resStartSize.X.Offset+d.X),0,math.max(150,resStartSize.Y.Offset+d.Y))
                end
            end))
        end

        table.insert(self._FloatingWindows,fData)
        return fData
    end

    function wd:CreateAdminLogs(config)
        config=config or {}
        local groupId = config.GroupId or 0
        local ranks   = config.Ranks or {}
        local midnight = MIDNIGHT

        local aw = self:MakeFloatingWindow({Name="Admin Logs", Size={300,380}, Resizable=true})
        if not aw then return nil end

        -- Открыть сразу видимым
        aw._Visible = true
        aw._Frame.Visible = true
        aw._Frame.BackgroundTransparency = 0

        local logOrder = 0
        local function addLog(tag, text, tagColor, textColor)
            logOrder = logOrder + 1
            local time = os.date("%H:%M:%S")
            aw:AddRichLine("["..time.."] "..tag, text, tagColor or Theme.TextMuted, textColor or Theme.TextSecondary)
            -- Скроллим вниз
            task.defer(function()
                if aw._Scroll and aw._Scroll.Parent then
                    aw._Scroll.CanvasPosition = Vector2.new(0, aw._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        -- Проверка является ли игрок админом
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

        -- Цвет по рангу
        local function rankColor(player)
            local ok, rank = pcall(function() return player:GetRankInGroup(groupId) end)
            if not ok then return Theme.TextAccent end
            return rank>=200 and Theme.Error or rank>=100 and Theme.Warning or rank>=50 and Theme.Success or Theme.TextAccent
        end

        -- Подписка на чат игрока
        local chatConns = {}
        local function watchChat(player)
            if chatConns[player.UserId] then return end
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local conn = player.Chatted:Connect(function(msg)
                local nc = rankColor(player)
                addLog(player.DisplayName, msg, nc, Theme.TextSecondary)
            end)
            chatConns[player.UserId] = conn
            RegConn(conn)
        end

        -- Подписка на спавн/деспавн
        local function watchSpawn(player)
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local nc = rankColor(player)
            RegConn(player.CharacterAdded:Connect(function()
                addLog(player.DisplayName, "spawned ["..tostring(rankName).."]", nc, Theme.Success)
                midnight:Notify({Title="Admin Spawned", Content=player.DisplayName.." ("..tostring(rankName)..")", Type="warning", Duration=6})
            end))
            RegConn(player.CharacterRemoving:Connect(function()
                addLog(player.DisplayName, "despawned", nc, Theme.TextMuted)
            end))
        end

        -- Обработка входа игрока
        local function onPlayerAdded(player)
            task.delay(2, function()
                if not player or not player.Parent then return end
                local ok2, admin, rankName = pcall(isAdmin, player)
                if not (ok2 and admin) then return end
                local nc = rankColor(player)
                addLog(player.DisplayName, "joined ["..tostring(rankName).."]", nc, Theme.Warning)
                midnight:Notify({
                    Title = "⚠ Admin Joined",
                    Content = player.DisplayName .. " — " .. tostring(rankName),
                    Type = "warning",
                    Duration = 8,
                })
                -- Открыть окно автоматически
                if not aw._Visible then aw:Toggle() end
                watchChat(player)
                watchSpawn(player)
            end)
        end

        -- Обработка выхода
        local function onPlayerRemoving(player)
            local ok2, admin, rankName = pcall(isAdmin, player)
            if not (ok2 and admin) then return end
            local nc = rankColor(player)
            addLog(player.DisplayName, "left ["..tostring(rankName).."]", nc, Theme.Error)
            midnight:Notify({
                Title = "Admin Left",
                Content = player.DisplayName .. " disconnected",
                Type = "info",
                Duration = 5,
            })
            chatConns[player.UserId] = nil
            adminCache[player.UserId] = nil
            adminCache[player.UserId .. "_rank"] = nil
        end

        -- Инициализация текущих игроков
        addLog("SYSTEM", "Admin monitor started", Theme.Accent, Theme.TextSecondary)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local ok2, admin, rankName = pcall(isAdmin, p)
                if ok2 and admin then
                    local nc = rankColor(p)
                    addLog(p.DisplayName, "online ["..tostring(rankName).."]", nc, Theme.TextAccent)
                    watchChat(p)
                    watchSpawn(p)
                end
            end
        end

        RegConn(Players.PlayerAdded:Connect(onPlayerAdded))
        RegConn(Players.PlayerRemoving:Connect(onPlayerRemoving))
        return aw
    end
    function wd:CreateAdminChecker(c) return self:CreateAdminLogs(c) end

    function wd:TestAdminLogs()
        local midnight = MIDNIGHT

        -- Открываем окно Admin Logs
        local aw = self:MakeFloatingWindow({Name="Admin Logs [TEST]", Size={300,380}, Resizable=true})
        if not aw then return nil end

        aw._Visible = true
        aw._Frame.Visible = true
        aw._Frame.BackgroundTransparency = 0

        local function addLog(tag, text, tagColor, textColor)
            local time = os.date("%H:%M:%S")
            aw:AddRichLine("["..time.."] "..tag, text, tagColor or Theme.TextMuted, textColor or Theme.TextSecondary)
            task.defer(function()
                if aw._Scroll and aw._Scroll.Parent then
                    aw._Scroll.CanvasPosition = Vector2.new(0, aw._Scroll.AbsoluteCanvasSize.Y)
                end
            end)
        end

        -- Фейковые данные для теста
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

        -- Шаг 1: нотификация — Join
        midnight:Notify({
            Title   = "⚠ Admin Joined [TEST]",
            Content = admin.name .. " — " .. admin.rank,
            Type    = "warning",
            Duration = 8,
        })
        addLog("SYSTEM", "Test sequence started", Theme.Accent, Theme.TextSecondary)
        addLog(admin.name, "joined ["..admin.rank.."]", admin.rankColor, Theme.Warning)

        -- Шаг 2: Смена команды
        task.delay(1.8, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            midnight:Notify({
                Title   = "⚠ Team Switch [TEST]",
                Content = admin.name .. " switched team",
                Type    = "warning",
                Duration = 5,
            })
            addLog(admin.name, "switched to Spectators", admin.rankColor, Theme.Warning)
        end)

        -- Шаг 3: Сообщение в чате
        task.delay(3.8, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            local msg = fakeMessages[math.random(1, #fakeMessages)]
            midnight:Notify({
                Title   = "⚠ Admin Chat [TEST]",
                Content = admin.name .. ": " .. msg,
                Type    = "warning",
                Duration = 5,
            })
            addLog(admin.name, msg, admin.rankColor, Theme.TextSecondary)
        end)

        -- Шаг 4: Ещё одно сообщение
        task.delay(5.5, function()
            if not aw._Frame or not aw._Frame.Parent then return end
            addLog(admin.name, "!spectate localplayer", admin.rankColor, Theme.Warning)
            midnight:Notify({
                Title   = "⚠ Admin Command [TEST]",
                Content = admin.name .. " used a command",
                Type    = "warning",
                Duration = 5,
            })
        end)

        -- Шаг 5: Выход
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

    function wd:CreateChatLogger()
        local cw = self:MakeFloatingWindow({Name="Chat Logger", Size={320,350}, Resizable=true})
        if not cw then return nil end

        local function onChat(player, message)
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

        -- Ловим чат всех включая LocalPlayer
        RegConn(LocalPlayer.Chatted:Connect(function(msg) onChat(LocalPlayer, msg) end))
        for _, p in ipairs(Players:GetPlayers()) do
            RegConn(p.Chatted:Connect(function(msg) onChat(p, msg) end))
        end
        RegConn(Players.PlayerAdded:Connect(function(p)
            RegConn(p.Chatted:Connect(function(msg) onChat(p, msg) end))
        end))
        return cw
    end

    return wd
end

--// ═══════════════════════════════════════════════════════════
--// DESTROY
--// ═══════════════════════════════════════════════════════════
function MIDNIGHT:Destroy()
    -- Disconnect all tracked connections
    for _, conn in ipairs(self._Connections) do
        pcall(function() conn:Disconnect() end)
    end
    self._Connections = {}

    if self._MenuToggleConn then pcall(function() self._MenuToggleConn:Disconnect() end); self._MenuToggleConn=nil end
    if self._ActiveDropdownCloseConn then pcall(function() self._ActiveDropdownCloseConn:Disconnect() end); self._ActiveDropdownCloseConn=nil end
    if self._ActiveColorPickerCloseConn then pcall(function() self._ActiveColorPickerCloseConn:Disconnect() end); self._ActiveColorPickerCloseConn=nil end
    if self._KeybindSettingsCloseConn then pcall(function() self._KeybindSettingsCloseConn:Disconnect() end); self._KeybindSettingsCloseConn=nil end

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

--// ═══════════════════════════════════════════════════════════
--// EXPOSE KEY UTILS
--// ═══════════════════════════════════════════════════════════
MIDNIGHT.KeyUtils = KeyUtils
MIDNIGHT.LucideIcons = LucideIcons
MIDNIGHT.LucideBloxAssets = LucideBloxAssets

return MIDNIGHT
