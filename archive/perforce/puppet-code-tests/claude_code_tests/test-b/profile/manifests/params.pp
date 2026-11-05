# @summary Fallback defaults for profile::motd. Do not declare directly.
class profile::params {
  $packages = [
    'bzip2',
    'update-motd',
    'figlet',
    'lolcat',
    'hddtemp',
  ]

  $chrony_package = 'chrony'
  $chrony_service = 'chronyd'

  $motd_source = 'puppet:///modules/profile/motd'
  $motd_dir    = '/etc/update-motd.d'
  $motd_owner  = 'root'
  $motd_group  = 'root'
  $motd_mode   = '0755'
}
