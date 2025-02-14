{ config, pkgs, system, inputs, ... }:
{ programs.home-manager.enable = true;

	home.username = "fahd";
	home.homeDirectory = "/home/fahd";

	home.packages = [ pkgs.fzf inputs.zen-browser.packages."${system}".default ];

	home.sessionVariables = {
		EDITOR = "vscode";
		VISUAL = "vscode";
		BROWSER = "zen";
	};


	#####################################
	# My Programs
	#####################################
	programs.git = {
		enable = true;
		userName = "fahdfady";
		userEmail = "fahd.fady212@gmail.com";
		extraConfig = {
			init.defaultBranch = "main";
		};
	}; 

	home.stateVersion = "24.05";
}