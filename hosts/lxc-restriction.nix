{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    extraCommands = ''
      # Create custom chain LXC-OUT if it doesn't exist
      iptables -F LXC-OUT 2>/dev/null || iptables -N LXC-OUT
      # Remove existing jump rule to avoid duplicates, then insert it at the top of OUTPUT
      iptables -D OUTPUT -j LXC-OUT 2>/dev/null || true
      iptables -I OUTPUT 1 -j LXC-OUT

      # Flush and populate LXC-OUT
      iptables -F LXC-OUT
      iptables -A LXC-OUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      iptables -A LXC-OUT -o lo -j ACCEPT
      iptables -A LXC-OUT -d 10.0.0.0/8 -j ACCEPT
      iptables -A LXC-OUT -d 172.16.0.0/12 -j ACCEPT
      iptables -A LXC-OUT -d 192.168.0.0/16 -j ACCEPT
      iptables -A LXC-OUT -d 169.254.0.0/16 -j ACCEPT
      iptables -A LXC-OUT -d 224.0.0.0/4 -j ACCEPT
      iptables -A LXC-OUT -d 255.255.255.255/32 -j ACCEPT
      iptables -A LXC-OUT -j REJECT --reject-with icmp-port-unreachable

      # Same for IPv6
      ip6tables -F LXC-OUT 2>/dev/null || ip6tables -N LXC-OUT
      ip6tables -D OUTPUT -j LXC-OUT 2>/dev/null || true
      ip6tables -I OUTPUT 1 -j LXC-OUT

      ip6tables -F LXC-OUT
      ip6tables -A LXC-OUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      ip6tables -A LXC-OUT -o lo -j ACCEPT
      ip6tables -A LXC-OUT -d ::1/128 -j ACCEPT
      ip6tables -A LXC-OUT -d fe80::/10 -j ACCEPT
      ip6tables -A LXC-OUT -d fc00::/7 -j ACCEPT
      ip6tables -A LXC-OUT -d ff00::/8 -j ACCEPT
      ip6tables -A LXC-OUT -j REJECT --reject-with icmp6-port-unreachable
    '';

    extraStopCommands = ''
      iptables -D OUTPUT -j LXC-OUT 2>/dev/null || true
      iptables -F LXC-OUT 2>/dev/null || true
      iptables -X LXC-OUT 2>/dev/null || true

      ip6tables -D OUTPUT -j LXC-OUT 2>/dev/null || true
      ip6tables -F LXC-OUT 2>/dev/null || true
      ip6tables -X LXC-OUT 2>/dev/null || true
    '';
  };
}
