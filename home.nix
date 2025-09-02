{ inputs, config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    includes = [{
      contents = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    }];
    userName = "Matt Muldowney";
    userEmail = "matt.muldowney@gmail.com";
  };

  # you should not change this value, eve if you update home manager
  home.stateVersion = "25.05"; # Did you read the comment?
}
