require "net/http"
require "uri"
require "nokogiri"

module Tools
  # Downloads a single Rails guide, extracts just the main <article> content
  # with Nokogiri, and returns its text so the model can answer from it.
  # The URL must be one of the values returned by ListRailsGuides — this
  # guards against the model fetching arbitrary URLs it may have hallucinated.
  class FetchRailsGuide < RubyLLM::Tool
    description <<~DESC
      Given the full URL of a Rails guide (taken from ListRailsGuides), downloads
      the page, extracts the main <article> content, and returns its text. Use the
      returned text to answer the user's question about Rails.
    DESC

    param :url,
          type: :string,
          desc: "The full guide URL, taken from the ListRailsGuides output"

    def execute(url:)
      # 1. Only fetch URLs we published in the lookup table.
      unless ListRailsGuides::GUIDES.values.include?(url)
        return { error: "'#{url}' is not a known Rails guide URL. Pick one from ListRailsGuides." }
      end

      # 2. Fetch the raw HTML.
      response = Net::HTTP.get_response(URI(url))
      return { error: "Could not fetch #{url} (HTTP #{response.code})" } unless response.is_a?(Net::HTTPSuccess)

      # 3. Parse the HTML and pull out just the <article> tag.
      doc = Nokogiri::HTML(response.body)
      article = doc.at_css("article")

      return { error: "No <article> content found at #{url}" } if article.nil?

      # 4. Return the article's HTML so code blocks, headings, and tables keep
      #    their structure — the model can then explain and reproduce code faithfully.
      { url: url, content: article.to_html }
    rescue StandardError => e
      { error: "Failed to fetch #{url}: #{e.message}" }
    end
  end
end
