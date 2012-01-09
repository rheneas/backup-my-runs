require 'open-uri'

module BackupMyRuns
  class Activity
    attr_reader :link, :agent

    def initialize(agent, link)
      @agent = agent
      @link = link
    end

    def activity_id
      @link.split("/").last
    end

    def download(dir, dry)
      unless File.exists? dir
        Logger.log("Creating directory #{dir}")
        FileUtils::mkdir_p dir
      end

      Logger.log("Getting link #{@link}")

      activity_page = @agent.get @link
      gpx_link = activity_page.links.select {|link| link.text == "GPX"}

      if gpx_link.empty?
        Logger.log("Could not find GPX link for activity #{activity_id}")
        return false
      end

      file_path = File.join(dir, activity_id + '.gpx')
      does_existing_file_exist = File::exists?(file_path)
      if does_existing_file_exist
        Logger.log("#{file_path} already exists not overwriting")
        return
      end

      Logger.log("#{dry ? "dry run, not " : ""}downloading".capitalize + " #{gpx_link} to #{file_path}")

      unless dry
        page = gpx_link.first.click
        File.open(file_path, 'w') do |file|
          file.write page.body
        end
      end
      return true
    end

    def to_s
      @link
    end
  end
end