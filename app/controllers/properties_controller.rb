class PropertiesController < ApplicationController
  before_action :validate_params

  def index
    properties = Properties::FindClosestPropertiesService.new(property_params).call
    render json: properties.to_json(
      only: [:house_number, :street, :city, :zip_code, :lat, :lng, :price]
    ), status: :ok
  end

  private

  def validate_params
    validator = PropertyParamsValidator.new(property_params).validate
    return if validator.errors.empty?

    render json: {errors: validator.errors.full_messages}, status: :unprocessable_entity
  end

  def property_params
    params.permit(
      :lat,
      :lng,
      :property_type,
      :marketing_type
    )
  end
end
