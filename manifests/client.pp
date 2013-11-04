#
class mysql::client (
  $bindings_enable = $mysql::params::bindings_enable,
  $package_ensure  = $mysql::params::client_package_ensure,
  $package_name    = $mysql::params::client_package_name,
) inherits mysql::params {

  include '::mysql::client::install'

  if $bindings_enable {
    class { 'mysql::bindings':
      java_enable   => true,
      perl_enable   => true,
      php_enable    => true,
      python_enable => true,
      ruby_enable   => true,
    }
  }

  anchor { 'mysql::client::start': }
  anchor { 'mysql::client::end': }

  # Anchor pattern workaround to avoid resources of mysql::client::install 
  # to "float off" outside mysql::client
  Anchor['mysql::client::start'] ->
  Class['mysql::client'] ->
  Class['mysql::client::install'] ->
  Anchor['mysql::client::end']

}
