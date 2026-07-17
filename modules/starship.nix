# modules/starship.nix
{ ... }: {

  programs.starship = {
    enable = true;

    settings = {
      # Structure du prompt personnalisé
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        style = "bold blue";
        truncation_length = 4;
      };

      git_branch.style = "bold purple";
      git_status.style = "bold red";

      nix_shell = {
        symbol = "❄️ ";
        style = "bold cyan";
      };
    };
  };
}
