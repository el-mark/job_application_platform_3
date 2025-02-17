class ApplicantsController < ApplicationController
  require "net/http"
  require "uri"
  require "json"

  skip_before_action :verify_authenticity_token, only: [ :save_results, :index ]

  def new
    @job_offer = job_offer
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(applicant_params)
    if @applicant.save
      uri = URI.parse("http://127.0.0.1:3001/obtain_results")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })

      request.body = {
        applicant_id: @applicant.id,
        work_experience: @applicant.work_experience,
        education: @applicant.education,
        job_offer: job_offer
      }.to_json

      response = http.request(request)

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

  def job_offer
    "Buscamos a un Fullstack developer que pueda liderar y participar en el diseño, desarrollo e implementación de soluciones completas (frontend y backend) que integren diversos sistemas mediante APIs, optimizando la infraestructura tecnológica y adoptando metodologías modernas de desarrollo bajo los principios de DevOps.\n\nÁreas Clave de Responsabilidad:\nDesarrollo Fullstack:\nImplementar y mantener aplicaciones web utilizando frameworks modernos como Nest.js y Vue.js en el frontend y Java o Laravel en el backend.\nDiseñar e integrar APIs que permitan la comunicación fluida entre diferentes sistemas y servicios externos.\nDiseñar e integrar soluciones con IA Generativa y Modelos de Inteligencia Artificial que compitan al proyecto.\n\nLiderazgo Técnico:\nGuiar al equipo de desarrollo en la adopción de buenas prácticas de codificación y metodologías ágiles.\nRevisar código y garantizar estándares de calidad en los entregables del equipo.\n\nAutomatización y Optimización:\nImplementar pipelines de CI/CD para acelerar la entrega de software utilizando herramientas como GitHub Actions, Docker y Kubernetes.\nOptimizar el rendimiento de las aplicaciones y la infraestructura para garantizar su eficiencia y escalabilidad.\n\nInfraestructura y DevOps:\nGestionar bases de datos, contenedores y orquestadores como Docker y Kubernetes para asegurar la alta disponibilidad de los sistemas.\nParticipar en la administración y mejora de la infraestructura en la nube o on-premises según las necesidades del proyecto.\n\nColaboración en Innovación:\nProponer mejoras tecnológicas y participar en la definición de la arquitectura de nuevos proyectos.\nInvestigar y adoptar tecnologías emergentes como IA Generativa para mantener competitividad y vanguardia en la plataforma.\n\nRequisitos Técnicos y Formación\nEducación: Licenciatura en Ingeniería de Sistemas, Ingeniería Electrónica, Ciencias de la Computación o áreas afines (no excluyente si se demuestra experiencia equivalente).\nExperiencia:\nMínimo 3 años de experiencia en desarrollo fullstack.\nExperiencia liderando proyectos o equipos de desarrollo es altamente valorada.\nHabilidades Técnicas Esenciales:\nEn esencia es agnóstico ya que uno de los retos será migrar nuestra actual tecnología. Sin embargo se valoran conocimientos en:\nFrontend: Vue, ReactJS, TypeScript, CSS moderno (Sass, Tailwind).\nBackend: PHP, Laravel, React, Go o Python.\nBases de Datos: PostgreSQL, NoSQL.\nInfraestructura: Docker, Kubernetes, Terraform.\nDevOps: Integración continua con herramientas como GitHub Actions, Jenkins.\nCertificaciones Deseables: Containers & Kubernetes Essentials, APIs RESTful (Intermediate).\nHabilidades Sociales y Rasgos de Personalidad\nHabilidades de liderazgo técnico con enfoque en mentoría y colaboración.\nCapacidad de priorizar tareas en un entorno ágil y dinámico.\nExcelentes habilidades de comunicación para interactuar tanto con equipos técnicos como con stakeholders no técnicos.\nMentalidad autodidacta y proactiva para aprender y adoptar nuevas tecnologías.\nRequisitos de Ubicación y Movilidad\nTrabajo híbrido con asistencia presencial a la oficina tres veces por semana.\nDisponibilidad para ajustarse a horarios colaborativos en diferentes zonas horarias.\nRango Salarial y Beneficios\nSalario competitivo ajustado a experiencia y responsabilidades.\nBeneficios adicionales: capacitaciones continuas, presupuesto para herramientas y aprendizaje, horario flexible.\nCultura e Identidad de la Empresa\nLa empresa promueve un entorno de trabajo innovador y orientado a resultados. Creemos en el aprendizaje continuo, la colaboración interdisciplinaria y la búsqueda de soluciones tecnológicas que impulsen nuestro impacto en el mercado." 
 end
end
