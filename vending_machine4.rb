class VendingMachine
  attr_accessor :slot_money, :sales, :menus
  money_type =[10,50,100,500,1000]

#初期化（インスタンス化した際に呼ばれるメソッド）
  def initialize
    self.slot_money = 0
    self.sales = 0
    self.menus = []
  end
#硬貨の投入（お金投入or投入終了）
  def insert(money)
    if money_type.include?(money)
      self.slot_money = self.slot_money + money
      puts "現在の投入額#{self.slot_money}"
      return self.slot_money
    else
      puts "#{money}円は扱えません"
    end
  end
#「お釣りをもらう」の処理
  def refund
    change = self.slot_money
    puts "お釣りは#{change}円です。"
    self.slot_money = 0
  end
  #商品購入時の投入金額を減らし、ストックを減らす処理
  def fluc(menu_number)
    self.sales += self.menus[menu_number].price
    self.slot_money -= self.menus[menu_number].price
    self.menus[menu_number].stock -= 1
  end
  #投入金額を確認
  def confirm_slot_money
    puts "現在の投入額は#{self.slot_money}円です。"
  end
#商品の選択
  def show_menus
    puts "何を購入しますか。選択してください。"
    confirm_slot_money###############ここに入れたよ！
    k=0
    self.menus.each do |menu|
      if self.slot_money < menu.price###############ここに入れたよ！
        k +=1
        next
      end
      puts "#{k}:#{menu.name} #{menu.price}円 在庫#{menu.stock}個"
      k +=1
    end
    menu_number = gets.chomp.to_i
    puts "#{self.menus[menu_number].name},#{self.menus[menu_number].price}円を購入します。"
    return menu_number#このreturnの返しは？
  end
#売り上げを確認
  def confirm_sales
    puts "今までの売り上げは#{self.sales}円です。"
  end
#投入金額とお金と在庫の比較（ここはリファクタリングできそう。最初の条件を最後に置く）
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
#ドリンクの作成
class Menu
  attr_accessor :name, :price, :stock
  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end
end
#在庫登録
vm = VendingMachine.new
vm.menus.push(Menu.new("コーラ",120,5))
vm.menus.push(Menu.new("レッドブル",200,5))
vm.menus.push(Menu.new("水",100,5))
#最初の動作選択
def select_action
  actions =["お金を入れる","商品を選んで購入する","お釣りをもらう","投入金額を確認する","売り上げを確認する","帰る"]
  puts "メニューを選んでください。"
  i = 0
  actions.each do |action|
    puts "#{i}:#{action}"
    i += 1
  end
  selected_action = gets.chomp.to_i
end
#プログラム実行
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
