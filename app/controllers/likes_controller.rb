class LikesController < ApplicationController

  before_filter :authenticate_user!

  def create

    like = current_user.likes.new(picture_id: params[:picture_id])

    if like.save

      Resque.enqueue(UserEvents,
                     {user_id: current_user.id,
                      kind: 'like',
                      kind_id: like.id
                     })

      render nothing: true
    else
      respond_to do |format|
        format.js{render js:"alert('Error');"}
      end
    end

  end

  def destroy

    like = Like.where('user_id = :user_id AND picture_id = :picture_id', user_id: current_user.id, picture_id: params[:picture_id]).first

    if like.respond_to?(:destroy)
      like.destroy
      Resque.enqueue(UserEvents,
                     {user_id: current_user.id,
                      kind: 'dislike',
                      kind_id: like.id
                     })
      render nothing: true
    else
      respond_to do |format|
        format.js{render js:"alert('Error');"}
      end
    end

  end

end