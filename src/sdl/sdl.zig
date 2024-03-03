const std = @import("std");
pub const raw = @import("sdl_c.zig");

pub const window = @import("window.zig");
pub const renderer = @import("renderer.zig");

pub const InitError = error{ SDLInitFailed, TTFInitFailed, ImageInitFailded };

pub fn init() InitError!void {
    if (raw.SDL_Init(raw.SDL_INIT_EVERYTHING) < 0) {
        std.debug.print("Error SDL2 Initialization : {s}\n", .{raw.SDL_GetError()});
        return error.SDLInitFailed;
    }

    if (raw.TTF_Init() < 0) {
        std.debug.print("Error SDL2_TTF Initialization: {s}\n", .{raw.TTF_GetError()});
        return error.TTFInitFailed;
    }

    if (raw.IMG_Init(raw.IMG_INIT_PNG) == 0) {
        std.debug.print("Error SDL2_image Initialization: {s}\n", .{raw.IMG_GetError()});
        return error.ImageInitFailded;
    }
}

pub fn quit() void {
    raw.SDL_Quit();
}
