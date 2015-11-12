
# Set /etc/hostname;

# Update /etc/hosts, add entry for nas;

# Update /etc/resolv.conf;

# Remove network-manager, network-manager-gnome so they don't smash resolv.conf;

# Update castle fstab - install /mnt/backup, add nfs mounts of the nas;
#   create subdirs- /mnt/nas/backup, ...

# Configure root password;

# Restore root's .ssh directory;

# Restore castle ssh listener on 22022;
  You can also try limiting logins, preventing attacks -

    Add to the bottom of /etc/ssh/sshd_config:
    # XXX Only allow some users;
    AllowUsers root@my-ip-address me nx

    Limit brute force ssh attacks - See:
      * [[http://www.debian-administration.org/articles/187]] and 
      * [[http://www.steveglendinning.com/2008/01/27/protecting-against-ssh-brute-force-password-attacks/]].

    I added this to the end of /etc/rc.local:
     # XXX dpb: configure iptables for ssh connection rate limiting;
    # copied from http://www.steveglendinning.com/2008/01/27/protecting-against-ssh-brute-force-password-attacks/ .

    iptables -t filter --flush  # clears the INPUT chain;
    iptables -X NEW_SSH	    # delete the NEW_SSH chain;

    iptables -N NEW_SSH
    iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j NEW_SSH
    iptables -A NEW_SSH -s XX.YY.ZZ.0/24 -j ACCEPT

    # Rate limiting;
    # iptables -A NEW_SSH -m limit --limit 2/min --limit-burst 2 -j ACCEPT
    # iptables -A NEW_SSH -j DROP

    # Blacklist IP addresses that exceed the rate limit;
    iptables -A NEW_SSH -m recent --set
    iptables -A NEW_SSH -m recent --update --seconds 120 --hitcount 5 -j DROP
    iptables -A NEW_SSH -j ACCEPT

# Restore rsnapshot config/rsnapshot cron (/etc/cron.d/rsnapshot)

# Restore crontab radio recordings;
echo sudo apt-get install streamripper lame mp3info

# Configure printer;

# Configure SqueezeCenter;
  see: http://wiki.slimdevices.com/index.php/DebianPackage
  package name is squeezeboxserver
  I had to turn off the source package, may not be there anymore;

# Configure postfix;

  Set up postfix make castle a satellite system of linode.donbennett.org;

