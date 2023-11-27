class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy ]


  def index
    folder_name = 'PridefulPack'
    @cloudinary_images = Cloudinary::Api.resources(type: 'upload', max_results: 100, prefix: folder_name)

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
    folder_name = 'PridefulPack'
    transformation_preset = 'scaleFill'
  
    # Use the original filename to find the existing image
    existing_image = Image.find_by(cloudinary_photo: file.original_filename)
  
    # Do nothing if the image with the same name is already present
    return if existing_image
  
    begin
      cloudinary_response = Cloudinary::Uploader.upload(
        file.path,
        upload_preset: ENV['CLOUDINARY_UPLOAD_PRESET'],
        folder: folder_name,
        transformation: { transformation: transformation_preset }
      )
  
      Image.create!(cloudinary_photo: file.original_filename, public_id: cloudinary_response['public_id'])

      render json: cloudinary_response
    rescue CloudinaryException => except
      Rails.logger.error("Error uploading image to Cloudinary: #{except.message}")
  
      render json: { error: 'Error uploading image to Cloudinary' }, status: :internal_server_error
    end
  end
  


  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:file, :cloudinary_photo)
    end
end
