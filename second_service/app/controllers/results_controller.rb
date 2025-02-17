class ResultsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def obtain_results
        applicant_id = params[:applicant_id]
        work_experience = params[:work_experience]
        education = params[:education]
        job_offer = params[:job_offer]

        render json: { message: "Candidate processing started" }, status: :ok

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
            Retorna un análisis de su adecuación y un Puntaje de adecuación final que tome todo el análisis en cuenta.
            El Puntaje de adecuación final debe ser un número del 0 a 100, donde 100 representa al candidato ideal y 0 representa a un candidato sin ninguna adecuación con el puesto.
            El Puntaje de adecuación final enciérralo en dobles llaves, ejemplo: {{31}}
        PROMPT

        client = OpenAI::Client.new(
            access_token: ENV["OPENAI_KEY"],
            log_errors: true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
          )

        response = client.chat(
            parameters: {
                model: "gpt-4o-mini", # Required.
                messages: [ { role: "user", content: prompt } ], # Required.
                temperature: 0.7
            }
        )
        text = response.dig("choices", 0, "message", "content") || ""
        score = parse_score_from_response(text)

        callback_data = {
            applicant_id: applicant_id.to_i, results: score.to_i, response: text
        }
        HTTParty.post("http://127.0.0.1:3000/save_results",
            headers: { "Content-Type" => "application/json" },
            body: callback_data.to_json
        )
    end

    # response.dig("choices", 0, "message", "content")
    def parse_score_from_response(text)
        if match = text.match(/{{\s*(\d+)\s*}}/)
            score = match[1].to_i
            score = 100 if score > 100
            score = 0 if score < 0
            score
        else
            0
        end
    end
end
