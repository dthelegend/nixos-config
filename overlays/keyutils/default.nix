final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (python-final: python-prev: {
      keyutils = python-prev.keyutils.overridePythonAttrs {
        src = prev.fetchzip {
          url = "http://deb.debian.org/debian/pool/main/p/python-keyutils/python-keyutils_0.6.orig.tar.gz";
          hash = "sha256-/oL510Qi6ryugCuqx8/jPQGYlhGKDlMY54+2a9NTM88=";
        };
	doCheck = false;
      };
    })
  ];
}
