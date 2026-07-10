module ApplicationHelper
  # Rails' default allowlist has no table tags, and Markdown tables need them.
  ALLOWED_TAGS = Rails::HTML5::SafeListSanitizer.allowed_tags + %w[table thead tbody tr th td]

  # Renders assistant-authored Markdown as HTML.
  # The output is marked html_safe, so every layer below is load-bearing:
  #   filter_html      - drops raw HTML tags in the source text
  #   safe_links_only  - drops javascript:/data: URLs in [text](link) syntax
  #   sanitize         - final allowlist pass, in case the two above are bypassed
  # Assistant text is untrusted: FetchRailsGuide feeds web pages into the model.
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, safe_links_only: true, hard_wrap: true)
    parser = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true, tables: true, autolink: true)
    sanitize(parser.render(text.to_s), tags: ALLOWED_TAGS)
  end
end
