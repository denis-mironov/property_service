class PropertiesController < ApplicationController
  before_action :validate_params

  def index
    properties = find_closest_properties
    render json: properties.to_json(only: [
      :house_number,
      :street,
      :city,
      :zip_code,
      :lat,
      :lng,
      :price
    ]), status: :ok
  end

  private

  def find_closest_properties
    radius = Property::SEARCH_RADIUS
    lat = property_params[:lat].to_f
    lng = property_params[:lng].to_f

    Property.where("
      properties.property_type = ? AND properties.offer_type = ?
      AND earth_box(ll_to_earth(properties.lat, properties.lng), #{radius}) @> ll_to_earth(#{lat}, #{lng})
      AND earth_distance(ll_to_earth(properties.lat, properties.lng), ll_to_earth(#{lat}, #{lng})) < #{radius}
    ", property_params[:property_type], property_params[:marketing_type])
  end

  def validate_params
    errors = PropertyParamsValidator.new(property_params).validate
    return if errors.empty?

    render json: {errors: errors.full_messages}, status: :unprocessable_entity
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
