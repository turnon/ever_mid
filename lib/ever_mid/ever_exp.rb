require 'fileutils'
require 'yaml'
require 'digest/sha1'

module EverExp
  class Note
    def to_midsrc src_path
      files.to_midsrc src_path
      html.to_midsrc src_path
    end

    def id
      html.id
    end
  end

  class Files
    def to_midsrc src_path
      img_dir = new_dir src_path
      Dir.mkdir img_dir
      each do |file|
        FileUtils.cp file.location, img_dir
      end
    end

    def id
      note.id
    end

    def new_dir src_path
      File.join src_path, 'images', id
    end
  end

  class WithoutFiles
    def to_midsrc src_path
    end
  end

  class Html
    def to_midsrc src_path
      refresh_imgs
      File.open(File.join(src_path, new_file_name), 'w') do |file|
        file.puts src_content
      end
    end

    def id
      @id ||= Digest::SHA1.hexdigest(title)[0..5]
    end

    private

    def page_var
      {'title' => title, 'heading' => heading}.to_yaml
    end

    def new_file_name
      id + '.html.erb'
    end

    def src_content
      [page_var, "---\n", content].join
    end

    def refresh_imgs
      imgs.each do |img|
        org_src_path = img['src']
        new_src_path = File.join 'images', id, File.basename(org_src_path)
        img['src'] = new_src_path
      end
    end
  end
end
