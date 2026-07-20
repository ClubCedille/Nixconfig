# modules/user-lanets.nix
{ ... }: {
  users.mutableUsers = false;
  users.users = {
    admin = {
      isNormalUser = true;
      description = "Admin User";
      extraGroups = [ 
        "wheel"            # Permet le sudo
        "networkmanager"   # Permet de gérer le réseau
      ];
      hashedPassword = "$6$TKfGeY8sbOSwaSvS$Egxmjy6PHSgkGvE1gUu4xQOYPfyZxf6C1JJb9uxQ4g97JxvJXfR71Jj6ZqJSB.qpZPZebhBKeTzd/1sRF.JuX1";
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

      hashedPassword = "$6$ocsgs1qwmSw.43D6$XOAcVuARfJOKc0qzNcXCZsF.zk83iThm4ZjNYHol/kjYnsreHydD0136BlQgt2WQaeoR7XsLi/d7WChN86csj.";

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