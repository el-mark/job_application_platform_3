class Applicant < ApplicationRecord
    has_one_attached :cv

    validates :names, :phone, :work_experience, :education, presence: true
    validate :cv_format

    private

    def cv_format
      return unless cv.attached?
      unless cv.content_type == "application/pdf"
        errors.add(:cv, "debe ser un archivo PDF")
      end
    end
end
