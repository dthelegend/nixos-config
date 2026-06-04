final: prev: {
  linux-firmware = (prev.linux-firmware.overrideAttrs (old: {
    preInstall = ''
      	mkdir -p $out/lib/firmware
    ''
    + (old.preInstall or "");
  })).overrideDerivation (old: { nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ prev.parallel ]; });
}
