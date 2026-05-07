{config, ...}: {
  programs.newsboat = {
    enable = true;

    urls = [
      {url = "https://nixos.org/feeds/nixos-news.xml";}
      {url = "https://hnrss.org/frontpage";}
      {url = "https://lobste.rs/rss";}
      {url = "https://news.ycombinator.com/rss";}
      {url = "https://arstechnica.com/feed";}
      {url = "https://www.phoronix.com/rss.php";}
    ];

    extraConfig = ''
      # browser
      browser = ${config.home.sessionVariables.BROWSER}

      # refresh
      reload-time = 60
      max-items = 200

      # UI
      show-read-feeds = no
      show-read-articles = no
      feedlist-title-format = "Newsboat - %N feeds (%u unread)"
      articlelist-title-format = "%N %V - %?T?%T & ?%%?n (%u unread)"
      article-title-format = "%T (%u unread)"

      # colors (gruvbox-ish light)
      color background        default   default
      color listnormal         color8    default
      color listnormal_unread  color10   default
      color listfocus          color15   color4
      color listfocus_unread   color15   color10
      color info               color0    color14
      color article            color0    default
    '';
  };
}
