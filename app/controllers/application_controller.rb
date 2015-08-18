class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :set_locale
  after_action :user_activity

  protect_from_forgery with: :exception

  layout :false

  
  def index
    currency_name = current_user.currency.name rescue session[:currency]["name"]

    if current_user
      gon.user = {
        currency: CurrencySerializer.new(Currency.find_by(name: currency_name)).as_json["currency"],

      }
    end


    categories = ActiveModel::ArraySerializer.new(Category.includes(:options), each_serializer: CategoryWithOptionsSerializer)
    
    gon.data = {
      categories: categories.as_json.each_slice( (categories.as_json.length/3.0).round ).to_a,
      options: ActiveModel::ArraySerializer.new(Option.all, each_serializer: OptionSerializer),
      rates: Currency.get_rates(currency_name),
      locales: [{id: "ru", title: "Русский"},{id: "en", title: "English"}],
      weight_dimensions: ActiveModel::ArraySerializer.new(WeightDimension.all, each_serializer: WeightDimensionSerializer),
      positions_offers: [{id: "positions", title: I18n.t("position.dictionary.positions")}, {id: "offers", title: I18n.t("position.dictionary.offers")}]
    }

    gon.group = {
      weight_dimensions: gon.data[:weight_dimensions].as_json.index_by{|weight_dimension| weight_dimension[:id]},
      options: gon.data[:options].as_json.index_by{|option| option[:id]},
      trade_types: I18n.t('position.dictionary.trade_types'),
      currencies: ActiveModel::ArraySerializer.new(Currency.all, each_serializer: CurrencySerializer)
    }

    gon.translation = {
      position: {
        plur: I18n.t('position.plur'),
        statuses: I18n.t('position.status').each_with_index.map{|obj, index| {id: index, title: obj[1], name: obj[0]}}
      },
      offer: {
        plur: I18n.t('offer.plur')
      },
      confirm: I18n.t('confirm'),
      category: {
        plur: I18n.t('category.plur')
      },
      message: {
        deal_plur1: I18n.t('message.position.plur1'),
        deal_plur2: I18n.t('message.position.plur2')
      },
      user: I18n.t('user'),
      dictionary: I18n.t('dictionary')
    }
    
    render template: "layouts/application"
  end

  
  private
    def set_locale
      if current_user && current_user.locale
        I18n.locale = current_user.locale.to_sym
      else
        if session[:locale] && session[:currency]
          I18n.locale = session[:locale]
        else
          if ["ru", "by", "ua", "kz"].include? extract_locale_from_accept_language_header
            session[:locale] = :ru
            session[:currency] = Currency.where(name: "RUB").first
            I18n.locale = :ru
          else
            session[:locale] = :en
            session[:currency] = Currency.where(name: "USD").first
            I18n.locale = :en
          end
        end
      end
    end

    def user_activity
      current_user.try :touch
    end

    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE']
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      else
        :en
      end
    end
    
    def authorize_private_channel channel
      PrivatePub.subscription(:channel => channel).as_json
    end
end
