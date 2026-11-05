# modules/user-cedille.nix
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
      hashedPassword = "$y$j9T$yC8Th47in7laCT5/bR3b5/$ONb3bDpjH/j20XE3XXfbxqSybMdbtSsjMo6o8FKf8t1";
      openssh.authorizedKeys.keys = [
        "$y$j9T$yC8Th47in7laCT5/bR3b5/$ONb3bDpjH/j20XE3XXfbxqSybMdbtSsjMo6o8FKf8t1"
      ];
    };

    cedille-user = {
      isNormalUser = true;
      description = "Cedille User";

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
