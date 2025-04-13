class Bs5ScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
  class_option :namespace, type: :string, ailiases: "--namespace"
  class_option :parent, type: :string, ailiases: "--parent"
  class_option :controller_name, type: :string, ailiases: "--controller_name"

  def create_controller_file
    template "controller.rb.erb", File.join(controller_file_path, controller_file_name)
  end

  def create_view_file
    template "index.erb", File.join(view_file_path, "index.html.haml")
    template "show.erb", File.join(view_file_path, "show.html.haml")
    template "new.erb", File.join(view_file_path, "new.html.haml")
    template "edit.erb", File.join(view_file_path, "edit.html.haml")
    template "_form.erb", File.join(view_file_path, "_form.html.haml")
  end

  private
  def model_name
    name.classify.constantize.model_name
  end

  def namespaces
    (options[:namespace] || "").split("/")
  end

  def paths
    namespaces.push(model_name)
  end

  def controller_file_path
    File.join("app/controllers", options[:namespace] || "")
  end

  def controller_base_name
    options[:controller_name].presence || "#{model_name.plural}"
  end

  def controller_name
    controller_base_name
  end

  def controller_file_name
    "#{controller_base_name}_controller.rb"
  end

  def controller_class_name
    ns = namespaces.dup
    ns.push(controller_name).join("/").classify
  end

  def singular_path
    namespaces.dup.push(controller_base_name)
  end

  def plural_paths
    namespaces.dup.push(controller_base_name)
  end

  def parent_controller_class_name
    if options[:parent].present?
      parent = "#{options[:parent]}_controller"
    else
      parent = "application_controller"
    end
    parent.classify
  end

  def filter_name
    plural_paths.join("_") + "_filter"
  end

  def params_name
    plural_paths.join("_") + "_params"
  end

  def model_path
    namespaces.dup.map { |v|":#{v}" }.push("@#[model_name.singular]").join(",")
  end

  def view_file_path
    File.join("app/views", *plural_paths)
  end
end
