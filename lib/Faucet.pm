package Faucet;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Cache
    Authentication
    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.02';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in faucet.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Faucet',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

Faucet - Catalyst based application

=head1 SYNOPSIS

    script/faucet_server.pl

=head1 DESCRIPTION

Main Faucet module.

=head1 SEE ALSO

L<Faucet::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Pavel Karoukin <pavel@karoukin.us>

=head1 LICENSE

Copyright (C) 2011 Pavel A. Karoukin <pavel@karoukin.us>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut

1;
