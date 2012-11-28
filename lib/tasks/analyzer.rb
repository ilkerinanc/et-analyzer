# encoding: UTF-8
class Analyzer
  @queue = :et_analyze
  def self.perform(data)
    # attr_accessible :amount, :author_id, :category_id, :extra, :in_reply_to_tid, :lat, :location, :long, :permalink, :posted_at, :tid, :value, :what

    n = Node.new
    n.author_id = data["entry"]["author_id"]
    n.tid = data['entry']['tid']
    n.value = data['entry']['value']
    n.in_reply_to_tid = data['entry']['in_reply_to_tid']
    n.permalink = data['entry']['permalink']
    n.posted_at = data['entry']['posted_at']

    what = data['entry']['value'].match(/#ne(.*)#nerede/)[1].strip
    location = data['entry']['value'].match(/#nerede(.*)#adet/)[1].strip
    if (n.value.match(/#ekstra/).present?)
        amount = data['entry']['value'].match(/#adet(.*)#ekstra/)[1].strip
    else
        amount = data['entry']['value'].match(/#adet(.*)$/)[1].strip
    end

    n.what = what
    n.location = location
    n.amount = amount
    n.save
    puts "NODE::#{data['entry']['tid']}"

    # parsed_tweet = {
    #    "entry" => {
    #      "author_id" =>entry.user.id,
    #      "tid" => entry.id,
    #      "value" => entry.text,
    #      "in_reply_to_status_id" => entry.in_reply_to_status_id,
    #      "permalink" => "http://www.twitter.com/#{entry.user.screen_name}/statuses/#{entry.id}",
    #      "posted_at" => entry.created_at.utc
    #    }
    #  }
    
  end
end