require 'fileutils'
require 'itunes_wrapper'

class DownloadedShow
  attr_reader :filename, :show, :episode, :season, :name
  def initialize(filename)
    @filename = filename
    extract_details
  end

  def output_path(root="")
    File.join(root, show, "Season #{season}", output_filename)
  end

  def output_filename
    out = "#{show} S#{padded(season)}E#{padded(episode)}"
    out += " - #{name}" if name
    out += ".avi"
    out
  end

  def tv_show?
    @season && @episode
  end

  def import_to_itunes(movie_folder, itunes_add_folder)
    if tv_show?
      puts "Moving #{filename} to #{show.output_path}"
      sorted_show = output_path(movie_folder)
      FileUtils.mkdir_p(File.dirname(sorted_show))
      FileUtils.mv(filename, sorted_show)

      ITunesWrapper.new(sorted_show).import(itunes_add_folder)
    end
  end

  private

  def extract_details
    separator_character = filename.match(/(.)S\d/)[1]
    bits = File.basename(filename, ".avi").split(separator_character)
    season_and_episode = bits.find { |x| x =~ /S\d/ }
    season_and_episode_index = bits.index(season_and_episode)
    @show = bits[0, season_and_episode_index].join(" ")
    m = season_and_episode.match(/(\d+)\w(\d+)/)
    @season = m[1].to_i
    @episode = m[2].to_i
    if bits.index("HDTV")
      @name = bits[(season_and_episode_index+1)...bits.index("HDTV")].join(" ")
    else
      name_bits = bits[(season_and_episode_index+1)..-1]
      name_bits.shift unless name_bits.first =~ /\w/
      @name = name_bits.join(" ")
    end
    @name = nil if @name == ""
  rescue
    nil
  end

  def padded(value)
    value.to_s.rjust(2, "0")
  end
end