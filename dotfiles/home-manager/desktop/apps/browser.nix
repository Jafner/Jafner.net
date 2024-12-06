{ ... }: {
  services.flatpak.packages = [ 
    "io.github.zen_browser.zen/x86_64/stable" 
    "org.mozilla.firefox/x86_64/stable"
    "org.chromium.Chromium/x86_64/stable"
  ];
}
