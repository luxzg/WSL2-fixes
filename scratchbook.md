# To remember stuff I need sometimes on WSL

### Reinstall Ubuntu distro without download

- wsl --unregister Ubuntu
- wsl.exe --install Ubuntu
- will start new instance:
  - Enter new UNIX username:
  - New password:
  - Retype new password:
  - passwd: password updated successfully
  - Installation successful!

### nmap + GUI

- `apt install nmap`
- `apt install nmapsi4`
- `nmapsi4 &`

Links:

- https://nmap.org/
- https://github.com/nmapsi4/nmapsi4
  - GUI for nmap, works on WSL2

### kdenlive - GUI video editor

- `apt instal kdenlive`

Links:

- https://kdenlive.org/en/

### LAMP on 20.04

- `pt install apache2`
- `apt install mysql-server`
- `mysql_secure_installation`
- `mysql -u root -p`
- `SHOW DATABASES;`
- `apt install php libapache2-mod-php php-mysql`
- `nano /etc/apache2/sites-available/000-default.conf`
- `a2ensite 000-default`
- `systemctl reload apache2`
- `nano /var/www/index.php`
- `<?php phpinfo(); ?>`

Links:

- https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04

### NetworkManager & GUFW - GUI

- GUI frontends for NetworkManager (network settings)
- GUI frontend for UFW (firewall)

Links:

- http://gufw.org/
- https://askubuntu.com/questions/174381/openning-networkmanagers-edit-connections-window-from-terminal
