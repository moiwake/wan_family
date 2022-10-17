module DeviseRedirect
  extend ActiveSupport::Concern

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Admin)
      rails_admin_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      rails_admin_path
    else
      root_path
    end
  end
end
