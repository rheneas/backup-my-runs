require 'hpricot'
require 'open-uri'

module BackupMyRuns
  class User

    attr_reader :activities

    def initialize()
      @activities = []
    end

    def <<(user_activity)
      @activities << user_activity
    end

    def download(dir, dry, limit)
      count = 0
      @activities.each do |activity|
        activity.download(dir, dry)
        count += 1
        if limit && count > limit
          break
        end
      end
    end

    def self.find_by_username(username)
      begin
        user = User.new

        url = "http://runkeeper.com/user/#{username}/activity/"

        doc = Hpricot(open(url))
        elements = doc.search('div.activityMonth')
        elements.each do |element|
          user << Activity.new(element.attributes["link"])
        end
        user
      rescue OpenURI::HTTPError
        raise "#{username} was not found"
      end
    end

    def self.download(username, dir, dry, limit)
      find_by_username(username).download(dir, dry, limit)
    end
  end
end
