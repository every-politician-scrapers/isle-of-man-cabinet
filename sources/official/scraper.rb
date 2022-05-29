#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full: noko.last.xpath('text()').first.text.tidy,
        prefixes: %w[Hon Dr],
        suffixes: %w[MHK CBE MBE],
      ).short
    end

    def position
      noko.first.text
    end
  end

  class Members
    def member_container
      # Members aren't separated, but each has 3 <p> sections in a row
      noko.css('.main-content p').each_slice(3)
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
