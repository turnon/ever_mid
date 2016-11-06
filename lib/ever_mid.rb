require 'pathname'
require "middleman-core"
require 'ever_mid/ever_exp'
require 'fileutils'

class EverMid < ::Middleman::Extension
  option :my_option, 'default', 'An example option'

  def initialize(app, options_hash={}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'

    # set up your extension
    # puts options.my_option
  end

  def before_build
    preprocess
  end

  private

  def preprocess
    remove
    copy
  end

  def remove
    all_html_erb = Dir[File.join(source_path, '*.html.erb')]
    FileUtils.rm(all_html_erb)
    all_images = Dir[File.join(source_path, 'images', '*')]
    FileUtils.rm_rf(all_images)
  end

  def copy
    notes = EverExp::Notes.new evernotes_path
    notes.each do |note|
      note.to_midsrc source_path
    end
  end

  def evernotes_path
    under_root 'evernotes'
  end

  def source_path
    under_root 'source'
  end

  def under_root dir_name
    File.join app.root_path, dir_name
  end
end


Middleman::Extensions.register :ever_mid, EverMid
