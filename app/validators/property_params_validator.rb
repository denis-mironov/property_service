class PropertyParamsValidator
  include ActiveModel::Validations

  attr_reader :lat, :lng, :property_type, :marketing_type

  VALID_PROPERTY_TYPES = %w(apartment single_family_house).freeze
  VALID_MARKETING_TYPES = %w(rent sell).freeze
  LATITUDE_REGEXP_PATTERN = /^-?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,})?)$/.freeze
  LONGITUDE_REGEXP_PATTERN = /^-?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)$/.freeze

  def initialize(params={})
    @lat = params[:lat]
    @lng = params[:lng]
    @property_type = params[:property_type]
    @marketing_type = params[:marketing_type]
  end

  def validate
    validate_coordinates_presence
    validate_property_data_presence
    validate_coordinates_matching
    validate_property_type_matching if property_type.present?
    validate_marketing_type_matching if marketing_type.present?

    self
  end

  def validate_coordinates_presence
    errors.add(:latitude, 'is required') unless lat.present?
    errors.add(:longitude, 'is required') unless lng.present?
  end

  def validate_property_data_presence
    errors.add(:property_type, 'is required') unless property_type.present?
    errors.add(:marketing_type, 'is required') unless marketing_type.present?
  end

  def validate_coordinates_matching
    errors.add(:latitude, 'is invalid') if lat.present? && !lat.match(LATITUDE_REGEXP_PATTERN)
    errors.add(:longitude, 'is invalid') if lng.present? && !lng.match(LONGITUDE_REGEXP_PATTERN)
  end

  def validate_property_type_matching
    return if VALID_PROPERTY_TYPES.include?(property_type)

    errors.add(:property_type, 'is invalid')
  end

  def validate_marketing_type_matching
    return if VALID_MARKETING_TYPES.include?(marketing_type)

    errors.add(:marketing_type, 'is invalid')
  end
end
