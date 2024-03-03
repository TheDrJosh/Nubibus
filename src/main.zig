const std = @import("std");

const sdl = @import("sdl/sdl.zig");

const text: [*c]const u16 = std.unicode.utf8ToUtf16LeStringLiteral("申し訳ございませんがたくさんあります。\n忘れている世界によって忘れている世界。\n汚れのない心の永遠の日差し！\nそれぞれの祈りが受け入れられ、それぞれが辞任を望む");

const AppError = error{
    ImageInitFailded,
};

const App = struct {
    running: bool,
    window: sdl.window.Window,
    renderer: sdl.renderer.Renderer,

    kosugi: *sdl.raw.TTF_Font,
    kosugi_tex: *sdl.raw.SDL_Texture,
    text_rect: sdl.raw.SDL_Rect,

    lettuce_tex: *sdl.raw.SDL_Texture,

    fn init() !App {
        try sdl.init();

        var window = try sdl.window.Window.init("Nubibus", .Undefined, .Undefined, 800, 600, .{ .opengl = true, .resizable = true });

        var renderer = try sdl.renderer.Renderer.init(&window, -1, sdl.renderer.RendererFlags{ .accelerate = true });

        var lettuce_sur = sdl.raw.IMG_Load("lettuce.png");
        if (lettuce_sur == null) {
            std.debug.print("Error loading image: {s}\n", .{sdl.raw.IMG_GetError()});
            return error.ImageInitFailded;
        }
        defer sdl.raw.SDL_FreeSurface(lettuce_sur);

        var lettuce_tex = sdl.raw.SDL_CreateTextureFromSurface(renderer.inner, lettuce_sur);
        if (lettuce_tex == null) {
            std.debug.print("Error creating texture\n", .{});
            return error.ImageInitFailded;
        }

        var kosugi = sdl.raw.TTF_OpenFont("KosugiMaru-Regular.ttf", 16);
        if (kosugi == null) {
            std.debug.print("Error creating font\n", .{});
            return error.TTFInitFailed;
        }

        var kosugi_sur: *sdl.raw.SDL_Surface = sdl.raw.TTF_RenderUNICODE_Blended_Wrapped(kosugi, text, sdl.raw.SDL_Color{ .r = 255, .g = 255, .b = 255, .a = 255 }, 300);
        defer sdl.raw.SDL_FreeSurface(kosugi_sur);

        const rect = sdl.raw.SDL_Rect{ .x = 50, .y = 100, .w = kosugi_sur.w, .h = kosugi_sur.h };

        var kosugi_tex = sdl.raw.SDL_CreateTextureFromSurface(renderer.inner, kosugi_sur);

        return App{
            .running = true,
            .window = window,
            .renderer = renderer,
            .lettuce_tex = lettuce_tex.?,
            .kosugi = kosugi.?,
            .kosugi_tex = kosugi_tex.?,
            .text_rect = rect,
        };
    }

    fn deinit(self: *App) void {
        sdl.raw.SDL_DestroyTexture(self.lettuce_tex);
        sdl.raw.SDL_DestroyTexture(self.kosugi_tex);

        self.renderer.deinit();
        self.window.deinit();
        sdl.raw.TTF_CloseFont(self.kosugi);

        sdl.quit();
    }

    fn on_event(self: *App, event: *sdl.raw.SDL_Event) void {
        if (event.*.type == sdl.raw.SDL_QUIT) {
            self.running = false;
        }

        // std.debug.print("{d}\n", .{event.*.type});
    }

    fn on_update(self: *App) void {
        _ = self;
    }

    fn on_render(self: *App) void {
        _ = sdl.raw.SDL_RenderClear(self.renderer.inner);

        _ = sdl.raw.SDL_RenderCopy(self.renderer.inner, self.lettuce_tex, null, null);
        _ = sdl.raw.SDL_RenderCopy(self.renderer.inner, self.kosugi_tex, null, &self.text_rect);

        sdl.raw.SDL_RenderPresent(self.renderer.inner);
    }

    fn execute(self: *App) void {
        while (self.running) {
            var event: sdl.raw.SDL_Event = undefined;

            if (sdl.raw.SDL_PollEvent(&event) != 0) {
                self.on_event(&event);
            }
            self.on_update();
            self.on_render();
        }
    }
};

pub fn main() void {
    var app = App.init() catch unreachable;
    defer app.deinit();

    var thread = std.Thread.spawn(.{}, thread_stuff, .{}) catch unreachable;
    thread.detach();

    app.execute();
}

fn thread_stuff() void {
    var a: u64 = 1;
    var b: u64 = 1;

    std.debug.print("1\n1\n", .{});

    for (0..90) |_| {
        var c = a + b;
        a = b;
        b = c;
        std.debug.print("{d}\n", .{c});
        std.time.sleep(std.time.ns_per_s);
    }
}
