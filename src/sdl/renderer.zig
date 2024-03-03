const std = @import("std");
const raw = @import("sdl_c.zig");

const win = @import("window.zig");

pub const RendererFlags = packed struct(u32) {
    software: bool = false,
    accelerate: bool = false,
    present_vsync: bool = false,
    target_texture: bool = false,
    _: u28 = 0,
};

pub const RendererError = error{
    RendererInitFailed,
};

pub const Renderer = struct {
    inner: *raw.SDL_Renderer,

    pub fn init(window: *win.Window, index: c_int, flags: RendererFlags) RendererError!Renderer {
        var inner = raw.SDL_CreateRenderer(window.inner, index, @bitCast(flags));

        if (inner == null) {
            return error.RendererInitFailed;
        }

        return Renderer{
            .inner = inner.?,
        };
    }

    pub fn deinit(self: *Renderer) void {
        raw.SDL_DestroyRenderer(self.inner);
    }
};
