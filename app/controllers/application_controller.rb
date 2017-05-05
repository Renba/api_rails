class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  protected

  def pagination(pagination_array, per_page)
    { pagination:
      {
        per_page: per_page.to_i,
        total_pages: pagination_array.total_pages,
        total_objects: pagination_array.total_count
      }
    }
  end
end
