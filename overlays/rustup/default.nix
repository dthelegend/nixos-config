final: prev: {
  rustup = prev.rustup.overrideAttrs {
    doCheck = false;
  };
}
