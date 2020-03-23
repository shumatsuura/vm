# 使い方
# irbを起動
# require ‘/Users/tatsuyamatsuhashi/workspace/vending_machine/vending_machine(master).rb’
# （↑のパスは、自動販売機ファイルが入っているパスを指定する）
# 初期設定（自動販売機インスタンスと在庫インスタンスを作成して、vmとstockという変数に代入する）
# vm = VendingMachine.new
# stock = Stock.new
# 作成した自動販売機に500円を入れる
# vm.insert(500)
# 投入金額の合計を表示
# vm.total
# stock内のジュース情報を表示
# vm.sale_info(stock)
# 売り切れ表示
# vm.sold_out(stock)
# 投入したお金を払い戻し
# vm.refund
# ジュースを買う
# vm.purchase(stock)
# 売り上げ金額を表示する
# vm.sale_amount
class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @total = 0
    @sale_amount = 0
  end
  def insert(money)
    if MONEY.include?(money)
      @total += money
    else
      money
    end
  end
  def total
    @total
  end
  def reset
    @total = 0
  end
  def sale_amount
    @sale_amount
  end
  def add_sale_amount=(money)
    @sale_amount += money
  end
  def refund
    refunded_money = @total
    @total = 0
    refunded_money
  end
  def sale_info(stock)
    # puts “ボタン光ってます”
    stock.get_drink_table.each do |drink|
      if drink.stock > 0 && drink.price <= @total
        p “#{drink.name}, #{drink.price}円”
      else
        return
      end
    end
  end
  def sold_out(stock)
    stock.get_drink_table.each do |drink|
      if drink.stock == 0
        p “#{drink.name}, #{drink.price}円”
      else
        return
      end
    end
  end
  def purchase(stock)
    drink = Choice.drink_choice(stock.get_drink_table)
    if drink.stock > 0 && drink.price <= @total
      change = @total - drink.price
      self.reset
      stock.reduce(drink)
      self.add_sale_amount=(drink.price)
      puts “#{drink.name}を買いました”
      puts “#{change}円のお釣りです”
    elsif drink.stock == 0
      puts “売り切れごめんね”
    elsif drink.price > @total
      puts “お金が足りないよ”
    end
  end
end
class Drink
  attr_accessor :name, :price, :stock
  def initialize(name, price)
    @name = name
    @price = price
    @stock = 5
  end
end
class Stock
  def initialize
    @coke = Drink.new(“コーラ“, 120)
    @red_bull = Drink.new(“レッドブル“, 200)
    @water = Drink.new(“水”, 100)
    @drink_table = [@coke, @red_bull, @water]
  end
  def get_drink_table
    @drink_table
  end
  def reduce(drink)
    @coke.stock -= 1 if @coke.name == drink.name
    @red_bull.stock -= 1 if @red_bull.name == drink.name
    @water.stock -= 1 if @water.name == drink.name
  end
end
class Choice
  def self.drink_choice(drink_table)
    drinks = drink_table
    puts “コーラ：1、レッドブル：2、水：3"
    answer = gets.to_i
    case answer
      when 1
        drink = drinks[0]
      when 2
        drink = drinks[1]
      when 3
        drink = drinks[2]
      else
        self.drink_choice
    end
  end
end
