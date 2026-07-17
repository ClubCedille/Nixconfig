# modules/user-lanets.nix
{ pkgs, ... }: {
  users.users = {
    admin = {
      isNormalUser = true;
      description = "Admin User";
      extraGroups = [ 
        "wheel"            # Permet le sudo
        "networkmanager"   # Permet de gérer le réseau
      ];
      hashedPassword = "$6$mKDEB/jVFACLiu4U$oD076rKRPiPWoqhhIgQZ4FZQxNuac16dCmmGg/BZVwEaaTSnzAIvJC.LLZsK4hdLhH5MO0Bm1BkcvP/mQ7Etj0";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+RLnMHSHLIy8iHgBY0Xkiv3u1zpXzhuXLOwWSvswuR louis@nixos"
      ];
    };

    lanets = {
      isNormalUser = true;
      description = "Lan ETS User";

      extraGroups = [ 
        "networkmanager"
      ];

      hashedPassword = "$6$pQiqkEBV./hE3eMe$9K2aS4tlBo7aIR6vVHEt/8OGr9tRibNjnpTKVzIhmMcDFzUhJ654S0yPDY6s0lw/lX7EwU7Enc849Tzz6WlQB/";

      # openssh.authorizedKeys.keys = [ ... ];
    };

  };

  # --- CONFIGURATION DU SERVICE SSH ---
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}