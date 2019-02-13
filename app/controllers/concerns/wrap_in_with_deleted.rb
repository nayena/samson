# frozen_string_literal: true
module WrapInWithDeleted
  extend ActiveSupport::Concern

  included do
    around_action :wrap_in_with_deleted
  end

  protected

  def wrap_in_with_deleted(&block)
    if request.get? && value = (params[:with_deleted].presence || search_with_deleted?)
      klasses = value.split(",").map(&:safe_constantize)
      klasses.inject(block) { |inner, klass| -> { klass.with_deleted(&inner) } }.call
    else
      yield
    end
  end

  def search_with_deleted?
    params.dig(:search, :deleted)
  end
end
