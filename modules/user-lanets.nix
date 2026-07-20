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

      hashedPassword = "$6$N7G5vCnv4v1284RI$dnPPYUuGJC32SnxLC2USbfwTrg7UXigwox..XeChieGrYlDRhbgFxaGMB3joB30GTt2qEe4BxvzCyWYljOS5R/";

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