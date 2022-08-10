class FavouritedListsController < ApplicationController

  def index
    @favourited_lists = current_user.favourited_lists
  end
end