# rubocop:disable Layout/LineLength
class ConvertToActiveStorage < ActiveRecord::Migration[5.2]
  require "open-uri"

  def up
    ActiveRecord::Base.connection.raw_connection.prepare("active_storage_blob_statement", <<-SQL)
      INSERT INTO active_storage_blobs (
        key, filename, content_type, metadata, byte_size, checksum, created_at
      ) VALUES ($1, $2, $3, '{}', $4, $5, $6)
    SQL

    ActiveRecord::Base.connection.raw_connection.prepare("active_storage_attachment_statement", <<-SQL)
      INSERT INTO active_storage_attachments (
        name, record_type, record_id, blob_id, created_at
      ) VALUES ($1, $2, $3, LASTVAL(), $4)
    SQL

    Rails.application.eager_load!

    transaction do
      Photo.find_each.each do |photo|
        ActiveRecord::Base.connection.raw_connection.exec_prepared(
          "active_storage_blob_statement", [
            key(photo),
            photo.image_file_name,
            photo.image_content_type,
            photo.image_file_size,
            checksum(photo.image),
            photo.updated_at.iso8601,
          ]
        )

        ActiveRecord::Base.connection.raw_connection.exec_prepared(
          "active_storage_attachment_statement", [
            "image",
            photo.class.name,
            photo.id,
            photo.updated_at.iso8601,
          ]
        )
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def key(photo)
    filename = photo.image_file_name
    id_partition = ("%09d".freeze % photo.id).scan(/\d{3}/).join("/".freeze)

    "photos/images/#{id_partition}/original/#{filename}"
  end

  def checksum(image)
    url = "https:#{image.url}"

    Digest::MD5.base64digest(Net::HTTP.get(URI(url)))
  end
end
# rubocop:enable Layout/LineLength
