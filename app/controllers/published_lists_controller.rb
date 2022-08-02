require 'pry'

class PublishedListsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # TODO
    # return all published lists
  end
end
