# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include balabwisit
class balabwisit {

  contain balabwisit::install
  contain balabwisit::config
  contain balabwisit::service
  contain balabwisit::file
  Class['::balabwisit::config']->
  Class['::balabwisit::file']->
  Class['::balabwisit::install']->
  Class['::balabwisit::service']

}
