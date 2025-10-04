# This is my riff on the web app integration that Omarchy has. I wanted my cake and eat it too!

{ pkgs, ... }:
let
  mkWebApp = { name, url, class ? "webapp-${name}" }:
    pkgs.writeShellApplication {
      name = "launch-${name}";
      runtimeInputs = [ pkgs.chromium ];  # keep chromium in the closure
      text = ''
        exec chromium \
          --ozone-platform=wayland \
          --enable-features=UseOzonePlatform,WaylandWindowDecorations \
          --class=${class} --name=${class} \
          --user-data-dir="$HOME/.local/share/webapps/${name}" \
          --app="${url}"
      '';
    };
in
{
  home.packages = [
    (mkWebApp { name = "chatgpt"; url = "https://chat.openai.com/"; })
    (mkWebApp { name = "ytmusic"; url = "https://music.youtube.com"; })
  ];

  xdg.desktopEntries = {
    chatgpt = {
      name = "ChatGPT";
      exec = "launch-chatgpt";
      icon = "chatgpt";
      terminal = false;
      type = "Application";
      settings = { StartupWMClass = "webapp-chatgpt"; };
    };
    ytmusic = {
      name = "YouTube Music";
      exec = "yt-music";
      icon = "youtube";
      terminal = false;
      type = "Application";
      settings = { StartupWMClass = "webapp-ytmusic"; };
    };

  };
}

