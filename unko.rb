# encoding: utf-8

require 'rexml/document'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

#tweetが新着順ソート済前提
class TweetListener
  include REXML::StreamListener
  @flag_tweets = false #最後のtweet記事を生成するために必要
  @flag_tweet = false
  @flag_id = false
  @flag_time = false
  @flag_text = false
  @buf_date = nil
  @@buf_tweets = Array.new

  @buf_tweet_id = nil
  @buf_tweet_time = nil
  @buf_tweet_text = nil

  #タグ開始でflagをtrueにする
  def tag_start(name, attrs)
    case name
      when 'id'
        @flag_id = true
      when 'time'
        @flag_time = true
      when 'text'
        @flag_text = true
      when 'tweet'
        @flag_tweet = true
      when 'tweets'
        @flag_tweet = true
      else
    end
  end

  #trueのflagをもつタグでtextを取得
  #flag_timeがtrueのとき　日付が変わったらcreate_tweet_page()
  def text(text)
    if @flag_id == true
      @buf_tweet_id = text
    elsif @flag_time == true
      text =~ /(\d\d\d\d\d\d) (\d\d\d\d\d\d)/#todo 正規表現
      if @buf_date == nil
        #最初のtweetをロードした時
        @buf_date = $1
      elsif @buf_date != $1
        #日付が変わった時
        create_tweet_page()
        @@buf_tweets.clear
        @buf_date = $1
      else
      end
      @buf_tweet_time = $2
    elsif  @flag_text == true
      @buf_tweet_text = text
    else
    end
  end

  #タグ終了でflagをfalseにする。tweetのタグ終了でtweetをバッファーに追加する。
  def tag_end(name)
    case name
      when 'id'
        @flag_id = false
      when 'time'
        @flag_time = false
      when 'text'
        @flag_text = false
      when 'tweet'
        @flag_tweet = false
        if !check_reply(@buf_tweet_text)
          @@buf_tweets << {'id' => @buf_tweet_id, 'time' => @buf_tweet_time, 'text' => @buf_tweet_text}
        end
      when 'tweets'
        @flag_tweet = false
        create_tweet_page()
      else
    end
  end 

  #tweetまとめページ作成
  def create_tweet_page()
    if(@@buf_tweets.size != 0)
      p "#{@buf_date} (#{@@buf_tweets.size})"
      @@buf_tweets.each {|tweet| p "  *#{tweet['id']}(#{tweet['time']}) :#{tweet['text']}" }
    end
  end

  #reply除外
  def check_reply(text)
    #TODO
    true
  end

  # encoding, standaloneは、指定がなければnil 
  def xmldecl(version, encoding, standalone) 
    p version, encoding, standalone 
  end

end 
 
source = File.read "tweets.xml" 
listener = TweetListener.new
REXML::Parsers::StreamParser.new(source, listener).parse
