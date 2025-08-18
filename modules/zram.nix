{inputs, pkgs, ...}:

{
  zramSwap = {
    enable = true;
    memoryMax = 4 * 1024 * 1024 * 1024; # 4 GiB
  };
}
