hook 'plugin.cart.products' => sub {
  get_stripe_plans;
};
true;
