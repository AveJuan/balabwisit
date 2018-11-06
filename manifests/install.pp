class balabwisit::install inherits balabwisit {
  
  $ffmpeg_package = ['ffmpeg','ffmpeg-devel']

  exec { 'import':
    command  => '/bin/rpm --import /tmp/RPM-GPG-KEY-nux.ro',
    onlyif   => "test ! -e /etc/pki/rpm-gpg/RPM-GPG-KEY-nux.ro",
    path     => '/usr/bin',
  }->
  package { 'ffmpeg-repo':
    source   => "/tmp/nux-dextop-release-0-2.el6.nux.noarch.rpm",
    provider => rpm,
    ensure   => installed,
  }->
  package { $ffmpeg_package:
    ensure   => installed,
    provider => yum,
  }
}
