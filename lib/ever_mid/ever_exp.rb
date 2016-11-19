require 'fileutils'
require 'yaml'
require 'digest/sha1'
require 'toc_list'

module EverExp
  class Note
    def to_midsrc src_path
      files.to_midsrc src_path
      html.to_midsrc src_path
    end

    def id
      html.id
    end

    def date
      html.formated_date
    end
  end

  class Files
    def to_midsrc src_path
      new_location = new_dir src_path
      FileUtils.mkdir new_location
      each do |file|
        FileUtils.cp file.location, new_location
      end
    end

    def id
      note.id
    end

    def new_dir src_path
      File.join src_path, EverMid::ImagesDir, id
    end
  end

  class WithoutFiles
    def to_midsrc src_path
    end
  end

  class Html
    def to_midsrc src_path
      refresh_imgs
      replace_code_blocks
      set_toc_ref
      File.open(new_location(src_path), 'w') do |file|
        file.puts src_content
      end
    end

    def id
      @id ||= Digest::SHA1.hexdigest(title)[0..5]
    end

    def formated_date
      created.strftime '%d %b %Y'
    end

    private

    def page_var
      {'title' => title, 'date' => formated_date, 'heading' => heading}.to_yaml
    end

    def new_location src_path
      File.join src_path, EverMid::ArchiveDir, new_file_name
    end

    def new_file_name
      id + '.html.erb'
    end

    def src_content
      [page_var, "---\n", content, table_of_content].join
    end

    def refresh_imgs
      imgs.each do |img|
        org_src_path = img['src']
        new_src_path = File.join('/' + EverMid::ImagesDir, id, File.basename(org_src_path))
        img['src'] = new_src_path
      end
    end

    def replace_code_blocks
      code_blocks.each do |org_block|
        new_block = [
          '<div class="ever-code"><pre><code>',
          org_block.plain_code,
          '</code></pre></div>'
        ].join
        org_block.add_next_sibling new_block
        org_block.remove
      end
    end

    def table_of_content
      return unless heading?
      toc = {'table of content' => heading}
      TocList.new(toc).render
    end

    def set_toc_ref
      heading_elements.each do |e|
	e['id'] = TocList::HashMethod.call e.text
      end
    end
  end
end
