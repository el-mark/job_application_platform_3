class ApplicantsController < ApplicationController
  def new
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(applicant_params)
    if @applicant.save
      redirect_to @applicant, notice: "Aplicación enviada correctamente."
    else
      render :new
    end
  end

  def show
    @applicant = Applicant.find(params[:id])
  end

  private

  def applicant_params
    params.require(:applicant).permit(:names, :phone, :work_experience, :education, :cv)
  end
end
