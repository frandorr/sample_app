class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      # current_user.update_attributes(:ip_address => request.ip )
      current_user.ip_address = "24.232.154.67"
      s = Geocoder.search(current_user.ip_address)

      @city = s[0].city
      @address = s[0].address
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @swap = current_user.swaps.build
      @swaps_feed_items = current_user.swaps_feed.paginate(page: params[:page])
  
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
