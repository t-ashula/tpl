package Canonical;

use strict;
use warnings;
use utf8;

use LWP::UserAgent;
use LWP::Protocol::http;
use LWP::Protocol::https;
use URI;
use Carp qw{};
use Data::Dumper;

our $VERSION = '0.01';
our $AGENT = Canonical::_agent();

my $crawler;

sub new {
  my $pkg = shift;
  my %args = @_ == 1 ? %{ $_[0] } : @_;
  $AGENT = $pkg->_agent;
  bless { %args }, $pkg;
}

sub canonical {
  my $class = shift;

  if ( @_ == 0 ) {
    die 'no arguments error';
  }

  my %args = @_ == 1 ? ( url => $_[0] ) : @_;
  my $url = $args{ url };
  if ( !defined $url ) {
    die 'no url found'; 
  }

  my $u = URI->new( $url );
  if ( $u->scheme !~ m/https?/ ) {
    die 'not supported scheme';
  }
  return $class->_resolve_remote( $url );
}

sub agent {
  my $class = shift;
  @_ > 0 ? $AGENT = $_[ 0 ] : $AGENT;
}

sub _agent {
  return 'CanonicalURI Crawler/'. $VERSION . ' (http://ashula.info/drops/canonical)';
}

sub _ua {
  my $class = shift;
  if ( !defined $crawler ) {
    $crawler = LWP::UserAgent->new;
    push @{ $crawler->requests_redirectable }, 'POST';
    $crawler->max_redirect( 0 );
  }
  return $crawler;
}

sub _resolve_remote {
  my $class = shift;
  my $url = shift;
  my $cu = $url;
  my $ua = $class->_ua;
  my @rurls = ({ code => 0, url => $url });
  my $res = $ua->request( HTTP::Request->new( GET => URI->new( $url ) ) );
  while ( $res->is_redirect ) {
    my $rurl = $res->header( 'Location' );
    unshift @rurls, { code => $res->code, url => $rurl };
    $res = $ua->request( HTTP::Request->new( GET => URI->new( $rurl ) ) );
  }
  #warn Dumper reverse @rurls;
  for my $rurl ( @rurls ) {
    if ( $rurl->{ code } != 302 ) {
      return $rurl->{ url };
    }
  }
  return $rurls[ -1 ]{ url }; # return original url
}

1;
__END__

=head1 NAME

Canonical -

=head1 SYNOPSIS

  use Canonical;
  my $c = Canonical->new;
  $c->canonical( 'http://goo.gl/e' ); # -> 'http://www.google.com/'
 
  $c->canonical( { url => 'http://goo.gl/e', 

=head1 DESCRIPTION

Canonical is

=head1 AUTHOR

t.ashula E<lt>office@ashula.infoE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
