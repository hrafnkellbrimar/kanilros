# frozen_string_literal: true

require "json"
require "nokogiri"

site_root = ARGV.fetch(0, "_site")
errors = []
structured_nodes = []

Dir.glob(File.join(site_root, "**", "*.html")).sort.each do |file|
  document = Nokogiri::HTML(File.read(file))
  relative_path = file.delete_prefix("#{site_root}/")

  errors << "#{relative_path}: expected one h1" unless document.css("h1").length == 1
  errors << "#{relative_path}: missing title" if document.at_css("title")&.text.to_s.strip.empty?
  errors << "#{relative_path}: missing description" unless document.at_css('meta[name="description"]')
  errors << "#{relative_path}: missing canonical URL" unless document.at_css('link[rel="canonical"]')
  errors << "#{relative_path}: missing robots preview directives" unless document.at_css('meta[name="robots"]')

  document.css("img").each do |image|
    errors << "#{relative_path}: image missing alt attribute" unless image.key?("alt")
  end

  document.css('script[type="application/ld+json"]').each do |script|
    parsed = JSON.parse(script.text)
    structured_nodes.concat(parsed.fetch("@graph", [parsed]))
  rescue JSON::ParserError => error
    errors << "#{relative_path}: invalid JSON-LD (#{error.message})"
  end
end

music_group = structured_nodes.find { |node| node["@type"] == "MusicGroup" }
album_ids = structured_nodes
  .select { |node| node["@type"] == "MusicAlbum" }
  .map { |node| node["@id"] }
  .uniq

errors << "missing MusicGroup structured data" unless music_group
errors << "expected five unique MusicAlbum entities" unless album_ids.length == 5

abort(errors.join("
")) unless errors.empty?

html_count = Dir.glob(File.join(site_root, "**", "*.html")).length
puts "Validated #{html_count} HTML files and #{album_ids.length} albums"
