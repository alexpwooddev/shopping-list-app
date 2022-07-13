require 'rest-client'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def get_product_health_data(product)
    url = "https://nutritionix-api.p.rapidapi.com/v1_1/search/#{product}?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat"
    api_key = ENV['NUTRITIONIX_API_KEY']
    response = RestClient.get(url, { "X-RapidAPI-Key": "#{api_key}",
                          "X-RapidAPI-Host": "nutritionix-api.p.rapidapi.com" })
    parsed_body = JSON.parse(response.body)
    first_item = parsed_body["hits"][0]
    first_item
  end
end
