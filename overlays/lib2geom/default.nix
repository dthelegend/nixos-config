final: prev: {
  lib2geom = prev.lib2geom.overrideAttrs {
    doCheck = false;
  };
}
