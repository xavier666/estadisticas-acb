class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :prepare_meta_tags, if: "request.get?"

  before_action :set_locale

  def page
    params[:page]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def prepare_meta_tags(options={})
    site_name   = "Estadísticas ACB"
    title       = [controller_name, action_name].join(" ")
    description = "Todas las estadísticas de la Liga Endesa ACB, para jugar a SuperManager. Datos de cada jornada: valoración, puntos, rebotes, asistencias, triples y brokerbasket."
    image       = options[:image] || "your-default-image-url"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    %w[estadísticas acb liga endesa valoración supermanager puntos triples asistencias rebotes brokerbasket],
      twitter: {
        site_name: site_name,
        site: '@estadisticasacb',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    #set_meta_tags options
  end


end
