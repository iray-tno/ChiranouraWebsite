# encoding: utf-8

module Nanoc::Helpers
  module CategoryAndTag
    require 'nanoc/helpers/html_escape'
    include Nanoc::Helpers::HTMLEscape

    
    #itemのカテゴリーを表示する
    def category_for(item, params={})
      base_url  = params[:base_url]  || '/'
      none_text = params[:none_category] || 'Others'

      if item[:category].nil? or item[:category].empty?
        link_for_category(none_text, base_url)
      else
        link_for_category(item[:category], base_url)
      end
    end

    def tags_for(item, params={})
      base_url  = params[:base_url]  || '/'
      none_text = params[:none_text] || '(none)'
      separator = params[:separator] || ', '

      if item[:tags].nil? or item[:tags].empty?
        none_text
      else
        item[:tags].map { |tag| link_for_tag(tag, base_url) }.join(separator)
      end
    end

    def items_with_tag(tag)
      @items.select { |i| (i[:tags] || []).include?(tag) }
    end

    def items_with_category(category)
      @items.select { |i| (i[:category] == category) }
    end

    def items_with_category_and_tag(category, tag)
      @items.select { |i| ((i[:category] == category) && ((i[:tags] || []).include?(tag))) }
    end

    def link_for_tag(tag, base_url="/", tag_url="tags/")
      %[<a href="#{h base_url}#{h tag_url}#{h get_tag_link(tag)}" rel="tag">#{h get_tag_name(tag)}</a>]
    end

    def link_for_tag_with_category(tag, category, base_url="/", tag_url="tags/", category_url="categories/")
      %[<a href="#{h base_url}#{h category_url}#{h category}/#{h tag_url}#{h get_tag_link(tag)}" rel="tag">#{h get_tag_name(tag)}</a>]
    end

    def link_for_category(category, base_url="/", category_url="categories/")
      %[<a href="#{h base_url}#{h category_url}#{h category}" rel="category">#{h category}</a>]
    end

    def get_tag_name(tag)
      if /.+\(.+\)/ =~ tag
        tag =~ /(.+)\((.+)\)/
        $1
      else
        tag
      end
    end

    def get_tag_link(tag)
      str = nil
      if /.+\(.+\)/ =~ tag
        tag =~ /(.+)\((.+)\)/
        str = $2
      else
        str = tag
      end
      if !(/^[a-zA-Z0-9_-]+$/ =~ str)
        raise "get_tag_link format error #{str}"
      end
      return str
    end

    def count_by_tag(items = nil)
      items = @items if items.nil?
      count_by_tag = Hash.new(0)
      items.each do |item|
        if item[:tags]
          item[:tags].each do |tag|
            count_by_tag[tag] += 1
          end
        end
      end
      count_by_tag
    end

    def count_by_tag_with_category(category)
      items = items_with_category(category)
      count_by_tag = Hash.new(0)
      items.each do |item|
        if item[:tags]
          item[:tags].each do |tag|
            count_by_tag[tag] += 1
          end
        end
      end
      count_by_tag
    end

    def get_categories_except(except = nil)
      items = @items if items.nil?
      if except == nil
        items.map{|item| item[:category]}.compact.uniq.sort
      elsif
        items = items.map{|item| item[:category]}.compact.uniq.sort
        items.delete(except)
        return items
      end
    end
  end
end
