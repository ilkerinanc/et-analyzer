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

        if request_node.value.include?("#akut")
            request_node.category_id = 1
        elsif request_node.value.include?("#materyal")
            request_node.category_id = 2
        elsif request_node.value.include?("#kan")
            request_node.category_id = 3
        elsif request_node.value.include?("#gonullu")
            request_node.category_id = 4
        elsif request_node.value.include?("#bilgi")
            request_node.category_id = 5
        end

        if (request_node.value.match(/#adet/).present? and request_node.value.match(/#ekstra/).present?)
            request_node.location = data['entry']['value'].match(/#nerede(.*)#adet/)[1].strip
            request_node.amount = data['entry']['value'].match(/#adet(.*)#ekstra/)[1].strip
            request_node.extra = data['entry']['value'].match(/#ekstra(.*)/)[1].strip
        elsif (request_node.value.match(/#adet/).present? and !request_node.value.match(/#ekstra/).present?)
            request_node.location = data['entry']['value'].match(/#nerede(.*)#adet/)[1].strip
            request_node.amount = data['entry']['value'].match(/#adet(.*)/)[1].strip
        elsif (!request_node.value.match(/#adet/).present? and request_node.value.match(/#ekstra/).present?)
            request_node.location = data['entry']['value'].match(/#nerede(.*)#ekstra/)[1].strip
            request_node.extra = data['entry']['value'].match(/#ekstra(.*)/)[1].strip
        elsif (!request_node.value.match(/#adet/).present? and !request_node.value.match(/#ekstra/).present?)
            request_node.location = data['entry']['value'].match(/#nerede(.*)/)[1].strip
        end
        
        # request_node.location = "#{location}, istanbul"
        # request_node.amount = amount if amount.exists?
        # request_node.extra = extra if extra.exists?

        if request_node.save
            puts "REQUEST NODE::#{request_node.id}"

            begin
                # Reply to the received request via Twitter
                reply = Twitter.update("@#{data['entry']['author_username']} \"#{request_node.what}\" isteginizi aldik. Isteginiz cozulurse bu tweeti #cozuldu hashtagiyle yanitlayin. ID:#{request_node.id}",{:in_reply_to_status_id => data['entry']['tid']})

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
                    puts "WARNING: SYSTEM REPLY TO NODE::#{reply_node.id} FAILED TO SAVE!"
                end
            rescue
                puts "WARNING: ERROR TWEETING REPLY TO NODE::#{reply_node.id}!"
            end
        else
            puts "WARNING: REQUEST WITH TID #{data['entry']['tid']} COULD NOT BE SAVED "
        end
    elsif tweet_type == 2 # If "user's reply" to "system's reply" to "initial request"
        if request_node = Node.where(status_to_reply_to: data['entry']['in_reply_to_tid']).first
            if data['entry']['value'].include?('#cozuldu') and data['entry']['value'].include?('#adet')
                amount = data['entry']['value'].match(/#adet\s((.*\s)|(.*\z))/)[1].strip
                request_node.status = 1 # make it 'cozuluyor'
                puts "======== #{amount.to_i}"
                request_node.amount = request_node.amount - amount.to_i
                puts "NODE SOLUTION IN PROGRESS::#{request_node.id} WITH AMOUNT #{request_node.amount}"
                if request_node.amount < 1
                    request_node.status = 2 # cozuldu
                    puts "NODE SOLVED::#{request_node.id} WITH AMOUNT"
                end
            elsif data['entry']['value'].include?('#cozuldu')
                request_node.status = 2
                puts "NODE SOLVED::#{request_node.id}"
            elsif data['entry']['value'].match(/#cozuluyor/)
                request_node.status = 1
                puts "NODE SOLUTION IN PROGRESS::#{request_node.id}"
            end
            request_node.save
        else
        end
    end
  end
end