class balabwisit::service inherits balabwisit {

   service { sshd:
    ensure     => running,
    subscribe  => File["/etc/ssh/sshd_config"],
  }
   service { crond:
    ensure    => running,
    subscribe => Exec["cronjob"],
  }
}
