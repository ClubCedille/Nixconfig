# modules/networking.nix
{ pkgs, ... }: {

  networking.hostName = ""; 

  systemd.services.dynamic-hostname = {
    description = "Génération dynamique du Hostname via le numéro de série";
    before = [ "network-pre.target" "systemd-sysctl.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Récupération du numéro de série (en minuscules, sans espaces)
      SERIAL=$(${pkgs.coreutils}/bin/cat /sys/class/dmi/id/product_serial | ${pkgs.gnused}/bin/sed 's/ //g' | ${pkgs.coreutils}/bin/tr '[:upper:]' '[:lower:]')
      
      # Fallback si le numéro de série est générique/indisponible (ex: dans une VM de test)
      if [ -z "$SERIAL" ] || [ "$SERIAL" = "00000000" ] || [ "$SERIAL" = "tobedefilledbyo.e.m." ]; then
        SERIAL="vm-$(head -c 4 /dev/urandom | od -An -tx1 | tr -d ' ')"
      fi

      HOSTNAME="lanets-$SERIAL"
      
      # Application immédiate du hostname au système
      echo "$HOSTNAME" > /etc/hostname
      ${pkgs.procps}/bin/hostname "$HOSTNAME"
    '';
  };
}
