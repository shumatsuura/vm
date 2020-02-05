require 'pry'

class VendingMachine
  attr_reader :slot_money, :sales, :menus

  #初期化（インスタンス化した際に呼ばれるメソッド）
  def initialize
    @slot_money = 0
    @sales = 0
    @menus = []
  end

  #硬貨の投入（お金投入or投入終了）
  def insert(money)
    money_type =[10,50,100,500,1000]
    if money_type.include?(money)
      @slot_money += money
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
  def show_menus
    k=0
    @menus.each do |menu|
      if @slot_money < menu.price###############ここに入れたよ！
        k +=1
        next
      end
      puts "#{k}:#{menu.name} #{menu.price}円 在庫#{menu.stock}個"
      k +=1
    end
  end

  #売り上げを確認
  def confirm_sales
    puts "今までの売上は#{@sales}円です。"
  end
  #投入金額とお金と在庫の比較（ここはリファクタリングできそう。最初の条件を最後に置く）
  def purchase(menu_number)
    if @slot_money >= @menus[menu_number].price && @menus[menu_number].stock >= 1
      fluctuation(menu_number)
      puts "#{@menus[menu_number].name}を購入しました。"
    elsif @slot_money < @menus[menu_number].price
      puts "投入金額不足です。"
    elsif @menus[menu_number].stock < 1
      puts "在庫不足です。"
    end
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

#在庫
vm.menu_add("コーラ",120,5)
vm.menu_add("レッドブル",200,5)
vm.menu_add("水",100,5)

#以下サンプル実施例
vm.insert(1000)
vm.show_menus
vm.purchase(0)
vm.show_menus
vm.confirm_sales
vm.confirm_slot_money
vm.store_stock(0,5)
vm.show_menus
vm.purchase(1)
vm.purchase(2)
vm.confirm_sales
vm.confirm_slot_money
