require 'pathname'
require "middleman-core"
require 'ever_mid/ever_exp'
require 'fileutils'

class EverMid < ::Middleman::Extension
  option :my_option, 'default', 'An example option'

  ArchiveDir = 'archive'
  ImagesDir = 'images'

  def initialize(app, options_hash={}, &block)
    super
  end

  def before_build
    preprocess
  end

  def note_entry note
    "<li><a href='/#{ArchiveDir}/#{note.id}.html'>#{note.title}</a></li>"
  end

  expose_to_template :note_entry

  private

  def preprocess
    rebuild_dir
    move_notes
    build_file_with_template '_tags.erb', :tags
    build_file_with_template 'index.html.erb', :index
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

  def build_file_with_template output_file, tmpl_file
    rendered = ERB.new(template tmpl_file).result(binding)
    File.open(under_source(output_file), 'w') do |file|
      file.puts rendered
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
    tmpl_path = File.join(app.root_path, 'source', 'layouts', 'templates', name.to_s) + '.erb'
    File.read tmpl_path
  end
end


Middleman::Extensions.register :ever_mid, EverMid
