require 'open-uri'

module BackupMyRuns
  class Activity
    attr_reader :link

    def initialize(link)
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

      url = "http://runkeeper.com/ajax/pointData?activityId=#{activity_id}"
      file_path = File.join(dir, activity_id + '.json')
      does_existing_file_exist = File::exists?(file_path)
      if does_existing_file_exist
        Logger.log("#{file_path} already exists not overwriting")
        return
      end

      Logger.log("#{dry ? "dry run, not " : ""}downloading".capitalize + " #{url} to #{file_path}")

      unless dry
        page = open(url)
        File.open(file_path, 'w') do |file|
          file.write page.read
        end
      end
    end

    def to_s
      @link
    end
  end
end