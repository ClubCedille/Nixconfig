# modules/vscode.nix
{ pkgs, inputs, ... }: {

  # 1. Activation globale de VS Code et de ses extensions système
  programs.vscode = {
    enable = true;
    package = if (inputs ? nixpkgs-unstable) then inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.vscode else pkgs.vscode;

    # Les extensions système s'installent très bien ici de manière native
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      github.vscode-pull-request-github
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      redhat.vscode-yaml
      redhat.ansible
      ms-python.python
      ms-vscode.cpptools
      redhat.java
      jnoortheen.nix-ide
      mkhl.direnv
      ms-vscode-remote.remote-ssh
      ms-vscode.remote-explorer
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
      hediet.vscode-drawio
      jebbs.plantuml
      anthropic.claude-code
      usernamehw.errorlens
    ];
  };

  # 2. Injection globale des paramètres VS Code (settings.json de base)
  # Cela crée un template de configuration global ou écrase de façon propre le fallback XDG.
  environment.etc = {
    "skel/.config/Code/User/settings.json".text = builtins.toJSON {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.sideBar.location" = "right";
      "workbench.startupEditor" = "none";
      "editor.fontFamily" = "'FiraCode Nerd Font', 'monospace'";
      "editor.fontSize" = 12;
      "editor.fontLigatures" = true;
      "editor.fontWeight" = "300";
      "editor.codeLensFontFamily" = "'FiraCode Nerd Font'";
      "editor.inlayHints.fontFamily" = "'FiraCode Nerd Font'";
      "editor.inlineSuggest.fontFamily" = "'FiraCode Nerd Font'";
      "debug.console.fontFamily" = "'FiraCode Nerd Font'";
      "markdown.preview.fontFamily" = "'FiraCode Nerd Font'";
      "scm.inputFontFamily" = "'FiraCode Nerd Font'";
      "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.fontLigatures.enabled" = true;
      "terminal.external.linuxExec" = "ghostty";
      "editor.lineNumbers" = "relative";
      "editor.rulers" = [ 80 120 ];
      "editor.tabSize" = 2;
      "editor.wordWrap" = "off";
      "editor.formatOnSave" = true;
      "editor.renderWhitespace" = "all";
      "editor.suggestSelection" = "first";
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.accessibilitySupport" = "off";
      "editor.largeFileOptimizations" = false;
      "editor.semanticHighlighting.enabled" = true;
      "editor.unicodeHighlight.invisibleCharacters" = false;
      "files.autoSave" = "onFocusChange";
      "files.associations" = {
        "*.yml" = "yaml"; "*.yaml" = "yaml"; "*.j2" = "jinja-cisco"; "*.ios" = "jinja-cisco";
      };
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.openRepositoryInParentFolders" = "never";
      "git.ignoreRebaseWarning" = true;
      "git.replaceTagsWhenPull" = true;
      "nix.enableLanguageServer" = true;
      "C_Cpp.default.cppStandard" = "c++20";
      "C_Cpp.default.cStandard" = "c11";
      "C_Cpp.autocompleteAddParentheses" = true;
      "C_Cpp.clang_format_sortIncludes" = true;
      "C_Cpp.addNodeAddonIncludePaths" = true;
      "[cpp]"."editor.defaultFormatter" = "ms-vscode.cpptools";
      "[c]"."editor.defaultFormatter" = "ms-vscode.cpptools";
      "python.analysis.typeCheckingMode" = "standard";
      "[python]"."editor.formatOnType" = true;
      "[java]"."editor.defaultFormatter" = "redhat.java";
      "[dockercompose]" = {
        "editor.insertSpaces" = true; "editor.tabSize" = 2; "editor.autoIndent" = "advanced";
        "editor.defaultFormatter" = "redhat.vscode-yaml";
        "editor.quickSuggestions" = { "other" = true; "comments" = false; "strings" = true; };
      };
      "[github-actions-workflow]"."editor.defaultFormatter" = "redhat.vscode-yaml";
      "[ansible]" = {
        "editor.tabFocusMode" = false; "editor.detectIndentation" = true; "editor.insertSpaces" = true; "editor.tabSize" = 2; "editor.autoIndent" = "advanced";
        "editor.quickSuggestions" = { "comments" = true; "other" = true; "strings" = true; };
      };
      "[dart]" = {
        "editor.formatOnSave" = true; "editor.formatOnType" = true; "editor.rulers" = [ 80 ]; "editor.selectionHighlight" = false; "editor.suggest.snippetsPreventQuickSuggestions" = false; "editor.suggestSelection" = "first"; "editor.tabCompletion" = "onlySnippets"; "editor.wordBasedSuggestions" = "off";
      };
      "cmake.configureOnOpen" = false; "makefile.configureOnOpen" = false; "explorer.confirmDelete" = false; "explorer.confirmDragAndDrop" = false; "redhat.telemetry.enabled" = false; "security.workspace.trust.untrustedFiles" = "open"; "json.maxItemsComputed" = 20000; "remote.autoForwardPortsSource" = "hybrid"; "remote.SSH.connectTimeout" = 1800; "terminal.integrated.enableMultiLinePasteWarning" = "never"; "terminal.integrated.initialHint" = false; "terminal.integrated.shellIntegration.enabled" = true; "terminal.integrated.defaultProfile.linux" = "bash"; "terminal.integrated.profiles.linux" = { "bash" = { "path" = "bash"; "icon" = "terminal-bash"; }; }; "window.commandCenter" = false; "window.zoomPerWindow" = false; "workbench.editor.empty.hint" = "hidden"; "chat.tips.enabled" = false; "github.copilot.nextEditSuggestions.enabled" = true; "typescript.updateImportsOnFileMove.enabled" = "always"; "liveServer.settings.donotShowInfoMsg" = true; "liveServer.settings.donotVerifyTags" = true; "plantuml.urlFormat" = "png"; "plantuml.diagramsRoot" = "UML"; "hediet.vscode-drawio.theme" = "dark"; "hediet.vscode-drawio.appearance" = "dark"; "markdown.links.openLocation" = "beside"; "markdown-preview-enhanced.previewTheme" = "atom-dark.css"; "vscode-kubernetes.log-viewer.destination" = "Terminal"; "docker.extension.enableComposeLanguageServer" = false;
    };
  };
}
