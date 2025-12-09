final: prev: {
  rustc = let
	rustc-unwrapped-fixed = prev.rustc-unwrapped.override {
		llvmPackages = final.llvmPackages;
	};
  in prev.rustc.override {
	rustc-unwrapped = rustc-unwrapped-fixed;
  };
}
