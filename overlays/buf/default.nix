final: prev: {
  buf = prev.buf.overrideAttrs {
    doCheck = false;
  };
}
