# encoding: utf-8

usage 'dostuff'
summary 'open a dostuff on the nanoc environment'
aliases 'console'
description "
Open an IRB dostuff on a context that contains @items, @layouts, @config and @site.
"

module Nanoc::CLI::Commands
  class Shell < ::Nanoc::CLI::CommandRunner
    def run
      @nm = Natto::MeCab.new
      require_site

      p site.items.size

      svd_in_filename = "./svd_tmp/svdinput.txt"
      svd_out_dir = "./svd_tmp/"
      mat_u_ext = ".U"
      rank = 390
      num_ra = 5 #Number of related articles

      item_id = generate_svd_in(svd_in_filename)
      do_svd(svd_in_filename,svd_out_dir,rank)

      svded_items = read_svd_out(svd_out_dir+mat_u_ext)
      generate_related_posts_c(svded_items,item_id,rank,num_ra)
    end

    def generate_related_posts(svded_items,id_list,rank,num_ra,output_filename="./related_posts.txt")
      items_size = svded_items.size
      p items_size
      dist_table = Array.new(items_size){ Array.new(0) }
      items_size.times do |i|
        print "."
        ((items_size-1)-i).times do |j|
          j+=i+1
          dist = calc_dist(svded_items[i],svded_items[j],rank)
          if dist_table[i].size < num_ra then
            dist_table[i].push([j,dist])
            dist_table[i].sort!{|a, b| a[1] <=> b[1] }
          elsif dist < dist_table[i].last[1] then
            dist_table[i][-1] = [j,dist]
            dist_table[i].sort!{|a, b| a[1] <=> b[1] }
          end
          if dist_table[j].size < num_ra then
            dist_table[j].push([i,dist])
            dist_table[j].sort!{|a, b| a[1] <=> b[1] }
          elsif dist < dist_table[j].last[1] then
            dist_table[j][-1] = [i,dist]
            dist_table[j].sort!{|a, b| a[1] <=> b[1] }
          end
        end
      end
      items_size.times do |i|
        num_ra.times do |j|
          dist_table[i][j][0] = id_list[dist_table[i][j][0]]
        end
      end

      rp_str = ""
      items_size.times do |i|
        rp_str+=id_list[i]+"\t"+dist_table[i].inspect+"\n"
      end

      open(output_filename, "w") {|f| f.write rp_str}

    end
    def generate_related_posts_c(svded_items,id_list,rank,num_ra,output_filename="./related_posts.txt")
      items_size = svded_items.size
      p items_size
      cos_table = Array.new(items_size){ Array.new(0) }
      items_size.times do |i|
        print "."
        ((items_size-1)-i).times do |j|
          j+=i+1
          cos = calc_cos(svded_items[i],svded_items[j],rank)
          if cos_table[i].size < num_ra then
            cos_table[i].push([j,cos])
            cos_table[i].sort!{|a, b| b[1] <=> a[1] }
          elsif cos_table[i].last[1] < cos then
            cos_table[i][-1] = [j,cos]
            cos_table[i].sort!{|a, b| b[1] <=> a[1] }
          end
          if cos_table[j].size < num_ra then
            cos_table[j].push([i,cos])
            cos_table[j].sort!{|a, b| b[1] <=> a[1] }
          elsif cos_table[j].last[1] < cos then
            cos_table[j][-1] = [i,cos]
            cos_table[j].sort!{|a, b| b[1] <=> a[1] }
          end
        end
      end
      items_size.times do |i|
        num_ra.times do |j|
          cos_table[i][j][0] = id_list[cos_table[i][j][0]]
        end
      end

      rp_str = ""
      items_size.times do |i|
        rp_str+=id_list[i]+"\t"+cos_table[i].inspect+"\n"
      end

      open(output_filename, "w") {|f| f.write rp_str}

    end

    def calc_dist(l,r,rank)
      ret=0
      rank.times do |i|
        ret+=(l[i]-r[i])*(l[i]-r[i])
      end
      return ret
    end

    def calc_cos(l,r,rank)
      ret=0
      rank.times do |i|
        ret+=l[i]*r[i]
      end
      return ret
    end

    #Read svd results, return results matrix(each row is an article)
    def read_svd_out(svd_out_filename)
      ret=[]
      open(svd_out_filename, "r") { |file|
        file.each_line do |line|
          ret.push(line.split(" ").map(&:to_f))
        end
      }
      return ret
    end

    #Generate svd input_fils, return article_list(rows of each article is id)
    def generate_svd_in(svd_in_filename)
      words_size=0
      words=[]

      article_list = []
      svd_input_str = ""

      #50.times do |i|
      #  item = site.items[i]
      site.items.each do |item|
        if(item[:kind]=="article") then
          article_list.push(item.identifier)
          item_yield = generate_text(item)
          bow = generate_bow(item_yield)
          str=""
          bow.each do |key,value|
            key_index = words.find_index(key)
            if key_index==nil then
              words.push(key)
              key_index=words_size
              words_size+=1
            end
            str+=key_index.to_s+":"+value.to_s+" "
          end
          svd_input_str += str.chomp+"\n"
        end
        #print "."
      end

      svd_input_str.chomp!
      open(svd_in_filename, "w") {|f| f.write svd_input_str}

      return article_list
    end

    #Do svd by redsvd
    def do_svd(input="./svd_tmp/svdinput.txt",output="./svd_tmp/",rank=10)
      system "redsvd --input=#{input} --output=#{output} -r #{rank} -f sparse"
    end

    #Preprocess of an article
    def generate_text(item)
      text = item[:title]+"\n"+
             item[:category]+"\n"+
             item[:tags]*"\n"

      is_inside_code = false
      item.raw_content.each_line do |line|
        if(line[0..2]=="```") then
          is_inside_code=!is_inside_code
        end
        if(!is_inside_code) then
          text+=line
        end
      end
      return text
    end

    #bow表現を生成する
    def generate_bow(text)
      bow=Hash.new(0)
      @nm.parse(text) do |line|
        features = line.feature.split(",") 
        if features[0]=="名詞" and features[1]!="数" then
          bow[line.surface]+=1
        elsif features[0]=="動詞" then
          bow[features[6]]+=1
        end
      end
      return bow
    end

    protected

    def env
      {
        site: site,
        items: site.items,
        layouts: site.layouts,
        config: site.config
      }
    end
  end
end

runner Nanoc::CLI::Commands::Shell
