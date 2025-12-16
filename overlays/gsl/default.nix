final: prev: {
  gsl = prev.gsl.overrideAttrs {
    doCheck = false;
  };
}
