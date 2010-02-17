require 'test/unit'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'downloaded_show'

class DownloadedShowTest < Test::Unit::TestCase
  def setup
    @examples = {
      "Bored.to.Death.S01E01.HDTV.XviD-NoTV.avi" => {:show => "Bored to Death", :season => 1, :episode => 1,
                                                     :path => "Bored to Death/Season 1/Bored to Death S01E01.avi"},
      "Bored.to.Death.S1E3.HDTV.se.en.avi" => {:show => "Bored to Death", :episode => 3, :season => 1,
                                               :path => "Bored to"},
      "Heroes.S04E01.Acceptance.HDTV.Xvid-FQM.avi" => {:show => "Heroes", :episode => 1, :season => 4, :name => "Acceptance"},
      "Heroes S04E03 - Orientation - Jump Push Fall.avi" => {:show => "Heroes", :episode => 3, :season => 4, :name => "Orientation - Jump Push Fall"},
      "Caprica.S01E00.Pilot.avi" => {:show => "Caprica", :episode => 0, :season => 1, :name => "Pilot"},
      "Stargate.Universe.S01E03.Air.Part.3.HDTV.XviD-FQM.avi" => {:show => "Stargate Universe", :episode => 3, :season => 1, :name => "Air Part 3"}
    }
  end

  def test_should_ignore_non_tv_shows
    @examples.each do |filename, ignore_this|
      assert DownloadedShow.new(filename).tv_show?
    end
    assert !DownloadedShow.new("Monkeys.DVDRip.avi").tv_show?
  end

  def test_should_construct_output_path

  end

  def test_should_extract_show_name_from_file_name
    @examples.each do |filename, expected|
      assert_equal expected[:show], DownloadedShow.new(filename).show
    end
  end

  def test_should_extract_season
    @examples.each do |filename, expected|
      assert_equal expected[:season], DownloadedShow.new(filename).season
    end
  end

  def test_should_extract_episode
    @examples.each do |filename, expected|
      assert_equal expected[:episode], DownloadedShow.new(filename).episode
    end
  end

  def test_should_extract_name
    @examples.each do |filename, expected|
      assert_equal expected[:name], DownloadedShow.new(filename).name
    end
  end
end