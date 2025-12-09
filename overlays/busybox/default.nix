final: prev: {
  busybox = prev.busybox.overrideAttrs (old: {
    patches = old.patches ++ [
      (final.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-25.11/pkgs/os-specific/linux/busybox/clang-cross.patch";
        hash = "sha256-pS7LxfDt32/pTKE8UqpY9IBTv9Z8ybvYRJeRZkrpu2I=";
      })
    ];
  });
}
