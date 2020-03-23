class VendingMachine
  attr_reader :slot_money, :sales, :menus
  MONEY =[10,50,100,500,1000].freeze
  #初期化（インスタンス化した際に呼ばれるメソッド）
  def initialize
    @slot_money = 0
    @sales = 0
    @menus = []
  end
  #硬貨の投入（お金投入or投入終了）
  def insert(money)
    if MONEY.include?(money)
      @slot_money += money
      puts "#{@slot_money}円を投入しました。"
      puts "現在の投入額#{@slot_money}"
      return @slot_money
    else
      puts "#{money}円は扱えません"
    end
  end
  #「お釣りをもらう」の処理
  def refund
    change = @slot_money
    puts "お釣りは#{change}円です。"
    @slot_money = 0
  end
  #投入金額を確認
  def confirm_slot_money
    puts "現在の投入額は#{@slot_money}円です。"
  end
  #商品の選択
  def available
    k = 0
    @menus.each do |menu|
      if (@slot_money > menu.price) && (menu.stock > 0)
        puts "#{k}:#{menu.name} #{menu.price}円 在庫#{menu.stock}個 購入可能"
        k = k ++ 1
      end
    end
  end
  #売り上げを確認
  def confirm_sales
    puts "今までの売上は#{@sales}円です。"
  end
  #投入金額とお金と在庫の比較
  def purchase(menu_number)
    if out_of_stock?(menu_number)
      puts "在庫不足です。"
    elsif enough_money?(menu_number)
      fluctuation(menu_number)
    else
      puts "投入金額不足です。"
    end
  end
  def out_of_stock?(menu_number)
    return true if @menus[menu_number].stock < 1
  end
  def enough_money?(menu_number)
    return true if @slot_money >= @menus[menu_number].price
  end
  #商品購入時の投入金額を減らし、ストックを減らす処理
  def fluctuation(menu_number)
    @sales += @menus[menu_number].price
    @slot_money -= @menus[menu_number].price
    @menus[menu_number].stock_decrease
  end
  def store_stock(menu_number,number_to_add)
    @menus[menu_number].stock_increase(number_to_add)
  end
  def menu_add(name,price,stock)
    @menus.push(Menu.new(name,price,stock))
  end
end
#ドリンクの作成
class Menu
  attr_reader :name, :price, :stock
  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end
  def stock_decrease
    def stock=(val)
      @stock = val
    end
    self.stock -= 1
  end
  def stock_increase(number_to_add)
    def stock=(val)
      @stock = val
    end
    self.stock += number_to_add
  end
end
vm = VendingMachine.new
#初期在庫
vm.menu_add("コーラ",120,5)
#在庫追加
vm.menu_add("レッドブル",200,5)
vm.menu_add("水",100,5)
#
#以下サンプル実施例
vm.insert(1000)
vm.available
vm.purchase(0)
vm.available
vm.confirm_sales
vm.confirm_slot_money
vm.store_stock(0,5)
vm.available
vm.purchase(1)
vm.purchase(2)
vm.confirm_sales
vm.confirm_slot_money
vm.menu_add("超神水",1000,1)
vm.menu_add("Super超神水",100,0)
vm.available
vm.purchase(3)
vm.available
vm.purchase(3)
