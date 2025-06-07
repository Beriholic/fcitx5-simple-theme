# fcitx5-simple-theme

This is a simple theme for fcitx5.

# How to use
Add this flake to your `flake.nix` file:

```nix
{
  inputs = {
    fcitx5-simple-theme.url = "github:Beriholic/fcitx5-simple-theme";
  };
```

```nix
  environment.systemPackages = [
    inputs.fcitx5-simple-theme.packages.${pkgs.system}.fcitx5-dark-theme
    inputs.fcitx5-simple-theme.packages.${pkgs.system}.fcitx5-white-theme

    # or
    inputs.fcitx5-simple-theme.defaultPackage.${pkgs.system}
  ];
```
