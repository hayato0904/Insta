class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy ]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    if params[:back]
      @feed = Feed.new(feed_params)
    else
      @feed = Feed.new
    end
  end

  def confirm
    @feed = current_user.feeds.build(feed_params)
    render :new if @feed.invalid?
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id #追記
    respond_to do |format|
      if @feed.save
        ContactMailer.feed_notification(@feed).deliver  ##追記
        # 下記一行をshow画面に行くのではなく、index画面に飛ばした。
        format.html { redirect_to feeds_path, notice: "Feed was successfully created." }
        # 下記一行のshowをindexに変更
        format.json { render :index, status: :created, location: @feed }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: "Feed was successfully updated." }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: "Feed was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:image, :image_cache, :content)
    end
end
