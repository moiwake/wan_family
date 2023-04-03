class TopController < ApplicationController
  def index
    session.delete(:q)
    @q = Spot.ransack(params[:q])
    @ranked_spots = Spots::RankedQuery.call.eager_load(:category, :prefecture).preload(:images)
    @weekly_ranked_spots = Spots::WeeklyRankedQuery.call.preload(:images)
    @weekly_ranked_blobs = ImageBlobs::WeeklyRankedQuery.call.preload(attachments: :record)
  end

  def map_search
    @spots = Spot.eager_load(:category)
    @focus_area = params[:region]
  end

  def word_search
    if params[:q]
      @q = Spot.ransack({ combinator: "and", groupings: set_search_groupings("and") })
    elsif session[:q]
      @q = Spot.ransack(session[:q])
    end

    @results = Spots::OrderedQuery.call(scope: @q.result(distinct: true), order_params: params).eager_load(:category).preload(:images)

    if @q.present? && params[:q]
      @q = Spot.ransack(params[:q]["and"])
      session[:q] = params[:q]["and"]
    end
  end

  private

  def set_search_groupings(search_method)
    search_params = params[:q][search_method]
    grouping_ary = []

    search_params.keys.each do |key|
      if search_params["name_or_address_cont"]
        keywords = search_params[key].split(/[\p{blank}\s]+/)
        keywords.reduce(grouping_ary){ |ary, word| ary.push({ key => word }) }
      else
        grouping_ary.push({ key => search_params[key] })
      end
    end

    return @search_groupings = grouping_ary.uniq
  end
end
