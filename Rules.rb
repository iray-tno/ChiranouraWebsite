#!/usr/bin/env ruby

# A few helpful tips about the Rules file:
#
# * The string given to #compile and #route are matching patterns for
#   identifiers--not for paths. Therefore, you can’t match on extension.
#
# * The order of rules is important: for each item, only the first matching
#   rule is applied.
#
# * Item identifiers start and end with a slash (e.g. “/about/” for the file
#   “content/about.html”). To select all children, grandchildren, … of an
#   item, use the pattern “/about/*/”; “/about/*” will also select the parent,
#   because “*” matches zero or more characters.
require 'sass'
require 'compass'

Compass.add_configuration "#{File.dirname(__FILE__)}/.compass/config.rb"
sass_options = Compass.sass_engine_options

#preprocess --------------------------------------------------------------------
preprocess do
  puts "preprocess..."
  
  puts ">tweetまとめページの自動生成"
  begin
    source = File.read "tweets.xml" 
    listener = TweetListener.new
    REXML::Parsers::StreamParser.new(source, listener).parse
    listener.items.each {|item|
      @items << item
    }
  rescue
    puts "tweets.xml doesn't exist"
  end
  

  #articles以下にある各ファイルを処理する
  articles = items.select {|item| item.identifier =~ %r|^/articles/.*/|}
  articles.each do |item|
    item.attributes[:kind] ||= "article"
    date = item.identifier.match(/(\d\d\d\d)-(\d\d)-(\d\d)_(\d\d)/).to_a
    item.attributes[:created_at] ||= Time.local(date[1],date[2],date[3],date[4]).to_s
    item.attributes[:category] ||= "Others"
    item.attributes[:tags] ||= [""]
  end

  #tagページの自動生成
  all_tags = items.map { |p| p.attributes[:tags] }.flatten.compact.uniq
  print ">tag and category"
  all_tags.each { |tag|
    item = Nanoc::Item.new("= render('_meta_page', :tag_meta => '#{tag}')",
      {
        :title => "Posts in #{get_tag_name(tag)}",
        :tag_meta => "#{tag}",
        :changefreq => 'weekly',
        :priority => "0.0"
      },
      "/tag/#{get_tag_link(tag.downcase)}",
      :binary => false
    )
    @items << item
    print "."
  }
  print "\n"
  #categoryページとそれ以下のtagページの自動生成
  all_categories = items.map { |item| item.attributes[:category] }.flatten.compact.uniq
  all_categories.each { |category|
    item = Nanoc::Item.new("= render('_meta_page', :category_meta => '#{category}')",
      {
        :title => "Posts in #{category}",
        :category_meta => "#{category}",
        :changefreq => 'weekly',
        :priority => "0.0"
      },
      "/category/#{category.downcase}",
      :binary => false
    )
    @items << item
    puts "  -category page #{category}(#{items_with_category(category).size()}) :#{item.attributes}"

    tags = items_with_category(category).map { |p| p.attributes[:tags] }.flatten.compact.uniq
    tags.each { |tag|
      item = Nanoc::Item.new("= render('_meta_page', :tag_meta => '#{tag}', :category_meta => '#{category}')",
        {
          :title => "Posts in #{get_tag_name(tag)} of #{category}",
          :category_meta => "#{category}",
          :tag_meta => "#{tag}",
          :changefreq => 'weekly',
          :priority => "0.0"
        },
        "/category/#{category.downcase}/tag/#{get_tag_link(tag.downcase)}",
        :binary => false
      )
      @items << item
      print "."
    }
    print "\n"
  }
  print "done"
  items.delete_if { |item| item[:publish] == false }
  puts "preprocess end"
end
#compile -----------------------------------------------------------------------
compile '/stylesheet/' do
  # don’t filter or layout
end

compile '/sitemap/' do
  filter :erb
end

compile '*' do
  if item.binary?
    # don't filter binary items
  else
    case item[:extension]
      when 'md'
        #filter :jp_markdown_filter
        filter :redcarpet, :options => {:fenced_code_blocks => true, :autolink => true},
                           :renderer => ArticleRenderer
        layout 'default'
      when 'haml'
        filter :haml
        layout 'default'
      when 'scss'
        filter :sass, sass_options.merge(:syntax => item[:extension].to_sym)
      else
        filter :haml
        layout 'default'
    end
  end
end

#route -------------------------------------------------------------------------
route '/stylesheet/' do
  '/style.css'
end

route '/sitemap/' do
  '/sitemap.xml'
end

route '*' do
  if item.binary?
    # Write item with identifier /foo/ to /foo.ext
    item.identifier.chop + '.' + item[:extension]
  else
    case item[:extension]
      when 'scss'
        item.identifier.chop + '.css'
      else
        item.identifier + 'index.html'
    end
  end
end


layout '*', :haml, :ugly => true

