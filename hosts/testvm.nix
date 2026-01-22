{
  imports = [ ../desktop ];

  users.users.meow =
    { isNormalUser    = true;
      initialPassword = "meow";
    };

  virtualisation.vmVariant.virtualisation =
    { memorySize = 4096;
      cores      = 4;
    };
}
