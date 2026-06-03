final: prev: {
  libtpms = prev.libtpms.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error=stringop-overflow";
  });
}
