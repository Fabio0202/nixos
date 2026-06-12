{ ... }: {
  # zram-only: compresses inactive pages in RAM (fast, no disk I/O).
  # Disk swapfile dropped: combined with zram it caused kswapd0 thrash.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 75; # allow up to 75% of RAM as compressed swap
  };
}
