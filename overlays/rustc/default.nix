final: prev: {
  rustc = let
	rustc-unwrapped-fixed = prev.rustc-unwrapped.override {
  		# We have to use a clean stdenv because the rust toolchain by default cross-compiles some stuff that breaks with native optimisations
  		stdenv = (final.overrideCC final.clangStdenv final.llvmPackages_latest.clang);
		llvmPackages = final.llvmPackages_latest;
	};
  in prev.rustc.override {
	rustc-unwrapped = rustc-unwrapped-fixed;
  };
}
