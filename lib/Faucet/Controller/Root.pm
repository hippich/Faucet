package Faucet::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }
with 'Catalyst::TraitFor::Controller::reCAPTCHA';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Faucet::Controller::Root - Root Controller for Faucet

=head1 DESCRIPTION

Main Faucet controller 

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{open} = 1;
    my $last = $c->cache->get( $c->req->address );

    if ( $last && time - $last < $c->config->{timeout} ) {
      $c->stash->{open} = 0;
    }

    $c->forward('captcha_get');

    if ( $c->req->params->{action} eq 'send' && $c->stash->{open} ) {
      if ( $c->req->params->{address} eq '' ) {
        $c->stash->{address_error} = 1;
      }

      if ($c->forward('captcha_check')) {
        if (! $c->stash->{address_error}) {
          # send coins 
          $c->model('BitcoinServer')->send_to_address(
            $c->req->params->{address},
            $c->config->{coin_amount}
          );

          # Update cache and statistics.
          $c->stash->{success} = 1;
          $c->cache->set( $c->req->address, time );
          $c->stash->{open} = 0;
          $c->cache->set('requests', $c->cache->get('requests') + 1);
        }
      }
      else {
        $c->stash->{captcha_error} = 1;
      }
    }

    $c->stash->{requests} = $c->cache->get('requests') || 0;
    $c->forward('get_balance');
}


sub get_balance :Private {
    my ( $self, $c ) = @_;

    if ( time - $c->cache->get('last_balance_check_time') > 300 ) {
      $c->stash->{balance} = $c->model('BitcoinServer')->get_balance || 0;

      if ($c->stash->{balance} > 0) {
        $c->cache->set('last_balance_check_time', time);
        $c->cache->set('last_balance_check_amount', $c->stash->{balance});
      }
    }
    else {
      $c->stash->{balance} = $c->cache->get('last_balance_check_amount');
    }
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

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

__PACKAGE__->meta->make_immutable;

1;
