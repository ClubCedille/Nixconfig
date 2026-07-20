# modules/pin-firefox-taskbar.nix
#
# Épingle Firefox dans la barre des tâches (Task Manager) de Plasma pour
# tous les utilisateurs. Pas de fichier de layout /etc/xdg codé en dur ici :
# le layout par défaut de Plasma (containments/applets) n'a pas d'IDs
# stables, donc un appletsrc écrit à la main risquerait de ne matcher aucun
# widget réel selon la version de Plasma. On utilise plutôt l'API de
# scripting officielle de Plasma (org.kde.PlasmaShell.evaluateScript, la
# même utilisée par kwriteconfig/lookandfeeltool) : elle retrouve le Task
# Manager dynamiquement, où qu'il soit dans le panel, et ajoute Firefox à sa
# liste de launchers sans écraser les autres épingles déjà présentes.
#
# Tourne à chaque connexion (unité systemd --user, oneshot) plutôt qu'une
# seule fois : idempotent (vérifie déjà présent avant d'ajouter), donc sans
# effet de bord si Firefox est déjà épinglé, mais s'auto-corrige si un
# nouveau profil KDE ne l'a pas encore.
{ pkgs, ... }:
let
  pinScript = pkgs.writeShellScript "pin-firefox-taskbar" ''
    set -eu

    # Attend que plasmashell soit prêt sur le bus de session (jusqu'à 30s).
    for _ in $(seq 1 30); do
      if ${pkgs.dbus}/bin/dbus-send --session --print-reply \
          --dest=org.freedesktop.DBus /org/freedesktop/DBus \
          org.freedesktop.DBus.NameHasOwner string:org.kde.plasmashell \
          2>/dev/null | grep -q "boolean true"; then
        break
      fi
      sleep 1
    done

    ${pkgs.dbus}/bin/dbus-send --session --type=method_call \
      --dest=org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
      string:'
        var target = "applications:firefox.desktop";
        var allPanels = panels();
        for (var i = 0; i < allPanels.length; i++) {
          var widgets = allPanels[i].widgets();
          for (var j = 0; j < widgets.length; j++) {
            var w = widgets[j];
            if (w.type == "org.kde.plasma.taskmanager" || w.type == "org.kde.plasma.icontasks") {
              w.currentConfigGroup = ["General"];
              var current = w.readConfig("launchers", "").toString();
              var list = current.length ? current.split(",") : [];
              if (list.indexOf(target) == -1) {
                list.push(target);
                w.writeConfig("launchers", list.join(","));
              }
            }
          }
        }
      '
  '';
in {
  systemd.user.services.pin-firefox-taskbar = {
    description = "Épingle Firefox dans la barre des tâches Plasma";
    wantedBy = [ "graphical-session.target" ];
    after = [ "plasma-plasmashell.service" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pinScript}";
    };
  };
}
