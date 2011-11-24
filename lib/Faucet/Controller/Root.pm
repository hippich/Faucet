package Faucet::Controller::Root;
use Moose;
use namespace::autoclean;
use Facebook::Graph;

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

    # Check if user already authorized 
    $c->forward('authorization_check');

    # Get captcha form
    $c->forward('captcha_get');

    if ( $c->req->params->{action} eq 'send' && $c->stash->{open} && $c->stash->{authorized} ) {

      my $address = $c->req->params->{address};

      if ( $address eq '' ) {
        $c->stash->{address_error} = 1;
      }

      if ($c->forward('captcha_check')) {
        if (! $c->stash->{address_error}) {

          my $repeat_request = 0;

          # Check if someone with the same IP already requested coins.
          if ( $c->model("DB::Facebook")->search({ ip => $c->req->address })->count > 0 ) {
            $repeat_request = 'ip address';
          }

          # Check if someone with the same coins address already been here.
          if ( $c->model("DB::Facebook")->search({ address => $address })->count > 0 ) {
            $repeat_request = 'coin address';
          }

          $c->log->debug("Repeat request: ". $repeat_request);

          # send coins 
          $c->model('BitcoinServer')->send_to_address(
            $address,
            $c->config->{coin_amount}
          ) unless $repeat_request;

          # Update cache and statistics.
          $c->stash->{success} = 1;
          $c->stash->{open} = 0;
          $c->cache->set('requests', $c->cache->get('requests') + 1);

          # Update user object in DB
          my $user = $c->model('DB::Facebook')->find( $c->user->token );
          $user->update({
            ip      => $c->req->address,
            address => $address,
            time    => time,  
          }); 

          # Post link into user's facebook timeline
          $c->forward('post_facebook_link');
        }
      }
      else {
        $c->stash->{captcha_error} = 1;
      }
    }

    $c->stash->{requests} = $c->cache->get('requests') || 0;
    $c->forward('get_balance');
}

sub authorization_check :Private {
    my ( $self, $c ) = @_;

    $c->stash->{open} = 1;
    $c->stash->{authorized} = 0;

    if ($c->user && $c->user->token) {
      my $fb_user = $c->forward('fetch_facebook_info');

      if ($fb_user) {
        $c->stash->{authorized} = 1;

        if ( my $user = $c->model('DB::Facebook')->find($c->user->token) ) {
          if ( time - $user->time < $c->config->{timeout} ) {
            $c->stash->{open} = 0;
          }
        } 
      }
    }
}


sub post_facebook_link :Private {
    my ($self, $c) = @_;

    my $fb = Facebook::Graph->new;
    $fb->access_token( $c->user->token );

    eval {
      $fb->add_link
         ->set_link_uri( $c->config->{facebook_like_url} )
         ->set_message( $c->config->{facebook_like_message} )
         ->publish; 
    };
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


sub authenticate_facebook :Local {
    my ( $self, $c ) = @_;

    my $user = $c->authenticate({
        scope => ['offline_access', 'publish_stream'],
    }, 'facebook');

    $c->detach unless $user;

    $c->forward('fetch_facebook_info');

    $c->res->redirect( $c->uri_for('/') );
}


sub fetch_facebook_user_object :Private {
    my ( $self, $c ) = @_;

    my $fb = Facebook::Graph->new;
    $fb->access_token( $c->user->token );

    eval {
      return $fb->fetch('me');
    };
}


sub fetch_facebook_info :Private {
    my ( $self, $c ) = @_;
     
    my $fb_user = $c->forward('fetch_facebook_user_object') or return;

    my $db_user = $c->model("DB::Facebook")->find_or_create({
      token => $c->user->token
    });

    $db_user->update({
        username    => $fb_user->{username},
        first_name  => $fb_user->{first_name},
        last_name   => $fb_user->{last_name},
        hometown    => $fb_user->{hometown}->{name},
        hometown_id => $fb_user->{hometown}->{id},
        id          => $fb_user->{id},
        gender      => $fb_user->{gender},
        location    => $fb_user->{location}->{name},
        location_id => $fb_user->{location}->{id},
        link        => $fb_user->{link},
        timezone    => $fb_user->{timezone},
    });

    return $fb_user;
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
