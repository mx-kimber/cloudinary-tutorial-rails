json.extract! image, :id, :cloudinary_photo, :created_at, :updated_at
json.url image_url(image, format: :json)
