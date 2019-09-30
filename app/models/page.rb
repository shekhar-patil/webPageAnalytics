class Page < ApplicationRecord
  has_many :tags

  validate :check_url_status

  before_save do |page|
    begin
      byebug
      require "net/http"
      url = URI.parse(page.url)
      req = Net::HTTP.new(url.host, url.port)
      req.use_ssl = true
      res = req.request_head(url.path)
      check_url_status unless res.code == '200'
    rescue Exception => e
      Rails.logger.info 'Exception in before_save page model'
      Rails.logger.info e
      check_url_status
    end
  end

  after_save do |page|
    begin
      require 'open-uri'
      web_page = Nokogiri::HTML(open(page.url))
      web_page.css('h1').each do |h1_tag|
        Tag.create(text: h1_tag.text, name: 0, page_id: page.id)
      end

      web_page.css('h2').each do |h2_tag|
        Tag.create(text: h2_tag.text, name: 1, page_id: page.id)
      end

      web_page.css('h3').each do |h3_tag|
        Tag.create(text: h3_tag.text, name: 2, page_id: page.id)
      end
    rescue Exception => e
      Rails.logger.info 'Exception in before_save page model'
      Rails.logger.info e
      check_url_status
    end
  end

  private

  def check_url_status
    self.errors.add(:url, message: 'error in web page parsing')
  end
end
