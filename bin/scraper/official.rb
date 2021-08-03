#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.last.xpath('text()').first.text.tidy
          .delete_prefix('Hon ')
          .delete_prefix('Dr ')
          .sub(' MHK', '')
          .sub(' CBE', '')
    end

    field :position do
      noko.first.text
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      # Members aren't separated, but each has 3 <p> sections in a row
      noko.css('.main-content p').each_slice(3)
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
