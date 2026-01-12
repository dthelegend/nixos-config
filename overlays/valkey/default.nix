final: prev: {
  valkey = prev.valkey.overrideAttrs {
    doCheck = false;
  };
}
