# disko/common-single-disk.nix
{
  device ? "/dev/stderr",
  ...
}:
{
  disko.devices = {
    disk = {
      # C'est ce nom "main" que l'argument `--disk main "$TARGET_DISK"` va venir cibler
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
