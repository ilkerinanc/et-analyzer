# encoding: UTF-8
class Analyzer
  @queue = :et_analyze
  def self.perform(data, tweet_type)
    # attr_accessible :amount, :author_id, :category_id, :extra, :in_reply_to_tid, :lat, :location, :long, :permalink, :posted_at, :tid, :value, :what

    if (tweet_type == 1) # If initial request
        request_node = Node.new(
                :author_id => data["entry"]["author_id"],
                :tid => data['entry']['tid'],
                :value => data['entry']['value'],
                :in_reply_to_tid => data['entry']['in_reply_to_tid'],
                :permalink => data['entry']['permalink'],
                :posted_at => data['entry']['posted_at'],
                :what => data['entry']['value'].match(/#ne(.*)#nerede/)[1].strip,
                :status => 0 # Cozum bekliyor
            )

        location = data['entry']['value'].match(/#nerede(.*)#adet/)[1].strip
        if (request_node.value.match(/#ekstra/).present?)
            amount = data['entry']['value'].match(/#adet(.*)#ekstra/)[1].strip
        else
            amount = data['entry']['value'].match(/#adet(.*)$/)[1].strip
        end

        request_node.location = location
        request_node.amount = amount

        if request_node.save
            puts "REQUEST NODE::#{request_node.id}"

            # Reply to the received request via Twitter
            reply = Twitter.update("@#{data['entry']['author_username']} \"#{request_node.what}\" isteginizi aldik. Isteginiz cozulurse bu tweeti #cozuldu hashtagiyle yanitlayin.",{:in_reply_to_status_id => data['entry']['tid']})

            # Assign request's status_to_reply_to attr
            request_node.status_to_reply_to = reply[:id].to_s
            request_node.save

            # Create reply's node
            reply_node = Node.new(
                    :author_id => reply[:user][:id],
                    :tid => reply[:id].to_s,
                    :value => reply[:text],
                    :in_reply_to_tid => request_node.tid,
                    :permalink => "http://www.twitter.com/#{reply.user.screen_name}/statuses/#{reply.id}",
                    :posted_at => reply[:created_at].utc,
                    :parent_id => request_node.id
                )
            if reply_node.save
                puts "SYSTEM REPLY NODE::#{reply_node.id}"
            else
                # TODO
            end
        else
            # TODO
        end
    elsif tweet_type == 2 # If "user's reply" to "system's reply" to "initial request"
        if request_node = Node.where(status_to_reply_to: data['entry']['in_reply_to_tid']).first
            if data['entry']['value'].match(/#cozuldu/)
                request_node.status = 2
                request_node.save
                puts "NODE SOLVED::#{request_node.id}"
            elsif data['entry']['value'].match(/#cozuluyor/)
                request_node.status = 1
                request_node.save
                puts "NODE SOLUTION IN PROGRESS::#{request_node.id}"
            end
        else
        end
    end

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