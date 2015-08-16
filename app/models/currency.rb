class Currency < ActiveRecord::Base
  require 'money'
  require 'money/bank/google_currency'

  CURRENCY = [
    {
      name: "RUB", title: "руб"
    },
    {
      name: "USD", title: "$"
    },
    {
      name: "EUR", title: "€"
    },
    {
      name: "GBP", title: "£"
    },
    {
      name: "JPY", title: "¥"
    },
    {
      name: "CAD", title: "CAD"
    },
    {
      name: "CNY", title: "CNY"
    },
    {
      name: "AUD", title: "AUD"
    },
    {
      name: "NZD", title: "NZD"
    },
  ]

  @@redis = Redis.new(:host => "127.0.0.1", :port => "6379", :driver => :hiredis, :db => 2)

  def redis
    @@redis
  end

  def self.get_rates name
    rates = Currency.all.map do |currency|
      {id: currency.id, rate: currency.get_rate(name)}
    end
    rates.index_by{|rate| rate[:id]}
  end

  def get_rate name
    if self.name == name
      1
    else
      symbol = self.name + name
      if @@redis.exists(symbol)
        @@redis.get(symbol).to_f
      else
        bank = Money::Bank::GoogleCurrency.new
        rate = bank.get_rate(self.name, name).to_f
        @@redis.set(symbol, rate, ex: 60*60)
        @@redis.set(name+self.name, 1.0/rate, ex: 60*60)
        rate
      end
    end
  end
end
