module Tools
  # Lists available Rails guide topics mapped directly to their full guide URLs.
  # The model reads this, picks the title that best matches the user's request,
  # and passes the matching URL to FetchRailsGuide.
  # (Verified against the live Guides Index — https://guides.rubyonrails.org/)
  class ListRailsGuides < RubyLLM::Tool
    description <<~DESC
      Returns a lookup table of every official Ruby on Rails guide, mapping each
      guide's human-readable title to its full documentation URL. Call this FIRST
      whenever the user asks anything about how Rails works, to discover which
      guide best matches their question. Then pass the chosen URL to
      FetchRailsGuide to read that guide.
    DESC

    GUIDES = {
      # Start Here
      "Getting Started with Rails" => "https://guides.rubyonrails.org/getting_started.html",
      "Install Ruby on Rails" => "https://guides.rubyonrails.org/install_ruby_on_rails.html",

      # Models
      "Active Record Basics" => "https://guides.rubyonrails.org/active_record_basics.html",
      "Active Record Migrations" => "https://guides.rubyonrails.org/active_record_migrations.html",
      "Active Record Validations" => "https://guides.rubyonrails.org/active_record_validations.html",
      "Active Record Callbacks" => "https://guides.rubyonrails.org/active_record_callbacks.html",
      "Active Record Associations" => "https://guides.rubyonrails.org/association_basics.html",
      "Active Record Query Interface" => "https://guides.rubyonrails.org/active_record_querying.html",
      "Active Model Basics" => "https://guides.rubyonrails.org/active_model_basics.html",

      # Views
      "Action View Overview" => "https://guides.rubyonrails.org/action_view_overview.html",
      "Layouts and Rendering in Rails" => "https://guides.rubyonrails.org/layouts_and_rendering.html",
      "Action View Helpers" => "https://guides.rubyonrails.org/action_view_helpers.html",
      "Action View Form Helpers" => "https://guides.rubyonrails.org/form_helpers.html",

      # Controllers
      "Action Controller Overview" => "https://guides.rubyonrails.org/action_controller_overview.html",
      "Action Controller Advanced Topics" => "https://guides.rubyonrails.org/action_controller_advanced_topics.html",
      "Rails Routing from the Outside In" => "https://guides.rubyonrails.org/routing.html",

      # Other Components
      "Active Support Core Extensions" => "https://guides.rubyonrails.org/active_support_core_extensions.html",
      "Action Mailer Basics" => "https://guides.rubyonrails.org/action_mailer_basics.html",
      "Action Mailbox Basics" => "https://guides.rubyonrails.org/action_mailbox_basics.html",
      "Action Text Overview" => "https://guides.rubyonrails.org/action_text_overview.html",
      "Active Job Basics" => "https://guides.rubyonrails.org/active_job_basics.html",
      "Active Storage Overview" => "https://guides.rubyonrails.org/active_storage_overview.html",
      "Action Cable Overview" => "https://guides.rubyonrails.org/action_cable_overview.html",

      # Digging Deeper
      "Rails Internationalization (I18n) API" => "https://guides.rubyonrails.org/i18n.html",
      "Testing Rails Applications" => "https://guides.rubyonrails.org/testing.html",
      "Debugging Rails Applications" => "https://guides.rubyonrails.org/debugging_rails_applications.html",
      "Configuring Rails Applications" => "https://guides.rubyonrails.org/configuring.html",
      "The Rails Command Line" => "https://guides.rubyonrails.org/command_line.html",
      "The Asset Pipeline" => "https://guides.rubyonrails.org/asset_pipeline.html",
      "Working with JavaScript in Rails" => "https://guides.rubyonrails.org/working_with_javascript_in_rails.html",
      "Autoloading and Reloading" => "https://guides.rubyonrails.org/autoloading_and_reloading_constants.html",
      "Using Rails for API-only Applications" => "https://guides.rubyonrails.org/api_app.html",

      # Going to Production
      "Tuning Performance for Deployment" => "https://guides.rubyonrails.org/tuning_performance_for_deployment.html",
      "Caching with Rails: An Overview" => "https://guides.rubyonrails.org/caching_with_rails.html",
      "Securing Rails Applications" => "https://guides.rubyonrails.org/security.html",
      "Error Reporting in Rails Applications" => "https://guides.rubyonrails.org/error_reporting.html",

      # Advanced Active Record
      "Multiple Databases" => "https://guides.rubyonrails.org/active_record_multiple_databases.html",
      "Active Record Encryption" => "https://guides.rubyonrails.org/active_record_encryption.html",
      "Composite Primary Keys" => "https://guides.rubyonrails.org/active_record_composite_primary_keys.html",

      # Extending Rails
      "The Basics of Creating Rails Plugins" => "https://guides.rubyonrails.org/plugins.html",
      "Rails on Rack" => "https://guides.rubyonrails.org/rails_on_rack.html",
      "Creating and Customizing Rails Generators & Templates" => "https://guides.rubyonrails.org/generators.html",

      # Contributing
      "Contributing to Ruby on Rails" => "https://guides.rubyonrails.org/contributing_to_ruby_on_rails.html",
      "API Documentation Guidelines" => "https://guides.rubyonrails.org/api_documentation_guidelines.html",
      "Guides Guidelines" => "https://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html",
      "Installing Rails Core Development Dependencies" => "https://guides.rubyonrails.org/development_dependencies_install.html",

      # Policies
      "Maintenance Policy" => "https://guides.rubyonrails.org/maintenance_policy.html"
    }.freeze

    def execute
      GUIDES
    end
  end
end
