class balabwisit::file inherits balabwisit {
  
  file { '/var/log/balabwisit':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/pid':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/time':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/video':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/recordFile':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/session':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/scripts':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/key':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/log':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
   file { '/var/log/balabwisit/video/mp4':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/balabwisit/video/gif':
    ensure  => directory,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }->
  file { '/var/log/secure':
    ensure  => file,
    group   => 'balabwisit',
    mode    => '0660',
  }->
   file { '/etc/profile.d/script.sh':
    ensure  => file,
    source  => 'puppet:///modules/balabwisit/script.sh',
    mode    => '1750',
  }->
  file { '/var/log/balabwisit/scripts/mp4.sh':
    ensure  => file,
    source  => 'puppet:///modules/balabwisit/mp4.sh',
    mode    => '0755',
  }->
  file { '/var/log/balabwisit/scripts/convert.py':
    ensure  => file,
    source  => 'puppet:///modules/balabwisit/convert.py',
    mode    => '0755',
  }->
  file { '/var/log/balabwisit/scripts/howto.txt':
    ensure  => file,
    source  => 'puppet:///modules/balabwisit/howto.txt',
    mode    => '644',
  }->
  exec { 'movesshd':
    command => "/bin/mv -i /etc/ssh/sshd_config /etc/ssh/sshd_config.default",
    onlyif  => "test ! -e /etc/ssh/sshd_config.default",
    path    => '/usr/bin',
  }->
  file { '/etc/ssh/sshd_config':
    ensure  => file,
    source  => 'puppet:///modules/balabwisit/sshd_config',
    notify  => Service["sshd"]
  }->
  file { 'congif':
    path    => '/var/log/balabwisit/video/congif',
    source  => 'puppet:///modules/balabwisit/congif-master',
    recurse => true,
    owner   => 'root',
    group   => 'balabwisit',
    mode    => '0774',
  }
  file { '/tmp/nux-dextop-release-0-2.el6.nux.noarch.rpm':
    source  => 'puppet:///modules/balabwisit/nux-dextop-release-0-2.el6.nux.noarch.rpm',
    ensure  => file,
  }->
  file { '/tmp/RPM-GPG-KEY-nux.ro':
    source  => 'puppet:///modules/balabwisit/RPM-GPG-KEY-nux.ro',
    ensure  => file,
  }

}



