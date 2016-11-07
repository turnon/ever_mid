require 'pathname'
require "middleman-core"
require 'ever_mid/ever_exp'
require 'fileutils'

class EverMid < ::Middleman::Extension
  option :my_option, 'default', 'An example option'

  ArchiveDir = 'archive'
  ImagesDir = 'images'

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
    rebuild_dir
    move_notes
    build_tags_page
  end

  def rebuild_dir
    [ArchiveDir, ImagesDir].each do |dir|
      full_path = File.join source_path, dir
      FileUtils.rm_rf full_path
      FileUtils.mkdir full_path
    end
  end

  def move_notes
    notes.each do |note|
      note.to_midsrc source_path
    end
  end

  def build_tags_page
    group_by_tag = notes.group_by_tag
    rendered_tags = ERB.new(template :tags).result(binding)
    File.open(under_source('_tags.erb'), 'w') do |file|
      file.puts rendered_tags
    end
  end

  def notes
    @notes ||= EverExp::Notes.new evernotes_path
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

  def under_source filename
    File.join source_path, filename
  end

  def template name
    tmpl_path = File.join(app.root_path, 'source', 'layouts', name.to_s) + '.erb'
    File.read tmpl_path
  end
end


Middleman::Extensions.register :ever_mid, EverMid
