{
  description = "Fcitx5 Themes Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.1.0";

        mkThemePackage = { themeName, themeSrcPath, descriptionSuffix ? "" }:
          pkgs.stdenv.mkDerivation {
            pname = "fcitx5-${themeName}-theme";
            inherit version;

            src = themeSrcPath;

            dontBuild = true;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/fcitx5/themes/${themeName}
              cp -r ./* $out/share/fcitx5/themes/${themeName}/

              runHook postInstall
            '';

            meta = {
              description = "Fcitx5 ${themeName} theme${descriptionSuffix}";
              homepage = "https://github.com/Beriholic/fcitx5-simple-theme";
              license = pkgs.lib.licenses.mit;
              maintainers = [ pkgs.lib.maintainers.Beriholic ];
              platforms = pkgs.lib.platforms.all;
            };
          };

        darkTheme = mkThemePackage {
          themeName = "simple-dark";
          themeSrcPath = ./dark;
          descriptionSuffix = " (Dark)";
        };

        whiteTheme = mkThemePackage {
          themeName = "simple-white";
          themeSrcPath = ./white;
          descriptionSuffix = " (White)";
        };

        themesCollection = pkgs.stdenv.mkDerivation {
          pname = "fcitx5-themes-collection";
          inherit version;

          dontUnpack = true;

          nativeBuildInputs = [ darkTheme whiteTheme ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/fcitx5/themes
            cp -r ${darkTheme}/share/fcitx5/themes/simple-dark $out/share/fcitx5/themes/simple-dark
            cp -r ${whiteTheme}/share/fcitx5/themes/simple-white $out/share/fcitx5/themes/simple-white

            runHook postInstall
          '';

          meta = {
            description = "Collection of Fcitx5 dark and white themes";
            homepage = "https://github.com/Beriholic/fcitx5-simple-theme";
            license = pkgs.lib.licenses.mit;
            maintainers = [ pkgs.lib.maintainers.Beriholic ];
            platforms = pkgs.lib.platforms.all;
          };
        };

      in {
        packages = {
          inherit darkTheme whiteTheme themesCollection;
          fcitx5-dark-theme = darkTheme;
          fcitx5-white-theme = whiteTheme;
          fcitx5-simple-themes = themesCollection;
        };

        defaultPackage = themesCollection;
      });
}
