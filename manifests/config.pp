class balabwisit::config inherits balabwisit {

  user { 'balabwisit':
    ensure  => 'present',
    system  => true,
    shell   => '/sbin/nologin',
  }
  exec { 'cronjob':
    command  => '(/usr/bin/crontab -l; /bin/echo "0 4 * * * /bin/bash /var/log/balabwisit/scripts/mp4.sh") | /usr/bin/crontab -',
    unless   => '/usr/bin/crontab -l | grep "mp4.sh"',
    provider => 'shell',
  }
}
