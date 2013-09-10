class CategoriesController < ApplicationController

  def index
    @categories = Category.includes(:category_subscriptions).all
  end

  def show
    @category = Category.includes(:category_subscriptions).where('title = :title', title: params[:title]).first
    @pictures = Picture.where('category_id = :id', id: @category.id).page(params[:page])
  end

  def subscribe
    category_subscribe = current_user.category_subscriptions.new(category_id: params[:category_id])
    if category_subscribe.save
      respond_to do |format|
        format.js{render js:"window.location.reload();"}
      end
    else
      respond_to do |format|
        format.js{render js:"alert('Error');"}
      end
    end

  end

  def unsubscribe

    category_subscribe = CategorySubscription.where('user_id = :user_id AND category_id = :category_id', user_id: current_user.id, category_id: params[:category_id]).first

    if category_subscribe.destroy
      respond_to do |format|
        format.js{render js:"window.location.reload();"}
      end
    else
      respond_to do |format|
        format.js{render js:"alert('Error');"}
      end
    end

  end

end