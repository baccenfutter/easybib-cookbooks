include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "haproxy::down"
include_recipe "haproxy::ctl"
include_recipe "haproxy::hatop"
include_recipe "haproxy::logs"
include_recipe "nginx-lb"
include_recipe "easybib_deploy::ssl"
