final: prev: {
  sdl3 = prev.sdl3.overrideAttrs {
    doCheck = false;
  };
}
