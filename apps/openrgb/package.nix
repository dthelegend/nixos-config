{ pkgs, ... }:

pkgs.openrgb.overrideAttrs (old: {
  src = prev.fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "release_candidate_1.0rc2";
    sha256 = "vdIA9i1ewcrfX5U7FkcRR+ISdH5uRi9fz9YU5IkPKJQ=";
  };
  patches = [
    ./patches/remove_systemd_service.patch
  ];
  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
        --replace-fail /usr/bin/env "${prev.coreutils}/bin/env"
  '';
  version = "1.0rc2";
})
