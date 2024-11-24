{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            vim
            direnv
            sshs
            glow
          ];
        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true; # default shell on catalina
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        nixpkgs.hostPlatform = "aarch64-darwin";
        security.pam.enableSudoTouchIdAuth = true;

        users.users.alc.home = "/Users/alc";
        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
          finder.FXPreferredViewStyle = "clmv";
          loginwindow.LoginwindowText = "Those who would give up essential Liberty, to purchase a little temporary Safety, deserve neither Liberty nor Safety.";
          screencapture.location = "~/Pictures/screenshots";
          screensaver.askForPasswordDelay = 10;
        };

        # Homebrew needs to be installed on its own!
        homebrew.enable = true;
        homebrew.casks = [
          "wireshark"
          "firefox"
          "wezterm"
        ];
        homebrew.brews = [
          "imagemagick"
          "nushell"
        ];
      };
    in
    {
      darwinConfigurations."AM-VYH2F56CR6" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alc = import ./home.nix;
          }
        ];
<<<<<<< Updated upstream
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      users.users.omerxx.home = "/Users/omerxx";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "devops-toolbox";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
=======
>>>>>>> Stashed changes
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."AM-VYH2F56CR6".pkgs;
    };
<<<<<<< Updated upstream
  in
  {
    darwinConfigurations."Omers-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
	configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.omerxx = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Omers-MacBook-Pro".pkgs;
  };
=======
>>>>>>> Stashed changes
}
