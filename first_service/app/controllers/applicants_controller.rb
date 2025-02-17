class ApplicantsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :save_results, :index ]

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

  # api
  def save_results
    applicant = Applicant.find_by(id: params[:applicant_id])
    if applicant
      applicant.update(
        ai_result: params[:results],
        ai_result_description: params[:response]
      )
      head :ok
    else
      head :not_found
    end
  end

  # api
  def index
    @applicants = Applicant.all
    render json: @applicants
  end

  private

  def applicant_params
    params.require(:applicant).permit(:names, :phone, :work_experience, :education, :cv)
  end
end
