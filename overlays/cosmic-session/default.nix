final: prev: {
  cosmic-session = prev.cosmic-session.overrideAttrs (old: {
    patches = [
      ./patches/fix_gcr_ssh_agent_compat.patch
    ];
  });
}
