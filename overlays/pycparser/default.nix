final: prev: {
	python313 = prev.python313.override {
		packageOverrides = pyfinal: pyprev: {
			pycparser = pyprev.pycparser.overrideAttrs (old: {
				patches = (old.patches or []) ++ [ ./clang-compat.patch ];
			});
		};
	};
}
