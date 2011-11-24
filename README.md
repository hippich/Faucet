### Installation

    $ git clone https://github.com/hippich/Faucet.git
    $ cd Faucet
    $ git submodule init 
    $ git submodule update
    $ perl Makefile.PL
    $ make installdeps

### Configuration

Copy supplied sample config file faucet_sample.conf to 
faucet.conf and edit it. Make sure to include correct
login/password to bitcoind, keys for reCaptcha and AddThis.

### Run development server

Install Catalyst::Devel and run script/faucet_server.pl to test 
the application.

    cpanm Catalyst::Devel
    FAUCET_DEBUG=1 ./script/faucet_server.pl -r

### Deployment under Apache

Enable FastCGI module:

    a2enmod fastcgi 

In /etc/apache2/sites-available/faucet.conf:

    FastCgiServer /home/faucet/Faucet/faucet_fastcgi.pl -processes 2
    
    <VirtualHost *:80>
      ServerName faucet.example.com
      DocumentRoot  /home/faucet/Faucet/root
      Alias /static /home/faucet/Faucet/root/static
      Alias / /home/faucet/Faucet/script/faucet_fastcgi.pl/
    </VirtualHost>

Enable newly created virtual host config:

    a2ensite faucet.conf 

Restart Apache:

    /etc/init.d/apache2 restart 

### Installation notes

 - Catalyst::TraitFor::Controller::reCAPTCHA

   For me it failed on one of tests so I had to force install it via:
   
    $ cpan -f Catalyst::TraitFor::Controller::reCAPTCHA


### Submitting patches

This is very early code release and I expect to have some bugs and/or 
missing essential features. Please fork project on GitHub, fix issue 
and submit pull request back to merge into main tree.
