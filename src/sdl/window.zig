const std = @import("std");
const raw = @import("sdl_c.zig");

const WindowPos = union(enum) {
    Absolute: c_int,
    Center,
    Undefined,
    fn get_value(self: WindowPos) c_int {
        switch (self) {
            .Absolute => |p| {
                return p;
            },
            .Center => {
                return raw.SDL_WINDOWPOS_CENTERED;
            },
            .Undefined => {
                return raw.SDL_WINDOWPOS_UNDEFINED;
            },
        }
    }
};

pub const WindowFlags = packed struct(u32) {
    fullscreen: bool = false,
    opengl: bool = false,
    shown: bool = false,
    hidden: bool = false,
    borderless: bool = false,
    resizable: bool = false,
    minimized: bool = false,
    maximized: bool = false,
    input_grabbed: bool = false,
    input_focus: bool = false,
    mouse_focus: bool = false,
    foreign: bool = false,

    fullscreen_desktop: bool = false,

    allow_heghdpi: bool = false,
    mouse_capture: bool = false,
    always_on_top: bool = false,
    skip_taskbar: bool = false,
    utility: bool = false,
    tooltip: bool = false,
    popup_menu: bool = false,

    // not sure is real
    keyboard_grabbed: bool = false,

    _: u7 = 0,
    vulkan: bool = false,

    // not sure is real
    metal: bool = false,

    __: u2 = 0,
};

pub const Window = struct {
    inner: *raw.SDL_Window,

    pub fn init(title: [*c]const u8, x: WindowPos, y: WindowPos, w: c_int, h: c_int, flags: WindowFlags) ?Window {
        var inner = raw.SDL_CreateWindow(title, x.get_value(), y.get_value(), w, h, @bitCast(flags));

        if (inner == null) {
            return null;
        }

        return Window{ .inner = inner.? };
    }

    pub fn deinit(self: *Window) void {
        raw.SDL_DestroyWindow(self.inner);
    }
};

test "window_flags_correct" {
    try std.testing.expectEqual(raw.SDL_WINDOW_FULLSCREEN, @as(u32, @bitCast(WindowFlags{ .fullscreen = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_FULLSCREEN_DESKTOP - 1, @as(u32, @bitCast(WindowFlags{ .fullscreen_desktop = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_OPENGL, @as(u32, @bitCast(WindowFlags{ .opengl = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_VULKAN, @as(u32, @bitCast(WindowFlags{ .vulkan = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_SHOWN, @as(u32, @bitCast(WindowFlags{ .shown = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_HIDDEN, @as(u32, @bitCast(WindowFlags{ .hidden = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_BORDERLESS, @as(u32, @bitCast(WindowFlags{ .borderless = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_RESIZABLE, @as(u32, @bitCast(WindowFlags{ .resizable = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_MINIMIZED, @as(u32, @bitCast(WindowFlags{ .minimized = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_MAXIMIZED, @as(u32, @bitCast(WindowFlags{ .maximized = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_INPUT_GRABBED, @as(u32, @bitCast(WindowFlags{ .input_grabbed = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_INPUT_FOCUS, @as(u32, @bitCast(WindowFlags{ .input_focus = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_MOUSE_FOCUS, @as(u32, @bitCast(WindowFlags{ .mouse_focus = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_FOREIGN, @as(u32, @bitCast(WindowFlags{ .foreign = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_ALLOW_HIGHDPI, @as(u32, @bitCast(WindowFlags{ .allow_heghdpi = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_MOUSE_CAPTURE, @as(u32, @bitCast(WindowFlags{ .mouse_capture = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_ALWAYS_ON_TOP, @as(u32, @bitCast(WindowFlags{ .always_on_top = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_SKIP_TASKBAR, @as(u32, @bitCast(WindowFlags{ .skip_taskbar = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_UTILITY, @as(u32, @bitCast(WindowFlags{ .utility = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_TOOLTIP, @as(u32, @bitCast(WindowFlags{ .tooltip = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_POPUP_MENU, @as(u32, @bitCast(WindowFlags{ .popup_menu = true })));

    try std.testing.expectEqual(raw.SDL_WINDOW_KEYBOARD_GRABBED, @as(u32, @bitCast(WindowFlags{ .keyboard_grabbed = true })));
    try std.testing.expectEqual(raw.SDL_WINDOW_METAL, @as(u32, @bitCast(WindowFlags{ .metal = true })));
}
