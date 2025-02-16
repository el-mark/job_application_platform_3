class ResultsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def obtain_results
        applicant_id = params[:applicant_id]
        work_experience = params[:work_experience]
        education = params[:education]
        job_offer = params[:job_offer]

        render status: :ok

        Thread.new do
            process_candidate(applicant_id, work_experience, education, job_offer)
        end
    end

    private

    def process_candidate(applicant_id, work_experience, education, job_offer)
        prompt = <<~PROMPT
        Evalúa al candidato para el puesto de #{job_offer}.
        Experiencia laboral: #{work_experience}
        Estudios: #{education}
        Proporciónale un puntaje de adecuación de 0 a 100, donde 100 representa al candidato ideal.
        PROMPT

        openai_api_key = ENV['OPENAI_API_KEY']
        response = HTTParty.post("https://api.openai.com/v1/completions",
            headers: {
                "Content-Type"  => "application/json",
                "Authorization" => "Bearer #{openai_api_key}"
            },
            body: {
                model: "text-davinci-003",
                prompt: prompt,
                max_tokens: 60,
                temperature: 0.7
            }.to_json
        )

        score = parse_score_from_response(response)

        callback_data = { applicant_id: applicant_id.to_i, results: score.to_i }
        HTTParty.post("http://127.0.0.1:3000/save_results",
            headers: { "Content-Type" => "application/json" },
            body: callback_data.to_json
        )
    end

    def parse_score_from_response(response)
        text = response["choices"]&.first&.dig("text") || ""
        if match = text.match(/(\d{1,3})/)
            score = match[1].to_i
            score = 100 if score > 100
            score = 0 if score < 0
            score
        else
            0
        end
    end
end
