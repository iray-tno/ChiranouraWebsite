# encoding: utf-8

require 'rexml/document'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 
require 'uri'

#tweetが新着順ソート済前提
class TweetListener
  include REXML::StreamListener

  @@items = Array.new

  @isin_tweets = false #最後のtweet記事を生成するために必要
  @isin_tweet = false
  @isin_id = false
  @isin_time = false
  @isin_text = false
  @date_of_lasttweet = nil
  @@buf_tweets = Array.new

  @buf_tweet_id = nil
  @buf_tweet_time = nil
  @buf_tweet_text = nil

  #タグ開始でflagをtrueにする
  def tag_start(name, attrs)
    case name
      when 'id'
        @isin_id = true
      when 'time'
        @isin_time = true
      when 'text'
        @isin_text = true
      when 'tweet'
        @isin_tweet = true
      when 'tweets'
        @isin_tweet = true
      else
    end
  end

  #trueのflagをもつタグでtextを取得
  #isin_timeがtrueのとき　日付が変わったらcreate_tweet_page()
  def text(text)
    if @isin_id == true
      @buf_tweet_id = text
    elsif @isin_time == true
      text =~ /(\d\d\d\d\d\d) (\d\d\d\d\d\d)/#todo 正規表現
      if @date_of_lasttweet == nil
        #最初のtweetをロードした時
        @date_of_lasttweet = $1
      elsif @date_of_lasttweet != $1
        #日付が変わった時
        create_tweet_page(@date_of_lasttweet)
        @@buf_tweets.clear
        @date_of_lasttweet = $1
      else
      end
      @buf_tweet_time = $2
    elsif  @isin_text == true
      @buf_tweet_text = text
      uris = URI.extract(text)
      if !uris.empty?
        uris.each{ |uri| @buf_tweet_text.gsub!(uri,'<'+uri+'>')}
      end
    else
    end
  end

  #タグ終了でflagをfalseにする。tweetのタグ終了でtweetをバッファーに追加する。
  def tag_end(name)
    case name
      when 'id'
        @isin_id = false
      when 'time'
        @isin_time = false
      when 'text'
        @isin_text = false
      when 'tweet'
        @isin_tweet = false
        if !is_reply(@buf_tweet_text)
          @@buf_tweets << {'id' => @buf_tweet_id, 'time' => @buf_tweet_time, 'text' => @buf_tweet_text.tr("\n","")}
        end
      when 'tweets'
        @isin_tweet = false
        create_tweet_page(@date_of_lasttweet)
      else
    end
  end 

  #tweetまとめページ作成
  def create_tweet_page(date)
    if(@@buf_tweets.size != 0)
      d_match = /(\d\d)(\d\d)(\d\d)/.match(date)
      if(@@buf_tweets.size == 1)
        tweet_str = "Tweet"
      else
        tweet_str = "Tweets"
      end
      page_title = "#{@@buf_tweets.size} #{tweet_str} in 20#{d_match[1]}-#{d_match[2]}-#{d_match[3]}"
      page_content = "\n"
      page_identifier = "/articles/20#{d_match[1]}-#{d_match[2]}-#{d_match[3]}_00_tweets"
      @@buf_tweets.each {|tweet|
        t_match = /(\d\d)(\d\d)(\d\d)/.match(tweet['time'])
        page_content << "* (<a href=\"https://twitter.com/iray_tno/status/#{tweet['id']}\" title=\"Tweet\">#{t_match[1]}:#{t_match[2]}:#{t_match[3]}<\/a>) #{tweet['text']}\n"
      }
      item = Nanoc::Item.new(page_content,{
          :title => page_title,
          :author => "iray_tno",
          :category => "SocialActivities",
          :tags => ["tweets_of_20#{d_match[1]}", "20#{d_match[1]}-#{d_match[2]}"],
          :extension => 'md'
        },
        page_identifier,
        :binary => false
      )
      @@items << item
    end
  end

  #reply除外
  def is_reply(text)
    if text[0] == '@'
      return true
    else
      return false
    end
  end

  # encoding, standaloneは、指定がなければnil 
  def xmldecl(version, encoding, standalone) 
    puts "#{version}, #{encoding}, #{standalone}"
  end

  def items
    @@items
  end
end
