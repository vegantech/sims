module Xsendfile

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:xsendfile => {:x_send_file_allow_above => 'off'})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :xsendfile
  #  recipe :xsendfile
  def xsendfile(options = {})
    
    package 'apache2-threaded-dev', :ensure => :installed
    
    exec 'install_xsendfile',
      :cwd => '/tmp',
      :command => [
        'wget http://tn123.ath.cx/mod_xsendfile/mod_xsendfile.c',
        'apxs2 -ci mod_xsendfile.c'
      ].join(' && '),
      :require => package('apache2-threaded-dev'),
      :before => service('apache2'),
      :creates => '/usr/lib/apache2/modules/mod_xsendfile.so'
    
      file '/etc/apache2/mods-available/xsendfile.conf',
        :alias => 'xsendfile_conf',
        :content => """
XSendFile #{ options[:x_send_file] || 'on'}
XSendFileAllowAbove #{ options[:x_send_file_allow_above] || 'on'}
#{options[:extra] || ''}
        """,
        :mode => '644',
        :notify => service('apache2')  

    file '/etc/apache2/mods-available/xsendfile.load',
      :alias => 'load_xsendfile',
      :content => 'LoadModule xsendfile_module /usr/lib/apache2/modules/mod_xsendfile.so',
      :mode => '644',
      :require => file('xsendfile_conf'),
      :notify => service('apache2')

   a2enmod 'xsendfile', :require => file('load_xsendfile')

  end
  
end
