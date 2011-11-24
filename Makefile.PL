#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Faucet';
all_from 'lib/Faucet.pm';

requires 'Catalyst::Runtime' => '5.80024';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Catalyst::Model::Bitcoin';
requires 'Catalyst::Plugin::Cache';
requires 'Cache::FastMmap';
requires 'Catalyst::TraitFor::Controller::reCAPTCHA';
requires 'Catalyst::Authentication::Credential::Facebook::OAuth2';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::View::TT';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Model::DBIC::Schema';
requires 'MooseX::NonMoose' => '0.16';
requires 'MooseX::MarkAsMethods' => '0.13';

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
