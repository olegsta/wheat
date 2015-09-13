class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :set_locale
  # after_action :user_activity
  # before_filter :user_needed, except: [:index]
  before_action :user_banned

  protect_from_forgery with: :exception

  layout :false

  serialization_scope :view_context
  
  def index

    if current_user
      gon.user = {
        currency: CurrencySerializer.new(Currency.get_from_cache(current_user.currency_id), root: false).as_json,
        info: current_user.info_from_cache
      }
    else
      gon.user = {
        currency: CurrencySerializer.new(Currency.get_from_cache(session[:currency]["id"]), root: false).as_json
      }
    end
    
    gon.data = {
      categories: Category.chunk_from_cache,
      options: ActiveModel::ArraySerializer.new(Option.all_from_cache, each_serializer: OptionSerializer).as_json,
      rates: Currency.get_rates(gon.user[:currency][:name]),
      locales: [{id: "ru", title: "Русский"},{id: "en", title: "English"}],
      weight_dimensions: ActiveModel::ArraySerializer.new(WeightDimension.all_from_cache, serializer: WeightDimensionSerializer),
      positions_offers: [{id: "positions", title: I18n.t("position.dictionary.positions")}, {id: "offers", title: I18n.t("position.dictionary.offers")}],
      currencies: ActiveModel::ArraySerializer.new(Currency.all_from_cache, each_serializer: CurrencySerializer)
    }

    gon.group = {
      weight_dimensions: WeightDimension.by_index_from_cache,
      options: Option.by_index_from_cache,
      trade_types: I18n.t('position.dictionary.trade_types'),
    }

    gon.translation = {
      position: {
        plur: I18n.t('position.plur'),
        statuses: I18n.t('position.status').map{|obj| {id: obj[0], title: obj[1]}}
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

    def user_needed
      unless current_user
        render :json => {'msg' => 'Вы не авторизованы'}, :status => 401
      end
    end

    def user_banned
      if current_user && current_user.banned?
        render :json => {'msg' => 'Вы заблокированы'}, :status => 403
        sign_out current_user
      end
    end
end
