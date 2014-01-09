# encoding: utf-8

module Nanoc::Helpers
  module CategoryAndTag
    require 'nanoc/helpers/html_escape'
    include Nanoc::Helpers::HTMLEscape

    def items_with_tag(tag)
      @items.select { |i| (i[:tags] || []).include?(tag) }
    end

    def items_with_category(category)
      @items.select { |i| (i[:category] == category) }
    end

    def items_with_category_and_tag(category, tag)
      @items.select { |i| ((i[:category] == category) && ((i[:tags] || []).include?(tag))) }
    end

    def link_for_tag(tag, params={})
      category     = params[:category]  || ''
      base_url     = params[:base_url]  || '/'
      tag_url      = params[:tag_url]   || 'tag/'
      category_url = params[:category_url] || 'category/'
      link_text      = params[:link_text]    || ''
      if link_text.empty?
        link_text = get_tag_name(tag)
      end

      if category.empty?
        %[<a href="#{h base_url+tag_url+get_tag_link(tag)}" rel="tag">#{h link_text}</a>]
      else
        %[<a href="#{h base_url}#{h category_url}#{h category.downcase}/#{h tag_url}#{h get_tag_link(tag)}" rel="tag">#{h link_text}</a>]
      end
    end

    def link_for_tag_with_category(tag,category, params={})
      params[:category] = category
      link_for_tag(tag, params )
    end

    def link_for_category(category, params={})
      base_url     = params[:base_url]  || '/'
      category_url = params[:category_url] || 'category/'
      %[<a href="#{h base_url}#{h category_url}#{h category.downcase}" rel="tag">#{h category}</a>]
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
        str = $2.downcase
      else
        str = tag.downcase
      end
      if !(/^[a-z0-9_-]+$/ =~ str)
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

    def get_cate_id(category)
      id_hash = {"General" => "2296926", "SocialActivities" => "2807708", "Science" => "2807705", "Game" => "2807709", "Language" => "2807706", "Art" => "2807707"}
      id_hash.default = "2296926"
      id_hash[category]
    end
  end
end
