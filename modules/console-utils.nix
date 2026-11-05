# modules/console-utils.nix
{ pkgs, ... }: {

  # 1. Installation des paquets système indispensables
  environment.systemPackages = with pkgs; [
    micro
    ripgrep
    fd
    bat
    btop
    htop
    tmux
    eza
    
    #Kubernetes
    kubectl
    helm

    # "Nice to have" additionnels pour l'administration et le debug
    curl
    wget
    git
    jq
    ncdu # Analyseur d'espace disque interactif en mode texte
    tldr # Pages d'aide simplifiées avec exemples pratiques
    
  ];

  programs.bash.interactiveShellInit = ''
    # Remplacements modernes avec eza (gère ls, ll, tree)
    alias ls="eza --icons=auto --group-directories-first"
    alias la="eza --icons=auto --group-directories-first -a"
    alias ll="eza --icons=auto --group-directories-first -l --git"
    alias lla="eza --icons=auto --group-directories-first -la --git"
    alias tree="eza --icons=auto --tree"

    # Remplacements avec bat
    alias cat="bat --style=plain --pager=never"
    alias catp="bat"
    alias ccat='/run/current-system/sw/bin/cat'

    # Raccourcis pratiques
    alias grep="rg"
    alias find="fd"
    alias du="ncdu"
    alias df="df -h"
    alias free="free -m"

    # Raccourcis NixOS de survie
    alias nix-switch="sudo nixos-rebuild switch"
    alias nix-gc="sudo nix-env --delete-generations old && sudo nix-store --gc"
  '';

  # 3. Améliorations de l'environnement interactif
  environment.variables = {
    # Force bat comme afficheur par défaut pour les pages de manuel (man)
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # Éditeur par défaut en console
    EDITOR = "micro";
  };

  # 4. Configurations optionnelles des outils installés
  # Activation du démon tmux pour une meilleure persistance des sessions si besoin
  programs.tmux = {
    enable = true;
    clock24 = true;
    # On évite d'ajouter trop de plugins par défaut pour garder le profil ultra-léger et stable
  };
}
