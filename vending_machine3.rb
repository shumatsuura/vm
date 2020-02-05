require 'pry'

class VendingMachine
  attr_accessor :slot_money, :sales, :menus

  def initialize
    self.slot_money = 0
    self.sales = 0
    self.menus = []
  end

  def insert
    while true do
      puts "お金を投入してください。"
      money_type =[10,50,100,500,1000,"投入終了"]

      n = 0

      money_type.each do |money|
        puts "#{n}:#{money}"
        n +=1
      end

      i = gets.chomp.to_i
      if i == 5
        puts "投入額#{self.slot_money}"
        return self.slot_money
      else
        self.slot_money = self.slot_money + money_type[i]
        puts "現在の投入額#{self.slot_money}"
      end
    end
  end

  def refund
    change = self.slot_money
    puts "お釣りは#{change}円です。"
    self.slot_money = 0
  end

  def fluc(menu_number)
    self.sales += self.menus[menu_number].price
    self.slot_money -= self.menus[menu_number].price
    self.menus[menu_number].stock -= 1
  end

  def show_menus
    puts "何を購入しますか。選択してください。"

    k=0
    self.menus.each do |menu|
      puts "#{k}:#{menu.name} #{menu.price}円 在庫#{menu.stock}個"
      k +=1
    end

    menu_number = gets.chomp.to_i
    puts "#{self.menus[menu_number].name},#{self.menus[menu_number].price}円を購入します。"
    return menu_number
  end

  def confirm_slot_money
    puts "現在の投入額は#{self.slot_money}円です。"
  end

  def confirm_sales
    puts "今までの売り上げは#{self.sales}円です。"
  end

  def transaction(menu_number)
    if self.slot_money >= self.menus[menu_number].price && self.menus[menu_number].stock >= 1

      self.fluc(menu_number)
      puts self.menus[menu_number].stock

    elsif self.slot_money < self.menus[menu_number].price
      puts "お金が足りません"
    elsif self.menus[menu_number].stock < 1
      puts "在庫がありません"
    end
  end

end

class Menu
  attr_accessor :name, :price, :stock
  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end
end

vm = VendingMachine.new
vm.menus.push(Menu.new("コーラ",120,5))
vm.menus.push(Menu.new("レッドブル",200,5))
vm.menus.push(Menu.new("水",100,5))


def select_action
  actions =["お金を入れる","商品を選んで購入する","お釣りをもらう","投入金額を確認する","売上を確認する","帰る"]
  puts "メニューを選んでください。"
  i = 0
  actions.each do |action|
    puts "#{i}:#{action}"
    i += 1
  end
  selected_action = gets.chomp.to_i
end

while true do
  case select_action
    when 0
      vm.insert
    when 1
      menu_number=vm.show_menus
      vm.transaction(menu_number)
    when 2
      vm.refund
    when 3
      vm.confirm_slot_money
    when 4
      vm.confirm_sales
    when 5
      return
  end
end
