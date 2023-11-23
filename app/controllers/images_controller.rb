class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy ]


  def index
    @cloudinary_images = Cloudinary::Api.resources(type: "upload", max_results: 100)

    respond_to do |format|
      format.json { render json: @cloudinary_images }
    end
  end

 
  def show
  end

 
  def new
    @image = Image.new
  end

  def edit
  end


  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html { redirect_to image_url(@image), notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to image_url(@image), notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @image.destroy!

    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def upload_image
    file = params[:file]
  
    cloudinary_response = Cloudinary::Uploader.upload(file.path, upload_preset: ENV['CLOUDINARY_UPLOAD_PRESET'])
  
    render json: cloudinary_response
  end
  
  



  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:file, :cloudinary_photo)
    end
end
