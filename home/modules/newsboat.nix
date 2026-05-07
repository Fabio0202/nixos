{...}: {
  programs.newsboat = {
    enable = true;

    urls = [
      # Linux / Hyprland / Ricing
      {url = "https://www.phoronix.com/rss.php";}
      {url = "https://discourse.nixos.org/latest.rss";}
      {url = "https://www.reddit.com/r/hyprland/.rss";}
      {url = "https://www.reddit.com/r/unixporn/.rss";}
      {url = "https://lobste.rs/rss";}
      {url = "https://hnrss.org/frontpage";}

      # Gaming
      {url = "https://www.gamingonlinux.com/article.rss";}
      {url = "https://www.pcgamer.com/rss/";}
      {url = "https://www.reddit.com/r/linux_gaming/.rss";}
      {url = "https://www.gamespot.com/feeds/news/";}
      {url = "https://www.rockpapershotgun.com/feed";}

      # Music production
      {url = "https://cdm.link/feed/";}
      {url = "https://www.synthtopia.com/feed/";}
      {url = "https://www.musicradar.com/rss";}

      # Switzerland
      {url = "https://www.swissinfo.ch/eng/rss";}
      {url = "https://www.nzz.ch/feed";}

      # Backend / Programming
      {url = "https://stackoverflow.blog/feed/";}
      {url = "https://martinfowler.com/feed.atom";}
      {url = "https://hacks.mozilla.org/feed/";}
      {url = "https://blog.mozilla.org/feed/";}

      # Finance
      {url = "https://feeds.bloomberg.com/markets/news.rss";}

      # Tech / General
      {url = "https://news.ycombinator.com/rss";}
      {url = "https://arstechnica.com/feed";}
      {url = "https://nixos.org/feeds/nixos-news.xml";}
    ];

    extraConfig = ''
      # browser
      browser xdg-open

      # refresh
      reload-time 60
      max-items 200

      # UI
      show-read-feeds no
      show-read-articles no
      feedlist-title-format "Newsboat - %N feeds (%u unread)"
      articlelist-title-format "%N %V - %?T?%T & ?%%?n (%u unread)"

      # catppuccin mocha (xterm 256-color)
      color background        color234  color234
      color listnormal         color252  color234
      color listnormal_unread  color223  color234
      color listfocus          color234  color67
      color listfocus_unread   color234  color73
      color info               color223  color236
      color article            color252  color234
    '';
  };
}
