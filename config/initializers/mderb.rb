# rendering of templates for static pages
# first processes erb, then markdown

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTMLwithRouge < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # yep, that's it.
end

module MarkdownHandler
  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.call(template)
    erb_compiled = erb.call(template)
    "Redcarpet::Markdown.new(HTMLwithRouge, fenced_code_blocks: true, no_intra_emphasis: true, autolink: true).render(begin;#{erb_compiled};end).html_safe"
  end
end

ActionView::Template.register_template_handler :mderb, MarkdownHandler
