package Dancer2::Plugin::Cart::Stripe;
use strict;
use warnings;
use Dancer2::Plugin;
use Net::Stripe;

sub BEGIN{
  has 'api_key' => (
    is => 'ro',
    from_config => 1,
    default => sub { '' }
  );  
  plugin_keywords qw/
   get_stripe_plans
  /;
}

sub BUILD {
  my $self = shift;
  my $settings = $self->app->config;
}

sub get_stripe_plans {
  my ($self, $params)  = @_;
  $self->dsl->debug("Getting Stripe Plans");
  $self->dsl->debug("using api key ".$self->api_key);

  my $stripe = Net::Stripe->new(api_key => $self->api_key);
  my $plans = $stripe->get_plans();  

  my $ec_cart = $self->app->session->read("ec_cart");

  $ec_cart->{products} = [ map { { ec_sku => $_->id, ec_price => $_->amount, description => $_->name } } @{ $plans->data } ];

  $self->app->session->write("ec_cart",$ec_cart);
  return $ec_cart->{products};
}

1;
