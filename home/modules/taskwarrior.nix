{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    taskwarrior3
    timewarrior
    taskwarrior-tui
  ];
  # programs.taskwarrior.colorTheme = "solarized-dark-256";

  # home.file.".taskrc" = ./configfiles/taskrc;

  # programs.taskwarrior = {
  # enable = true;

  # config = {
  #   # Enable UDA for 'planned'
  #   uda.planned.type = "string";
  #   uda.planned.label = "Planned";
  #   uda.planned.values = "tod,tw,tm";
  #   uda.planned.default = "tod"; # Optional default value
  #
  #   # Optional urgency coefficient for 'planned' attribute
  #   urgency.uda.planned.coefficient = 1.5;
  #
  #   # Custom report to show tasks with 'planned' UDA
  #   report.planned.columns = ["id" "description" "planned" "due" "priority" "project"];
  #   report.planned.labels = ["ID" "Description" "Planned" "Due" "Priority" "Project"];
  #   context.work = "status:pending +work";
  #   context.home = "status:pending +home";
  #
  #   # Set a default context (optional)
  #   context.default = "work";
  #
  #   # Optional: Define reports for clarity
  #   report.work.filter = "status:pending +work";
  #   report.work.columns = ["id" "description" "project" "due" "priority"];
  #   report.work.labels = ["ID" "Description" "Project" "Due" "Priority"];
  #
  #   report.home.filter = "status:pending +home";
  #   report.home.columns = ["id" "description" "project" "due" "priority"];
  #   report.home.labels = ["ID" "Description" "Project" "Due" "Priority"];
  # };
  # };
}
