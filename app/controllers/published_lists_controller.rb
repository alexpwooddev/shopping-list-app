require 'pry'

class PublishedListsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    List.where(published == true)
  end
end
