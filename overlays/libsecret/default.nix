final: prev: {
  libsecret = prev.libsecret.overrideAttrs {
    doCheck = false;
  };
}
