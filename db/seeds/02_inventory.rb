puts "Cleaning Inventory..."
InventoryItem.destroy_all

InventoryItem.create!([
  { name: "TRT 6A Receipt", category: "Security", quantity: 500, unit: "leaflets", low_stock_threshold: 50 },
  { name: "Personal Income Tax (PIT)", category: "Security", quantity: 200, unit: "booklets", low_stock_threshold: 20 },
  { name: "PAYE Receipt", category: "Security", quantity: 15, unit: "booklets", low_stock_threshold: 30 },
  { name: "A4 Paper", category: "Stationary", quantity: 100, unit: "reams", low_stock_threshold: 10 }
])
