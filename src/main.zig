const std = @import("std");

const sdl = @cImport(@cInclude("SDL.h"));

const AppError = error{
    SDLInitFailed,
    WindowInitFailed,
    RendererInitFailed,
};

const App = struct {
    running: bool,
    window: *sdl.SDL_Window,
    renderer: *sdl.SDL_Renderer,

    fn init() AppError!App {
        if (sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING) < 0) {
            std.debug.print("Error SDL2 Initialization : {s}", .{sdl.SDL_GetError()});
            return error.SDLInitFailed;
        }

        var window = sdl.SDL_CreateWindow("Nubibus", sdl.SDL_WINDOWPOS_CENTERED, sdl.SDL_WINDOWPOS_CENTERED, 800, 600, sdl.SDL_WINDOW_OPENGL);

        if (window == null) {
            std.debug.print("Error window creation", .{});
            return error.WindowInitFailed;
        }

        var renderer = sdl.SDL_CreateRenderer(window, -1, sdl.SDL_RENDERER_ACCELERATED);
        if (renderer == null) {
            std.debug.print("Error renderer creation", .{});
            return error.RendererInitFailed;
        }

        return App{
            .running = true,
            .window = window.?,
            .renderer = renderer.?,
        };
    }

    fn deinit(self: *App) void {
        sdl.SDL_DestroyRenderer(self.renderer);
        sdl.SDL_DestroyWindow(self.window);

        sdl.SDL_Quit();
    }

    fn on_event(self: *App, raw_event: [*c]sdl.SDL_Event) void {
        var event = raw_event[0];

        if (event.type == sdl.SDL_QUIT) {
            self.running = false;
        }
    }

    fn on_update(self: *App) void {
        _ = self;
    }

    fn on_render(self: *App) void {
        _ = self;
    }

    fn execute(self: *App) void {
        while (self.running) {
            var event: [*c]sdl.SDL_Event = null;

            if (sdl.SDL_WaitEvent(event) != 0) {
                self.on_event(event);
            }
            self.on_update();
            self.on_render();
        }
    }
};

pub fn main() void {
    var app = App.init() catch unreachable;
    defer app.deinit();

    app.execute();
}
