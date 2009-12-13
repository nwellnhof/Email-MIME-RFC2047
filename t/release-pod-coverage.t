#!perl

BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}


use Test::More;

eval "use Test::Pod::Coverage 1.08 tests => 2";
plan skip_all => "Test::Pod::Coverage 1.08 required for testing POD coverage"
  if $@;

eval "use Pod::Coverage::TrustPod";
plan skip_all => "Pod::Coverage::TrustPod required for testing POD coverage"
  if $@;

my $parms = { coverage_class => 'Pod::Coverage::TrustPod' };
pod_coverage_ok("Email::MIME::RFC2047::Encoder");
pod_coverage_ok("Email::MIME::RFC2047::Decoder");
