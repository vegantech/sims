module UploadProgress

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:upload_progress => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :upload_progress
  #  recipe :upload_progress
  def upload_progress(options = {})
    package 'apache2-threaded-dev', :ensure => :installed

    exec 'install_upload_progress',
      :cwd => '/tmp',
      :command => [
        'wget http://github.com/drogus/apache-upload-progress-module/raw/eb87ac0b871857202b058563f107c97dc13d68d8/mod_upload_progress.c',
        'apxs2 -cia mod_upload_progress.c'
      ].join(' && '),
      :require => package('apache2-threaded-dev'),
      :before => service('apache2'),
      :creates => '/usr/lib/apache2/modules/mod_upload_progress.so'

      file '/etc/apache2/mods-available/upload_progress.conf',
        :alias => 'upload_progress_conf',
        :content => """
UploadProgressSharedMemorySize #{ options[:shared_memory_size] || '1024000'}
        """,
        :mode => '644',
        :notify => service('apache2')  

    file '/etc/apache2/mods-available/upload_progress.load',
      :alias => 'load_upload_progress',
      :content => 'LoadModule upload_progress_module /usr/lib/apache2/modules/mod_upload_progress.so',
      :mode => '644',
      :require => file('upload_progress_conf'),
      :notify => service('apache2')

   a2enmod 'upload_progress', :require => file('load_upload_progress')
  end
  
end