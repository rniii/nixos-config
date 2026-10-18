{
    imports = [
        ../compute
    ];

    networking.hostName = "idk";

    services.openssh.ports = [ 2200 ];
}
