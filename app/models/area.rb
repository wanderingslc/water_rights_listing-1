class Area < ActiveRecord::Base
  has_many :wanteds, dependent: :destroy
  has_many :for_sales, dependent: :destroy
  mount_uploader :kml, KmlUploader
end
