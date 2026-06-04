{
  ranges = {
    infra = "192.168.1.0-9";
    compute = "192.168.1.10-19";
    storage = "192.168.1.20-29";
    service = "192.168.1.30-100";
  };

  hosts = {
    dar-es-salaam = {
      ip = "192.168.1.30";
      prefixLength = 24;
      gateway = "192.168.1.1";
      interface = "eth0";
    };
    accra = {
      ip = "192.168.1.40";
      prefixLength = 24;
      gateway = "192.168.1.1";
      interface = "eth0";
    };
    dallas = {
      ip = "192.168.1.64";
      prefixLength = 24;
      gateway = "192.168.1.1";
      interface = "eth0";
    };
  };
}
