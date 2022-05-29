#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      Name.new(
        full: name_node.css('text()').first.text.tidy,
        prefixes: %w[Hon Dr],
        suffixes: %w[MHK CBE MBE],
      ).short
    end

    def position
      noko.text.tidy
    end

    # Name is in next non-empty <p> after the <h2>
    def name_node
      noko.xpath('following-sibling::p').find { |node| !node.text.tidy.empty? }
    end
  end

  class Members
    def member_container
      noko.css('.main-content h2')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
