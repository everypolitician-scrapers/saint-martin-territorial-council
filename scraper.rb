#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'colorize'
require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.xpath('//h3[span[@id="Mandature_mars_2012_-_2017"]]/following-sibling::table//tr[td]').each do |tr|
    tds = tr.css('td')
    data = { 
      name: tds[0].text,
      wikiname: tds[0].xpath('.//a[not(@class="new")]/@title').text,
      party: tds[1].text,
      term: 2012,
      source: url,
    }
    ScraperWiki.save_sqlite([:name, :term], data)
  end
end

scrape_list('https://fr.wikipedia.org/wiki/Conseil_territorial_de_Saint-Martin#Composition_du_conseil_territorial')
