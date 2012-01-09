require 'hpricot'
require 'mechanize'

module BackupMyRuns
  class User

    LOGIN_URL= 'https://runkeeper.com/login'

    attr_reader :activities, :agent

    def initialize(username, password)
      @activities = []
      @agent = Mechanize.new
      login_page = @agent.get LOGIN_URL
      login_page.form.email = username
      login_page.form.password = password
      logged_in_page = login_page.form.submit

      activity_links = logged_in_page.links.select { |link| link.text == "Activities" }
      if activity_links.empty?
        raise 'Activity links are empty'
      end

      activity_page = activity_links.first.click
      create_activities(activity_page)
    end

    def create_activities(activity_page)
      doc = Hpricot(activity_page.body)
      elements = doc.search('div.activityMonth')
      elements.each do |element|
        @activities << Activity.new(@agent, "https://runkeeper.com#{element.attributes['link']}")
      end
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

    def self.download(username, password, dir, dry, limit)
      User.new(username, password).download(dir, dry, limit)
    end
  end
end
