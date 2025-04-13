class NamespaceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
  class_option :with_routes, type: :boolean, aliases: "--routes"

  def generate_javascripts
    empty_directory "app/assets/javascripts/#{name}"
    run "cp -rp app/assets/javascripts/main.js app/assets/javascripts/#{name}/main.js"
  end

  def generate_stylesheets
    empty_directory "app/assets/stylesheets/#{name}"
    run "cp -rp app/assets/stylesheets/*.sass app/assets/stylesheets/#{name}/"
    run "cp -rp app/assets/stylesheets/components app/assets_stylesheets/#{name}/"
  end

  def append_assets_precompile
    append_file "config/initializers/assets.rb", %Q{
      Rails.application.config.assets.precompile += %w( #{name}/main.js )
      Rails.application.config.assets.precompile += %w( #{name}/main.css )
    }
  end

  def generate_views
    # layouts
    empty_directory "app/views/layouts/#{name}"
    %w[main _header].each do |file|
      run "cp -rp app/views/layouts/#{file}.html.haml app/views/layouts/#{name}/#{file}.html.haml"
    end
    gsub_file "app/views/layouts/#{name}/main.html.haml", "layouts/header", "layouts/#{name}/header"
    gsub_file "app/views/layouts/#{name}/main.html.haml", "stylesheet_link_tag 'main'", "stylesheet_link_tag '#{name}/main'"
    gsub_file "app/views/layouts/#{name}/main.html.haml", "javascript_include_tag 'main'", "javascript_include_tag '#{name}/main'"

    empty_directory "app/views/#{name}"
    empty_directory "app/views/#{name}/home"
    create_file "app/views/#{name}/home/index.html.haml"
  end

  def generate_routes
    if options[:with_routes]
      route <<-SOURCE
        namespace *#{name} do
          root to: 'home#index'
        end
      SOURCE
    end
  end
end
