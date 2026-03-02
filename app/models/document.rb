class Document < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_many :versions, dependent: :destroy

  # Ensure only ONE workflow instance can ever exist per document
  has_one :workflow_instance, dependent: :destroy
  validates :title, presence: true
  validates :file, presence: true
  validates_associated :workflow_instance
  validate :acceptable_file

  audited

  private
  def acceptable_file
    return unless file.attached?
    unless file.blob.byte_size <= 10.megabytes
      errors.add(:file, "File size must be less than 10MB.")
    end
  end
end
