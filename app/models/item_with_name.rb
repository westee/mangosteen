class ItemWithName
    include ActiveModel::Model
    attr_accessor :tag_name, :amount, :happened_at, :tag_ids
  
    # enum kind: {expenses: 1, income: 2 }
    validates :tag_ids, presence: true
    validates :amount, presence: true
    validates :happened_at, presence: true
    validates :kind, presence: true
    validates :tag_name, presence: true

  end
  